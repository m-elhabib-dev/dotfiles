# workspace-toggle

Per-screen workspace switching for sway on multi-monitor setups.

| Key | Action |
|---|---|
| `$mod+Tab` | Toggle between the current and previous workspace **on the focused screen** (never jumps to another monitor) |
| `$mod+Shift+Tab` | Focus the active workspace/window on the other screen |

## How it works

`workspace-toggle watch` (in `bin/sway/`) listens to sway workspace events and remembers the previously shown workspace for each output in `$XDG_RUNTIME_DIR/sway-ws-tab/<output>`. A lock keeps it to a single instance, so it's safe to start with `exec_always`.

- `workspace-toggle back`: switch to the focused output's previous workspace
- `workspace-toggle other`: focus the first other active output

## Setup

Requires `bash`, `jq`, `flock` (util-linux).

```sh
~/.config/install.sh   # links bin/sway/workspace-toggle into ~/.local/bin
```

In `config`:

```
exec_always ~/.local/bin/workspace-toggle watch
bindsym $mod+Tab exec ~/.local/bin/workspace-toggle back
bindsym $mod+Shift+Tab exec ~/.local/bin/workspace-toggle other
```
