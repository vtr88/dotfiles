# dotfiles

Personal Debian 13 / suckless dotfiles for the current `soth` workstation.

This used to be an old minimal Debian/Openbox reinstall snapshot. It is now kept as a lean user-config repository for the current dwm/st/dmenu/slstatus setup: shell, X startup, lf, editor, picom, dunst, newsboat, neomutt, irssi, Taskwarrior, keynav, and NetHack config.

## Layout

- `.zshrc`, `.xinitrc`, `.Xresources`, `.gtkrc-2.0`, `.keynavrc`, `.nethackrc`, `.nethackrcx11`: top-level user config.
- `.config/`: XDG user config copied from the active machine.
- `.themes/Gruvbox/`: local GTK theme used by the session.
- `install`: current Debian package baseline.

## Deliberately excluded

This repo should not track machine secrets or runtime state:

- SSH/GPG keys and auth files
- browser/app cookies and databases
- PulseAudio runtime files
- Taskwarrior task data
- mbsync account/password config
- generated logs, caches, and lock files
- old full-system replacements like `/etc/sudoers`, `/etc/apt/sources.list`, GRUB, LightDM, and network interface files
- Codex/tool runtime directories such as `.codex/` and `.agents/`

Mail sync credentials are not tracked. Keep private mbsync config local.

## Bootstrap

Run `./install` on Debian. It installs the package baseline, copies the tracked dotfiles into `$HOME`, and backs up overwritten files under `~/.dotfiles-backup/<timestamp>/`.

The suckless programs themselves live in the separate `suckless` repo:

```text
git@github.com:vtr88/suckless.git
```

Build and install dwm, st, dmenu, slstatus, and slock from that repo. This dotfiles repo only carries user/session config around them.
