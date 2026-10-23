import { Plugin } from "@opencode/plugin/tui"
import { spawn, type ChildProcess } from "node:child_process"
import { readFileSync } from "node:fs"
import { homedir } from "node:os"
import { join } from "node:path"
import { createMemo, createSignal } from "solid-js"

const PONYTAIL_GLYPH = "\u{f15c1}"
const COFFEE_GLYPH = "\u{f06ca}"
const CONFIG_DIR = process.env.XDG_CONFIG_HOME || join(homedir(), ".config")
const LEVEL_METER = ["▁▁▁", "▄▁▁", "▄▄▁", "▄▄▄"] as const

const PONYTAIL_LEVELS = ["off", "lite", "full", "ultra"] as const
type PonytailLevel = (typeof PONYTAIL_LEVELS)[number]

const COFFEE_LEVELS = ["off", "idle", "display", "system"] as const
type CoffeeLevel = (typeof COFFEE_LEVELS)[number]

const COFFEE_FLAGS: Record<CoffeeLevel, string[]> = {
  off: [],
  idle: ["-i"],
  display: ["-i", "-d"],
  system: ["-i", "-d", "-s", "-u"],
}

const COFFEE_OPTIONS: Record<CoffeeLevel, string> = {
  off: "Off — Do not prevent any sleep",
  idle: "Prevent Idle Sleep — Keep the system awake while the agent works",
  display: "Prevent Display Sleep — Also keep the display awake",
  system: "Prevent System Sleep — Block system sleep and keep the display awake",
}

function includes<T extends string>(values: readonly T[], value: unknown): value is T {
  return typeof value === "string" && values.some((candidate) => candidate === value)
}

function readPonytailLevel(): PonytailLevel {
  const state = readText(join(CONFIG_DIR, "opencode", ".ponytail-active"))?.trim().toLowerCase()
  if (includes(PONYTAIL_LEVELS, state)) return state

  const environmentDefault = process.env.PONYTAIL_DEFAULT_MODE?.trim().toLowerCase()
  if (includes(PONYTAIL_LEVELS, environmentDefault)) return environmentDefault

  const config = readText(join(CONFIG_DIR, "ponytail", "config.json"))
  if (config) {
    try {
      const parsed: unknown = JSON.parse(config)
      if (typeof parsed === "object" && parsed !== null && "defaultMode" in parsed) {
        const level = parsed.defaultMode
        if (includes(PONYTAIL_LEVELS, level)) return level
      }
    } catch {}
  }

  // shortcut: mirrors Ponytail's hardcoded default; import it if the package exposes a public config API.
  return "full"
}

function readText(path: string): string | undefined {
  try {
    return readFileSync(path, "utf8")
  } catch {
    return
  }
}

export default Plugin.define({
  id: "local.status.tui",
  setup(context) {
    const [coffeeActive, setCoffeeActive] = createSignal(false)
    const [ponytailRefresh, setPonytailRefresh] = createSignal(0)
    const [coffee, updateCoffee] = context.storage.store("coffee", {
      initial: { level: "display" as CoffeeLevel },
    })

    const coffeeLevel = (): CoffeeLevel =>
      includes(COFFEE_LEVELS, coffee.level) ? coffee.level : "display"
    const ponytailLevel = createMemo(() => {
      ponytailRefresh()
      return readPonytailLevel()
    })
    const green = context.theme.text.feedback.success.base
    const dim = context.theme.text.muted

    let running = 0
    let caffeinate: ChildProcess | undefined

    const releaseCoffee = () => {
      const child = caffeinate
      caffeinate = undefined
      setCoffeeActive(false)
      child?.kill("SIGTERM")
    }

    const engageCoffee = () => {
      const level = coffeeLevel()
      if (process.platform !== "darwin" || level === "off" || caffeinate) return

      const child = spawn("caffeinate", [...COFFEE_FLAGS[level], "-w", String(process.pid)], {
        stdio: "ignore",
      })
      caffeinate = child
      setCoffeeActive(true)
      const clear = () => {
        if (caffeinate !== child) return
        caffeinate = undefined
        setCoffeeActive(false)
      }
      child.on("error", clear)
      child.on("exit", clear)
    }

    const setCoffeeLevel = async (level: CoffeeLevel) => {
      releaseCoffee()
      await updateCoffee((draft) => {
        draft.level = level
      })
      if (running > 0) engageCoffee()
    }

    const describeCoffee = () => {
      const level = coffeeLevel()
      const flags = COFFEE_FLAGS[level]
      const setting = flags.length ? `${level} (caffeinate ${flags.join(" ")})` : "off"
      return `Sleep prevention: ${setting} — assertion ${caffeinate ? "up" : "idle"}`
    }

    const stopStarted = context.data.on("session.execution.started", () => {
      running += 1
      setPonytailRefresh((value) => value + 1)
      if (running !== 1) return
      engageCoffee()
    })
    const settle = () => {
      running = Math.max(0, running - 1)
      if (running !== 0) return
      releaseCoffee()
    }
    const stopSucceeded = context.data.on("session.execution.succeeded", settle)
    const stopFailed = context.data.on("session.execution.failed", settle)
    const stopInterrupted = context.data.on("session.execution.interrupted", settle)

    const stopSlot = context.ui.slot({
      append: "prompt.footer.status",
      render: () => (
        <box flexDirection="row" flexShrink={0}>
          <text fg={coffeeActive() ? green : dim} wrapMode="none">
            {COFFEE_GLYPH}
          </text>
          <text fg={coffeeActive() ? green : dim} wrapMode="none">
            {` ${LEVEL_METER[COFFEE_LEVELS.indexOf(coffeeLevel())]}`}
          </text>
          <text fg={dim} wrapMode="none">
            {` ${PONYTAIL_GLYPH}`}
          </text>
          <text fg={dim} wrapMode="none">
            {` ${LEVEL_METER[PONYTAIL_LEVELS.indexOf(ponytailLevel())]}`}
          </text>
        </box>
      ),
    })

    context.keymap.layer(() => ({
      mode: "global",
      commands: [
        {
          id: "local.coffee",
          title: "Coffee: sleep prevention",
          group: "Coffee",
          palette: true,
          slash: { name: "coffee", arguments: true },
          run: async (input) => {
            const argument = input?.trim().split(/\s+/)[0]
            if (argument === "status") {
              await context.ui.dialog.alert({ title: `${COFFEE_GLYPH} Coffee`, message: describeCoffee() })
              return
            }
            if (includes(COFFEE_LEVELS, argument)) {
              await setCoffeeLevel(argument)
              context.ui.toast.show({ message: describeCoffee() })
              return
            }
            if (argument) {
              context.ui.toast.show({
                message: `usage: /coffee [${COFFEE_LEVELS.join(" | ")} | status]`,
                variant: "warning",
              })
              return
            }

            const selected = await context.ui.dialog.select({
              title: `${COFFEE_GLYPH} Sleep prevention`,
              current: coffeeLevel(),
              options: COFFEE_LEVELS.map((level) => ({ title: COFFEE_OPTIONS[level], value: level })),
            })
            if (!includes(COFFEE_LEVELS, selected)) return
            await setCoffeeLevel(selected)
            context.ui.toast.show({ message: describeCoffee() })
          },
        },
      ],
    }))

    return () => {
      stopStarted()
      stopSucceeded()
      stopFailed()
      stopInterrupted()
      stopSlot()
      releaseCoffee()
    }
  },
})
