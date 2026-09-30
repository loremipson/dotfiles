#!/bin/sh

font="$HOME/Library/Fonts/sketchybar-app-font.ttf"
cache="${TMPDIR:-/tmp}/sketchybar-app-font-v1.tsv"

# App mappings live in the APPM record of the font's OpenType meta table.

read_u16() {
  set -- $(od -An -tu1 -j "$1" -N 2 "$font")
  printf '%s' "$(( $1 * 256 + $2 ))"
}

read_u32() {
  set -- $(od -An -tu1 -j "$1" -N 4 "$font")
  printf '%s' "$(( $1 * 16777216 + $2 * 65536 + $3 * 256 + $4 ))"
}

build_cache() {
  table_count=$(read_u16 4)
  table_index=0
  meta_offset=

  while [ "$table_index" -lt "$table_count" ]; do
    record_offset=$((12 + table_index * 16))
    tag=$(dd if="$font" bs=1 skip="$record_offset" count=4 2>/dev/null)
    if [ "$tag" = "meta" ]; then
      meta_offset=$(read_u32 $((record_offset + 8)))
      break
    fi
    table_index=$((table_index + 1))
  done

  [ -n "$meta_offset" ] || return 1

  map_count=$(read_u32 $((meta_offset + 12)))
  map_index=0
  app_map_offset=
  app_map_length=

  while [ "$map_index" -lt "$map_count" ]; do
    record_offset=$((meta_offset + 16 + map_index * 12))
    tag=$(dd if="$font" bs=1 skip="$record_offset" count=4 2>/dev/null)
    if [ "$tag" = "APPM" ]; then
      app_map_offset=$((meta_offset + $(read_u32 $((record_offset + 4)))))
      app_map_length=$(read_u32 $((record_offset + 8)))
      break
    fi
    map_index=$((map_index + 1))
  done

  [ -n "$app_map_offset" ] || return 1

  temporary_cache="$cache.$$"
  if dd if="$font" bs=1 skip="$app_map_offset" count="$app_map_length" 2>/dev/null |
    jq -r '
      .icons[] |
      .[1] as $codepoint |
      (.[2] // [])[] |
      if endswith("*") then
        ["prefix", rtrimstr("*"), ([$codepoint] | implode)]
      else
        ["exact", ., ([$codepoint] | implode)]
      end |
      @tsv
    ' > "$temporary_cache"; then
    mv "$temporary_cache" "$cache"
  else
    rm -f "$temporary_cache"
    return 1
  fi
}

if [ ! -r "$font" ]; then
  printf ':default:'
  exit
fi

if [ ! -s "$cache" ] || [ "$font" -nt "$cache" ]; then
  build_cache || {
    printf ':default:'
    exit
  }
fi

emit_app_names() {
  if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
  else
    cat
  fi
}

emit_app_names "$@" | awk -F '\t' '
  NR == FNR {
    if ($1 == "exact" && !($2 in exact_icons)) {
      exact_icons[$2] = $3
    } else if ($1 == "prefix") {
      prefix_count++
      prefix_names[prefix_count] = $2
      prefix_icons[prefix_count] = $3
    }
    next
  }

  $0 != "" {
    if ($0 in exact_icons) {
      print exact_icons[$0]
      next
    }

    for (i = 1; i <= prefix_count; i++) {
      if (index($0, prefix_names[i]) == 1) {
        print prefix_icons[i]
        next
      }
    }

    print exact_icons["Default"]
  }
' "$cache" -
