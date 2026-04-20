#!/usr/bin/env bash

set -euo pipefail

user_add() {
  require_root || return
  local username
  username="$(prompt_username)" || return
  if user_exists "${username}"; then
    wt_msg "Error" "User already exists: ${username}" 8 50
    log_action "Add user ${username}" "exists"
    return
  fi
  useradd -m "${username}"
  wt_msg "Success" "User created: ${username}" 8 50
  log_action "Add user ${username}" "success"
}

user_modify() {
  require_root || return
  local username
  local comment
  username="$(prompt_username)" || return
  if ! user_exists "${username}"; then
    wt_msg "Error" "User not found: ${username}" 8 50
    log_action "Modify user ${username}" "not found"
    return
  fi
  comment=$(wt_input "Modify User" "Enter full name/comment (leave blank to skip):") || return
  if [ -n "${comment}" ]; then
    usermod -c "${comment}" "${username}"
    wt_msg "Success" "User updated: ${username}" 8 50
    log_action "Modify user ${username}" "success"
  else
    wt_msg "Info" "No changes made." 8 50
    log_action "Modify user ${username}" "skipped"
  fi
}

user_delete() {
  require_root || return
  local username
  username="$(prompt_username)" || return
  if ! user_exists "${username}"; then
    wt_msg "Error" "User not found: ${username}" 8 50
    log_action "Delete user ${username}" "not found"
    return
  fi
  if wt_confirm "Confirm" "Delete user ${username}?"; then
    userdel "${username}"
    wt_msg "Success" "User deleted: ${username}" 8 50
    log_action "Delete user ${username}" "success"
  fi
}

user_list() {
  local tmp
  tmp=$(mktemp)
  cut -d: -f1 /etc/passwd | sort > "${tmp}"
  wt_textbox "Users" "${tmp}" 20 70
  rm -f "${tmp}"
  log_action "List users" "success"
}

user_search() {
  local term
  local tmp
  term=$(wt_input "Search User" "Enter search term:") || return
  if [ -z "${term}" ]; then
    wt_msg "Error" "Search term cannot be empty." 8 50
    return
  fi
  tmp=$(mktemp)
  cut -d: -f1 /etc/passwd | sort | grep -i "${term}" > "${tmp}" || true
  if [ ! -s "${tmp}" ]; then
    wt_msg "Result" "No matches found." 8 50
  else
    wt_textbox "Result" "${tmp}" 20 70
  fi
  rm -f "${tmp}"
  log_action "Search user ${term}" "success"
}

user_show_details() {
  local username
  local tmp
  username="$(prompt_username)" || return
  if ! user_exists "${username}"; then
    wt_msg "Error" "User not found: ${username}" 8 50
    log_action "Show user ${username}" "not found"
    return
  fi
  tmp=$(mktemp)
  {
    echo "User: ${username}"
    echo "-----------------------"
    getent passwd "${username}"
    echo
    id "${username}"
  } > "${tmp}"
  wt_textbox "User Details" "${tmp}" 20 70
  rm -f "${tmp}"
  log_action "Show user ${username}" "success"
}

user_disable() {
  require_root || return
  local username
  username="$(prompt_username)" || return
  if ! user_exists "${username}"; then
    wt_msg "Error" "User not found: ${username}" 8 50
    log_action "Disable user ${username}" "not found"
    return
  fi
  usermod -L "${username}"
  wt_msg "Success" "User locked: ${username}" 8 50
  log_action "Disable user ${username}" "success"
}

user_enable() {
  require_root || return
  local username
  username="$(prompt_username)" || return
  if ! user_exists "${username}"; then
    wt_msg "Error" "User not found: ${username}" 8 50
    log_action "Enable user ${username}" "not found"
    return
  fi
  usermod -U "${username}"
  wt_msg "Success" "User unlocked: ${username}" 8 50
  log_action "Enable user ${username}" "success"
}

user_change_password() {
  require_root || return
  local username
  username="$(prompt_username)" || return
  if ! user_exists "${username}"; then
    wt_msg "Error" "User not found: ${username}" 8 50
    log_action "Change password ${username}" "not found"
    return
  fi
  passwd "${username}"
  log_action "Change password ${username}" "success"
}

user_force_password_change() {
  require_root || return
  local username
  username="$(prompt_username)" || return
  if ! user_exists "${username}"; then
    wt_msg "Error" "User not found: ${username}" 8 50
    log_action "Force password change ${username}" "not found"
    return
  fi
  passwd -e "${username}"
  wt_msg "Success" "Password change forced for: ${username}" 8 50
  log_action "Force password change ${username}" "success"
}
