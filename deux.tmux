#!/usr/bin/env bash
# ============================================================
# Deux · tmux theme — TPM entry point
#
# Run automatically by TPM (Tmux Plugin Manager) on tmux start.
# Sources the chosen variant, which in turn pulls in the shared
# deux-common.conf styling.
#
# Options (set before `run '~/.tmux/plugins/tpm/tpm'`):
#   set -g @deux-variant 'dark'   # 'dark' (Embers, default) | 'light' (Linen)
# ============================================================

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

get_tmux_option() {
	local option="$1" default="$2" value
	value="$(tmux show-option -gqv "$option")"
	if [ -n "$value" ]; then
		echo "$value"
	else
		echo "$default"
	fi
}

variant="$(get_tmux_option "@deux-variant" "dark")"

case "$variant" in
light | linen)
	tmux source-file "$CURRENT_DIR/tmux/deux-light.conf"
	;;
*)
	tmux source-file "$CURRENT_DIR/tmux/deux-dark.conf"
	;;
esac
