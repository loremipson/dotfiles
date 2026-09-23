#!/usr/bin/env bash

if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark; then
  # Kanso Ink
  export BAR_COLOR=0xff14171d
  export BG=0xff1f1f26
  export FG=0xffc5c9c7
  export MUTED=0xff717c7c

  export RED=0xffc4746e
  export GREEN=0xff8a9a7b
  export YELLOW=0xffc4b28a
  export BLUE=0xff8ba4b0
  export MAGENTA=0xffa292a3
  export CYAN=0xff8ea4a2
else
  # Kanso Pearl
  export BAR_COLOR=0xfff2f1ef
  export BG=0xffe2e1df
  export FG=0xff22262d
  export MUTED=0xff6d6d69

  export RED=0xffc84053
  export GREEN=0xff6f894e
  export YELLOW=0xff77713f
  export BLUE=0xff4d699b
  export MAGENTA=0xffb35b79
  export CYAN=0xff597b75
fi
