// =============================================================================
//  widgets/Workspaces.tsx — Hyprland workspace indicator (1..9)
// =============================================================================
import { createBinding, createState } from "ags"
import { Astal, Gdk, Gtk } from "ags/gtk4"
import Hyprland from "gi://AstalHyprland?version=0.1"

const hypr = Hyprland.get_default()

function getFocusedId(): number {
  const focused = hypr.get_focused_workspace()
  return focused ? focused.get_id() : -1
}

function isOccupied(id: number): boolean {
  return hypr.get_workspaces().some((w) => w.get_id() === id)
}

export default function Workspaces() {
  const [focused, setFocused] = createState(getFocusedId())
  const [, refresh] = createState(0)

  // Refresh focused workspace on changes
  const focusedId = createBinding(hypr, "focused-workspace")(() => {
    setFocused(getFocusedId())
  })

  const occupied = createBinding(hypr, "workspaces")(() =>
    new Set(hypr.get_workspaces().map((w) => w.get_id()))
  )

  const buttons = Array.from({ length: 9 }, (_, i) => i + 1)

  return (
    <box cssName="workspaces" class="module">
      {buttons.map((id) => {
        const isFocused = focused(id) === id
        const isEmpty = !occupied().has(id)
        const className = [
          "workspace",
          isFocused ? "active" : "",
          isEmpty ? "empty" : "occupied",
        ]
          .filter(Boolean)
          .join(" ")

        return (
          <button
            class={className}
            label={String(id)}
            onClicked={() => {
              hypr.dispatch("workspace", id.toString())
              refresh(refresh() + 1)
            }}
          />
        )
      })}
    </box>
  )
}