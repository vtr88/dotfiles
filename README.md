# dotfiles

Personal Debian 13 / Openbox dotfiles for the current `soth` workstation.

This used to be an old minimal Debian/Openbox reinstall snapshot. It is now kept as a lean user-config repository: shell, terminal, editor, Openbox, tint2, rofi, picom, dunst, newsboat, neomutt, irssi, Taskwarrior, keynav, and NetHack config.

## Layout

- `.bashrc`, `.bash_profile`, `.Xresources`, `.gtkrc-2.0`, `.keynavrc`, `.nethackrc`, `.nethackrcx11`: top-level user config.
- `.config/`: XDG user config copied from the active machine.
- `.themes/Gruvbox/`: local GTK/Openbox theme used by the session.
- `install`: current Debian package baseline.

## Deliberately excluded

This repo should not track machine secrets or runtime state:

- SSH/GPG keys and auth files
- browser/app cookies and databases
- PulseAudio runtime files
- Taskwarrior task data
- generated logs, caches, and lock files
- old full-system replacements like `/etc/sudoers`, `/etc/apt/sources.list`, GRUB, LightDM, and network interface files

Mail, IRC, and private feed config files are tracked with credential fields replaced by `REDACTED`.

## Bootstrap

Run `./install` on Debian. It installs the package baseline, copies the tracked dotfiles into `$HOME`, and backs up overwritten files under `~/.dotfiles-backup/<timestamp>/`.

Mail, IRC, and private feed credentials must be restored locally after install because public repo copies use placeholders.
