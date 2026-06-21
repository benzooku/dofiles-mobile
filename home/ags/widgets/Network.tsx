// =============================================================================
//  widgets/Network.tsx — AstalNetwork wifi/ethernet status + SSID
// =============================================================================
import { createBinding } from "ags"
import { Astal, Gdk, Gtk } from "ags/gtk4"
import Network from "gi://AstalNetwork?version=0.1"

const net = Network.get_default()

function wifiIcon(strength: number): string {
  if (strength >= 80) return "▰▰▰▰"
  if (strength >= 60) return "▰▰▰▱"
  if (strength >= 40) return "▰▰▱▱"
  if (strength >= 20) return "▰▱▱▱"
  return "▱▱▱▱"
}

export default function NetworkView() {
  const primary = createBinding(net, "primary")
  const wifi = createBinding(net, "wifi")
  const wired = createBinding(net, "wired")

  const status = () => {
    const w = wifi()
    const eth = wired()
    const p = primary()
    if (eth && p === Network.Primary.WIRED) {
      return { connected: true, ssid: "wired", icon: "󰈀" }
    }
    if (w && p === Network.Primary.WIFI) {
      return {
        connected: true,
        ssid: w.get_ssid() ?? "wifi",
        icon: wifiIcon(w.get_strength()),
      }
    }
    return { connected: false, ssid: "offline", icon: "✕" }
  }

  return (
    <box
      class={status.((s) => `stat network ${s.connected ? "connected" : "disconnected"}`)}
    >
      <label class="stat-icon" label={status.((s) => s.icon)} />
      <label
        class="stat-value"
        label={status.((s) => s.ssid)}
      />
    </box>
  )
}