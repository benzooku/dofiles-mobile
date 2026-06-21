// =============================================================================
//  widgets/Clock.tsx — time + date via createPoll
// =============================================================================
import { createPoll } from "ags"
import { Astal, Gdk, Gtk } from "ags/gtk4"

// createPoll(initial, intervalMs, cmd) runs `cmd` via /bin/sh every
// `intervalMs` and returns a reactive accessor holding the trimmed stdout.
export default function Clock() {
  const time = createPoll("", 1000, "date '+%H:%M'")
  const date = createPoll("", 60000, "date '+%a %d %b'")

  return (
    <box class="clock module">
      <label class="clock-time" label={time} />
      <label class="clock-date" label={date} />
    </box>
  )
}