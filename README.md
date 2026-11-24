# Terminal Setup — macOS

End-to-end terminal environment for a fresh Mac.
**Theme:** Catppuccin Mocha across all tools.

This folder contains everything needed. Just run the steps below.

```
terminal-setup/
├── README.md            ← this guide
├── zshrc                → ~/.zshrc
├── p10k.zsh             → ~/.p10k.zsh
├── tmux.conf            → ~/.tmux.conf
├── ghostty.config       → ~/Library/Application Support/com.mitchellh.ghostty/config.ghostty
└── yazi/                → ~/.config/yazi/
```

---

## Quick Setup (TL;DR)

Run on a fresh Mac:

```sh
# 1. Install Homebrew, then put it on PATH for login shells (Apple Silicon
#    installs to /opt/homebrew, which is not on PATH by default)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv zsh)"

# 2. Install all CLI tools, apps, and fonts
brew install git zsh fzf fd bat ripgrep zoxide gh lazygit tree watch tmux yazi sevenzip poppler
brew install --cask ghostty sublime-text font-jetbrains-mono-nerd-font

# 3. Install fzf shell integration
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc

# 4. Install config files (run from this terminal-setup directory)
cp zshrc                 ~/.zshrc
cp p10k.zsh              ~/.p10k.zsh
cp tmux.conf             ~/.tmux.conf
mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
cp ghostty.config "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
mkdir -p ~/.config/yazi && cp yazi/*.toml ~/.config/yazi/ && ya pkg install

# 5. Put your API key in ~/.env (sourced by ~/.zshrc).
#    Skips if ~/.env already exists (never clobbers existing secrets);
#    umask 077 creates it as 600 from the start, with no world-readable window.
[ -f ~/.env ] || (umask 077 && printf 'export OPENAI_API_KEY="sk-..."\n' > ~/.env)

# 5b. Optional: machine-specific, non-secret config (absolute paths,
#     per-machine aliases, JAVA_HOME). Keeps `cp zshrc ~/.zshrc` safe.
#     touch ~/.zshrc.local

# 6. Open Ghostty - Zinit auto-installs on first launch
#    Powerlevel10k loads from ~/.p10k.zsh automatically

# 7. macOS: grant Ghostty Full Disk Access
#    System Settings → Privacy & Security → Full Disk Access → add Ghostty

# 8. macOS: grant Ghostty Accessibility (needed for the global Cmd+` quick terminal)
#    System Settings → Privacy & Security → Accessibility → add Ghostty
```

Done. The next sections explain what each piece does.

---

## What's installed

### CLI Tools (`brew install`)

| Tool | Purpose |
|------|---------|
| `git` | Version control |
| `zsh` | Shell (default on macOS 10.15+) |
| `fzf` | Fuzzy finder |
| `fd` | Better `find` |
| `bat` | Better `cat` (syntax highlighting) |
| `ripgrep` (`rg`) | Better `grep` |
| `zoxide` (`z`) | Smarter `cd` (frecency) |
| `gh` | GitHub CLI |
| `lazygit` | Terminal git UI |
| `tree` | Directory tree view |
| `watch` | Re-run command periodically |
| `tmux` | Terminal multiplexer |
| `yazi` | Terminal file manager (use `y` wrapper to cd to last dir on quit) |
| `sevenzip` (`7zz`) | Yazi dependency — zip/archive previews |
| `poppler` (`pdftoppm`) | Yazi dependency — PDF page previews |

### Apps (`brew install --cask`)

| App | Role |
|-----|------|
| Ghostty | Terminal emulator |
| Sublime Text | GUI editor |
| JetBrainsMono Nerd Font | Font with icons (needed for Powerlevel10k) |

### Zsh plugins (auto-installed by Zinit on first launch)

| Plugin | What it does |
|--------|-------------|
| `romkatv/powerlevel10k` | Prompt theme |
| `zsh-users/zsh-autosuggestions` | Ghost suggestions — press `→` to accept |
| `zdharma-continuum/fast-syntax-highlighting` | Live command coloring (green=valid, red=not found) |
| OMZ `git` plugin | Git aliases (`gst`, `gco`, `gcmsg`, etc.) |
| OMZ `sublime` plugin | `stt` to open dir in Sublime |

---

## 1. Ghostty (Terminal)

Config: `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`

**Settings summary:**
- Font: JetBrainsMono Nerd Font 14pt, thickened
- Theme: Catppuccin Mocha
- Cursor: bar style, no blink
- Background: 96% opacity, blur radius 20
- Window: decorations on, padding 12×10
- Titlebar: native tabs style (`macos-titlebar-style = tabs`)
- Shell integration: zsh (OSC 133 for cursor, sudo prompts, title)
- Scrollback: 10,000 lines

### Ghostty Shortcuts

| Shortcut | Action |
|----------|--------|
| `Cmd + `` ` `` | Toggle quick terminal (global, works from any app; needs Accessibility permission) |
| `Cmd + T` | New tab |
| `Cmd + W` | Close tab |
| `Cmd + [1-9]` | Switch to tab N |
| `Cmd + Shift + ,` | Reload config |
| `Cmd + D` | Split right |
| `Cmd + Shift + D` | Split down |

---

## 2. Zsh + Zinit (Shell)

Config: `~/.zshrc`

**Highlights:**
- Plugin manager: **Zinit** (auto-clones on first launch)
- History: 50,000 entries, dedup, shared across shells
- Directory navigation: `AUTO_CD`, `AUTO_PUSHD` (cd by typing folder name)
- Case-insensitive tab completion
- fzf keybindings auto-sourced
- Two untracked side files: `~/.env` for **secrets** (chmod 600), `~/.zshrc.local` for **machine-specific non-secret** config — so this `zshrc` stays portable and copyable

### Built-in Aliases

| Alias | Replaces | Why |
|-------|----------|-----|
| `cat` | `bat --paging=never` | Syntax highlighting |
| `find` | `fd` | Faster, simpler syntax |
| `grep` | `rg` (ripgrep) | Faster, respects `.gitignore` |

### Git Aliases (from OMZ git plugin)

| Alias | Command |
|-------|---------|
| `gst` | `git status` |
| `gco` | `git checkout` |
| `gcmsg "msg"` | `git commit -m "msg"` |
| `gp` | `git push` |
| `gl` | `git pull` |
| `glog` | `git log --oneline --graph` |
| `gd` | `git diff` |
| `gaa` | `git add --all` |

### fzf Key Bindings

| Shortcut | Action |
|----------|--------|
| `Ctrl + R` | Fuzzy search shell history |
| `Ctrl + T` | Fuzzy insert file path at cursor |
| `Alt + C` | Fuzzy cd into subdirectory |

### zoxide Usage

After visiting a few directories with `cd`, jump to them by fragment:
```sh
z proj          # jumps to most-visited dir matching "proj"
zi              # interactive picker (uses fzf)
```

---

## 3. Powerlevel10k (Prompt)

Config: `~/.p10k.zsh` (1720 lines — included as `p10k.zsh` in this folder)

**Layout:**
```
~/path/to/dir main ⇡1 !2 ?3              status  exec-time  jobs  py-env  ...  HH:MM:SS
❯ _
```
- Two-line prompt with blank line between commands
- Left: directory + git status, then prompt char on next line
- Right: exit code, execution time, language version managers, time
- Icon set: Nerd Font v3
- Style: Lean (no powerline blocks)

### Color Reference (Catppuccin Mocha)

| Segment | Hex | Visual |
|---------|-----|--------|
| Directory | `#cdd6f4` | text white |
| Directory shortened | `#6c7086` | muted gray |
| Directory anchor | `#89b4fa` | blue |
| Git clean | `#a6e3a1` | green |
| Git modified | `#fab387` | peach |
| Git untracked | `#f38ba8` | pink/red |
| Git conflicted | `#f38ba8` | pink/red |
| Git status loading / stale | `#6c7086` | muted gray |
| Prompt char OK | `#a6e3a1` | green |
| Prompt char error | `#f38ba8` | pink/red |
| Exit status OK / background jobs | `#a6e3a1` | green |
| Exit status error | `#f38ba8` | pink/red |
| Command execution time | `#f9e2af` | yellow |
| Time | `#6c7086` | muted gray |

