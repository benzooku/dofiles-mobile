// =============================================================================
//  widgets/Battery.tsx — AstalBattery percentage + icon, click cycles profile
// =============================================================================
import { exec } from "ags"
import { createBinding, createState } from "ags"
import { Astal, Gdk, Gtk } from "ags/gtk4"
import Battery from "gi://AstalBattery?version=0.1"

const bat = Battery.get_default()

function iconName(b: Battery.Battery): string {
  if (b.get_charging()) {
    return "" // nf-fa-bolt
  }
  const pct = b.get_percentage()
  if (pct >= 0.9) return ""
  if (pct >= 0.7) return ""
  if (pct >= 0.4) return ""
  if (pct >= 0.2) return ""
  return ""
}

export default function BatteryView() {
  const pct = createBinding(bat, "percentage")
  const charging = createBinding(bat, "charging")
  const [, setTick] = createState(0)

  const cls = () => {
    const p = pct() * 100
    if (charging()) return "battery charging"
    if (p < 15) return "battery critical"
    if (p < 30) return "battery low"
    return "battery"
  }

  return (
    <button
      class={`stat battery ${cls()}`}
      onClicked={() => {
        // Cycle power-profilesctl: balanced → performance → power-saver → balanced
        exec(["bash", "-c", "powerprofilesctl list | grep -q '\\*' && powerprofilesctl cycle || powerprofilesctl set balanced"])
        setTick((n) => n + 1)
      }}
      tooltipText={pct.((p) => `${Math.round(p * 100)}%`)}
    >
      <label class="stat-icon" label={iconName(bat)} />
      <label class="stat-value" label={pct.((p) => `${Math.round(p * 100)}%`)} />
    </button>
  )
}