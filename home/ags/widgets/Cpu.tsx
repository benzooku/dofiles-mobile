// =============================================================================
//  widgets/Cpu.tsx — AstalSys.cpu usage with ASCII bar
// =============================================================================
import { createBinding } from "ags"
import { Astal, Gdk, Gtk } from "ags/gtk4"
import Sys from "gi://AstalSys?version=0.1"

const sys = Sys.get_default()

function asciiBar(pct: number): string {
  const blocks = "▁▂▃▄▅▆▇█"
  const p = Math.max(0, Math.min(100, Math.round(pct)))
  const idx = Math.min(blocks.length - 1, Math.floor((p / 100) * blocks.length))
  return blocks[idx]
}

export default function Cpu() {
  // AstalSys.cpu is a pollable property; binding to it keeps the value fresh.
  const cpu = createBinding(sys, "cpu")

  return (
    <box class="stat module">
      <label class="stat-icon" label="▰" />
      <label
        class="stat-value"
        label={cpu((v) => `${asciiBar(v)} ${Math.round(v)}%`)}
      />
    </box>
  )
}