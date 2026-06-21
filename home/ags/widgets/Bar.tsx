// =============================================================================
//  widgets/Bar.tsx — top-level centerbox bar (LEFT | CENTER | RIGHT)
// =============================================================================
import { Astal, Gdk, Gtk } from "ags/gtk4"
import Workspaces from "./Workspaces"
import Clock from "./Clock"
import Battery from "./Battery"
import Cpu from "./Cpu"
import Network from "./Network"
import Audio from "./Audio"
import Tray from "./Tray"
import Media from "./Media"

export default function Bar() {
  return (
    <window
      name="matrix-bar"
      class="bar"
      anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT | Astal.WindowAnchor.RIGHT}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      layer={Astal.Layer.TOP}
      visible
    >
      <centerbox cssName="bar-inner">
        <box $type="start" cssName="bar-left" halign={Gtk.Align.START} hexpand>
          <Workspaces />
          <Media />
        </box>

        <box $type="center" cssName="bar-center" halign={Gtk.Align.CENTER}>
          <Clock />
        </box>

        <box $type="end" cssName="bar-right" halign={Gtk.Align.END} hexpand>
          <Cpu />
          <Network />
          <Audio />
          <Battery />
          <Tray />
        </box>
      </centerbox>
    </window>
  )
}