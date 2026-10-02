# sway-ws-tab

Per-screen workspace switching for sway on multi-monitor setups.

| Key | Action |
|---|---|
| `$mod+Tab` | Toggle between the current and previous workspace **on the focused screen** (never jumps to another monitor) |
| `$mod+Shift+Tab` | Focus the active workspace/window on the other screen |

## How it works

`sway-ws-tab watch` listens to sway workspace events and remembers the previously shown workspace for each output in `$XDG_RUNTIME_DIR/sway-ws-tab/<output>`. A lock keeps it to a single instance, so it's safe to start with `exec_always`.

- `sway-ws-tab back`: switch to the focused output's previous workspace
- `sway-ws-tab other`: focus the first other active output

## Setup

Requires `bash`, `jq`, `flock` (util-linux).

```sh
cp sway-ws-tab ~/.local/bin/ && chmod +x ~/.local/bin/sway-ws-tab
```

In `config`:

```
exec_always ~/.local/bin/sway-ws-tab watch
bindsym $mod+Tab exec ~/.local/bin/sway-ws-tab back
bindsym $mod+Shift+Tab exec ~/.local/bin/sway-ws-tab other
```
