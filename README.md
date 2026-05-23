# dotfiles

Personal Debian 13 dotfiles for my current suckless desktop.

This repository tracks user/session configuration around a separate suckless
source tree. The window manager, terminal, menu, status bar, and lock screen are
built from:

```text
git@github.com:vtr88/suckless.git
```

## Current Stack

- `dwm` as the X window manager
- `st` as the terminal
- `dmenu` for launching
- `slstatus` for the dwm status text
- `slock` for locking
- `zsh` as the login shell
- `lf` with `ueberzug` previews
- `feh`, `picom`, `dunst`, `keynav`, `tmux`, `neovim`

## Layout

- `.zshrc`: shell config, history path, aliases, and gruvbox git prompt.
- `.xinitrc`: X session startup for dwm and user services.
- `.Xresources`: legacy X resources still kept for X clients such as NetHack.
- `.config/lf/`: lf config, gruvbox colors, previewer, and ueberzug wrapper.
- `.config/keynav/keynavrc`: keynav bindings using the XDG config path.
- `.config/feh/`, `.config/picom/`, `.config/dunst/`: session visuals and notifications.
- `.config/nvim/`, `.config/tmux/`, `.config/git/`: editor, multiplexer, and git config.
- `.config/mutt/`, `.config/newsboat/`, `.config/irssi/`: public-safe app config with credentials redacted or excluded.
- `.themes/Gruvbox/`: local GTK theme.
- `install`: Debian package baseline plus dotfile copy script.

## Not Tracked

This repo should not contain secrets or runtime state:

- SSH/GPG keys and auth files
- browser/app cookies and databases
- shell history
- Taskwarrior task data
- mbsync account/password config
- generated logs, caches, lock files, and local state
- Codex/tool runtime directories such as `.codex/` and `.agents/`
- full-system files such as `/etc/apt`, GRUB, LightDM, sudoers, and network config

Mail sync credentials are intentionally not tracked. Keep the private
`.config/mutt/.mbsyncrc` local.

## Bootstrap

Run:

```sh
./install
```

The script installs the package baseline, copies the tracked files into `$HOME`,
and backs up overwritten files under `~/.dotfiles-backup/<timestamp>/`.

After that, build and install `dwm`, `st`, `dmenu`, `slstatus`, and `slock` from
the suckless repo.
