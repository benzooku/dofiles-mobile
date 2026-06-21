// =============================================================================
//  widgets/Tray.tsx — AstalTray
// =============================================================================
import { createBinding } from "ags"
import { Astal, Gdk, Gtk } from "ags/gtk4"
import Tray from "gi://AstalTray?version=0.1"

const tray = Tray.get_default()

export default function TrayView() {
  const items = createBinding(tray, "items")

  return (
    <box class="tray module">
      {items((list) =>
        list.map((item) => (
          <button
            class="tray-item"
            tooltipText={item.get_tooltip_markup() ?? ""}
            onClickPrimary={() => item.activate(0, 0)}
          >
            <image gicon={item.get_gicon()} pixelSize={16} />
          </button>
        ))
      )}
    </box>
  )
}