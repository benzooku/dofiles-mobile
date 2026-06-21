// =============================================================================
//  widgets/Media.tsx — AstalMpris first player, title + play/pause button
// =============================================================================
import { createBinding, createComputed } from "ags"
import { Astal, Gdk, Gtk } from "ags/gtk4"
import Mpris from "gi://AstalMpris?version=0.1"

const mpris = Mpris.get_default()

function firstPlayer() {
  return mpris.get_players()[0] ?? null
}

export default function MediaView() {
  const players = createBinding(mpris, "players")

  const player = createComputed(() => players()[0] ?? null)

  const title = createComputed(() => {
    const p = player()
    return p ? p.get_title() ?? "" : ""
  })

  const artist = createComputed(() => {
    const p = player()
    return p ? p.get_artist() ?? "" : ""
  })

  const playing = createComputed(() => {
    const p = player()
    return p ? p.get_playback_status() === Mpris.PlaybackStatus.PLAYING : false
  })

  return (
    <box visible={title((t) => t.length > 0)} class="media module">
      <label class="media-title" label={title} />
      <label class="media-artist" label={artist} />
      <button
        class="media-btn"
        onClicked={() => {
          const p = player()
          if (!p) return
          if (p.get_playback_status() === Mpris.PlaybackStatus.PLAYING) {
            p.pause()
          } else {
            p.play()
          }
        }}
      >
        <label label={playing((pl) => (pl ? "▮▮" : "▶"))} />
      </button>
    </box>
  )
}