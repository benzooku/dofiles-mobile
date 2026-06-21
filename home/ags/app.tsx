// =============================================================================
//  app.tsx — AGS v2.3 entry point for the Matrix status bar
// =============================================================================
import { Astal, Gdk, Gtk } from "ags/gtk4"
import app from "ags/gtk4/app"
import style from "./style.scss"
import Bar from "./widgets/Bar"

// Eagerly import every widget so their side-effects (createPoll, exec, etc.)
// run once at startup.
import "./widgets/Workspaces"
import "./widgets/Clock"
import "./widgets/Battery"
import "./widgets/Cpu"
import "./widgets/Network"
import "./widgets/Audio"
import "./widgets/Tray"
import "./widgets/Media"

app.start({
  css: style,
  main() {
    return <Bar />
  },
})