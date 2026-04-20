#!/usr/bin/env bash

set -euo pipefail

report_export_users_groups() {
  local stamp
  local out_file
  stamp="$(date '+%Y%m%d_%H%M%S')"
  out_file="${EXPORT_DIR}/users_groups_${stamp}.txt"
  {
    echo "Users:"
    cut -d: -f1 /etc/passwd | sort
    echo
    echo "Groups:"
    cut -d: -f1 /etc/group | sort
  } > "${out_file}"
  wt_msg "Export" "Exported to:\n${out_file}" 10 60
  log_action "Export users/groups" "success"
}

report_system_info() {
  local tmp
  tmp=$(mktemp)
  {
    echo "System Information"
    echo "-----------------------"
    uname -a
    echo
    uptime
    echo
    df -h /
  } > "${tmp}"
  wt_textbox "System Info" "${tmp}" 20 70
  rm -f "${tmp}"
  log_action "System info" "success"
}

report_about() {
  wt_msg "About" "${APP_TITLE}\nVersion: ${APP_VERSION}\nMenu-driven user and group management tool." 10 60
  log_action "About" "success"
}

system_reboot() {
  require_root || return
  if wt_confirm "Confirm" "Reboot the system now?"; then
    log_action "System reboot" "initiated"
    reboot
  fi
}

system_shutdown() {
  require_root || return
  if wt_confirm "Confirm" "Shutdown the system now?"; then
    log_action "System shutdown" "initiated"
    shutdown -h now
  fi
}

system_logout() {
  if wt_confirm "Confirm" "Logout current session?"; then
    log_action "System logout" "initiated"
    pkill -KILL -u "$(whoami)"
  fi
}

system_restart_networking() {
  require_root || return
  if wt_confirm "Confirm" "Restart networking service?"; then
    if systemctl restart networking >/dev/null 2>&1; then
      wt_msg "Success" "Networking service restarted." 8 50
      log_action "Restart networking" "success"
    else
      wt_msg "Error" "Failed to restart networking." 8 50
      log_action "Restart networking" "failed"
    fi
  fi
}

system_disk_usage() {
  local tmp
  tmp=$(mktemp)
  df -h > "${tmp}"
  wt_textbox "Disk Usage" "${tmp}" 20 70
  rm -f "${tmp}"
  log_action "Disk usage" "success"
}
