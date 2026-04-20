#!/usr/bin/env bash

set -euo pipefail

is_root() {
  [ "$(id -u)" -eq 0 ]
}

app_backtitle() {
  local user
  local role
  user="${SESSION_USER:-$(whoami)}"
  role="${SESSION_ROLE:-standard}"
  printf "%s v%s | User: %s | Role: %s" "${APP_TITLE}" "${APP_VERSION}" "${user}" "${role}"
}

wt() {
  whiptail --backtitle "$(app_backtitle)" "$@"
}

wt_msg() {
  local title="$1"
  local text="$2"
  local height="${3:-10}"
  local width="${4:-60}"
  wt --title "${title}" --msgbox "${text}" "${height}" "${width}"
}

wt_input() {
  local title="$1"
  local text="$2"
  local height="${3:-10}"
  local width="${4:-60}"
  wt --title "${title}" --inputbox "${text}" "${height}" "${width}" 3>&1 1>&2 2>&3
}

wt_password() {
  local title="$1"
  local text="$2"
  local height="${3:-10}"
  local width="${4:-60}"
  wt --title "${title}" --passwordbox "${text}" "${height}" "${width}" 3>&1 1>&2 2>&3
}

wt_confirm() {
  local title="$1"
  local text="$2"
  local height="${3:-8}"
  local width="${4:-50}"
  wt --title "${title}" --yesno "${text}" "${height}" "${width}"
}

wt_textbox() {
  local title="$1"
  local file_path="$2"
  local height="${3:-20}"
  local width="${4:-70}"
  wt --title "${title}" --scrolltext --textbox "${file_path}" "${height}" "${width}"
}

with_tempfile() {
  local title="$1"
  local height="$2"
  local width="$3"
  local tmp
  tmp=$(mktemp)
  "$@" > "${tmp}"
  wt_textbox "${title}" "${tmp}" "${height}" "${width}"
  rm -f "${tmp}"
}

init_environment() {
  mkdir -p "${BASE_DIR}/logs" "${EXPORT_DIR}"
  touch "${LOG_FILE}"
}

log_action() {
  local action="$1"
  local result="$2"
  printf "%s | %s | %s\n" "$(date '+%F %T')" "${action}" "${result}" >> "${LOG_FILE}"
}

require_root() {
  if ! is_root; then
    wt_msg "Permission Denied" "This action requires root privileges.\nRun with sudo or as root." 10 60
    log_action "Permission check" "denied"
    return 1
  fi
  return 0
}

validate_username() {
  [[ "$1" =~ ^[a-z_][a-z0-9_-]*$ ]]
}

validate_groupname() {
  [[ "$1" =~ ^[a-z_][a-z0-9_-]*$ ]]
}

prompt_username() {
  local username
  while true; do
    username=$(wt_input "Input" "Enter username:") || return 1
    if [ -z "${username}" ]; then
      wt_msg "Error" "Username cannot be empty." 8 50
      continue
    fi
    if validate_username "${username}"; then
      printf "%s" "${username}"
      return 0
    fi
    wt_msg "Error" "Invalid username.\nUse lowercase letters, digits, '_' or '-' and start with a letter or _." 10 60
  done
}

prompt_groupname() {
  local group
  while true; do
    group=$(wt_input "Input" "Enter group name:") || return 1
    if [ -z "${group}" ]; then
      wt_msg "Error" "Group name cannot be empty." 8 50
      continue
    fi
    if validate_groupname "${group}"; then
      printf "%s" "${group}"
      return 0
    fi
    wt_msg "Error" "Invalid group name.\nUse lowercase letters, digits, '_' or '-' and start with a letter or _." 10 60
  done
}

user_exists() {
  id "$1" >/dev/null 2>&1
}

group_exists() {
  getent group "$1" >/dev/null 2>&1
}