Git colors are set in `my_git_formatter` inside `p10k.zsh` (the gitstatus path that is
used normally); the `POWERLEVEL9K_VCS_*_FOREGROUND` values only apply to the vcs_info
fallback. Change both if you change the palette.

To regenerate from scratch: `p10k configure` (interactive wizard).

---

## 4. tmux (Multiplexer)

Config: `~/.tmux.conf`

**Settings:**
- Prefix: `Ctrl+A` (changed from default `Ctrl+B`)
- Windows/panes start at index 1
- Mouse on, clipboard synced with macOS
- Scrollback: 50,000 lines
- 256-color + true color via Ghostty

### tmux Shortcuts

Prefix = `Ctrl+A` — press it, release, then the key.

#### Sessions

| Shortcut | Action |
|----------|--------|
| `tmux new -s name` | Create named session |
| `tmux ls` | List sessions |
| `tmux attach -t name` | Attach to session |
| `tmux kill-session -t name` | Kill session |
| `C-a d` | Detach |
| `C-a $` | Rename session |
| `C-a s` | Switch session interactively |

#### Windows (tabs)

| Shortcut | Action |
|----------|--------|
| `C-a c` | New window (inherits current path) |
| `C-a [1-9]` | Switch to window N |
| `C-a n` / `C-a p` | Next / previous window |
| `C-a ,` | Rename window |
| `C-a w` | Window list picker |
| `C-a &` | Kill window |

