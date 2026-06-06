#!/bin/sh

start_once() {
	name=$(basename "$1")
	pgrep -x "$name" >/dev/null 2>&1 || pgrep -f "$1" >/dev/null 2>&1 || "$@" &
}

start_process() {
	name=$1
	shift
	pgrep -x "$name" >/dev/null 2>&1 || "$@" &
}

# session services
pkill -x stalonetray >/dev/null 2>&1
start_process nm-applet nm-applet
start_once /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1
"$HOME/.config/feh/fehbg" &
start_once xfce4-power-manager
start_once dunst -config "$HOME/.config/dunst/dunstrc"
pgrep -x picom >/dev/null 2>&1 || picom -b
start_once xsettingsd
start_process diodon diodon
start_process flameshot flameshot
start_process volumeicon volumeicon
keynav_bin=$HOME/.local/bin/keynav
[ -x "$keynav_bin" ] || keynav_bin=keynav
pgrep -x keynav >/dev/null 2>&1 || "$keynav_bin" daemonize
start_process slstatus /usr/local/bin/slstatus
xset s off &
xset -dpms &

case "$WM" in
	openbox)
		exec openbox-session
		;;
	dwm|"")
		exec /usr/local/bin/dwm
		;;
	*)
		exec "$WM"
		;;
esac
