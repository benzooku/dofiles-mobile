// =============================================================================
//  widgets/Audio.tsx — AstalAudio speaker volume + mute, scroll to change
// =============================================================================
import { createBinding } from "ags"
import { Astal, Gdk, Gtk } from "ags/gtk4"
import Audio from "gi://AstalAudio?version=0.1"

const audio = Audio.get_default()
const speaker = audio.get_default_speaker()

function volumeIcon(vol: number, muted: boolean): string {
  if (muted || vol === 0) return "󰝟"
  if (vol < 0.33) return "󰕿"
  if (vol < 0.66) return "󰖀"
  return "󰕾"
}

export default function AudioView() {
  const vol = createBinding(speaker, "volume")
  const mute = createBinding(speaker, "mute")

  return (
    <eventbox
      class={mute((m) => `stat audio ${m ? "muted" : ""}`)}
      onScroll={(self, ev) => {
        const dir = ev.get_scroll_direction()
        const direction =
          dir === Gdk.ScrollDirection.UP || dir === Gdk.ScrollDirection.RIGHT ? 1 : -1
        // Each scroll tick = 5%
        const next = Math.max(0, Math.min(1.5, speaker.get_volume() + direction * 0.05))
        speaker.set_volume(next)
      }}
      onClickPrimary={() => {
        speaker.set_mute(!speaker.get_mute())
      }}
    >
      <box>
        <label class="stat-icon" label={(() => {
          const v = vol()
          const m = mute()
          return volumeIcon(v, m)
        })()} />
        <label class="stat-value" label={vol((v) => `${Math.round(v * 100)}%`)} />
      </box>
    </eventbox>
  )
}