#### Panes (splits)

| Shortcut | Action |
|----------|--------|
| `C-a \|` | Split right |
| `C-a -` | Split down |
| `C-a h / j / k / l` | Navigate panes (vim-style) |
| `C-a H / J / K / L` | Resize pane (repeatable, 5 cells) |
| `C-a x` | Close pane |
| `C-a z` | Zoom pane (fullscreen toggle) |
| `C-a q` | Show pane numbers |
| `C-a {` / `C-a }` | Swap pane with prev / next |

#### Copy/Paste & Misc

| Shortcut | Action |
|----------|--------|
| `C-a r` | Reload config |
| `C-a [` | Enter scroll/copy mode (vim keys; `q` to exit) |
| `C-a ]` | Paste from tmux buffer |
| `C-a ?` | List all keybindings |

In copy mode (`C-a [`): use `Space` to start selecting, `Enter` to copy, then `C-a ]` to paste (auto-syncs to macOS clipboard).

### Status Bar Layout
```
[session_name]   ... window 1  window 2*  ...    current-dir  git-branch | HH:MM
```
Active window is highlighted in purple (`#cba6f7`).

---

## 5. Sublime Text (Editor)

Installed via cask. Used as the GUI editor companion to terminal workflows.

| Alias (from OMZ) | Action |
|------------------|--------|
| `stt` | Open current directory in Sublime |
| `st filename` | Open file in Sublime |

---

## Verification

After setup, verify everything works:

```sh
# Open Ghostty - should load with Catppuccin theme
# First launch: Zinit clones itself, then powerlevel10k + plugins. Wait ~10s.

# Verify tools
which bat fd rg zoxide fzf gh tmux        # all should resolve
brew --version                             # confirm brew
ghostty --version                          # confirm ghostty
tmux -V                                    # confirm tmux

# Verify zsh plugins loaded
echo $POWERLEVEL9K_MODE                    # should print "nerdfont-v3"

# Try a tmux session
tmux new -s test                           # should show Catppuccin status bar

# Try fzf
echo $FZF_DEFAULT_COMMAND                  # should show fd command
```

---

## Customization

| Want to change... | Edit |
|-------------------|------|
| Ghostty colors/font/keybinds | `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty` then `Cmd+Shift+,` |
| Prompt look | `p10k configure` (re-run wizard) OR edit `~/.p10k.zsh` |
| Shell aliases/env | `~/.zshrc` then `source ~/.zshrc` |
| tmux keys/colors | `~/.tmux.conf` then prefix + `r` to reload |

---

## Troubleshooting

**Icons look broken / question marks in prompt**
→ Set Ghostty font to "JetBrainsMono Nerd Font" exactly, or reinstall via `brew install --cask font-jetbrains-mono-nerd-font`.

**"theme 'powerlevel10k' not found"**
→ Wait — Zinit installs plugins asynchronously on first launch. Open a new shell after ~10 seconds.

**Ghostty repeatedly prompts for permissions**
→ macOS TCC. Grant Full Disk Access: System Settings → Privacy & Security → Full Disk Access → add Ghostty.

**Claude Code prompts trust check every time at `~`**
→ Don't run Claude from your home directory. `cd` into a project folder first.

**Tabs disabled in Ghostty**
→ Needs both `window-decoration = true` and `macos-titlebar-style = tabs` in Ghostty config (both already set in `ghostty.config`).

**`p10k configure` overwrites my colors**
→ Re-apply Catppuccin colors after the wizard (see Color Reference above), or just copy `p10k.zsh` from this folder.
