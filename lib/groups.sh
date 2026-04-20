#!/usr/bin/env bash

set -euo pipefail

group_add() {
  require_root || return
  local group
  group="$(prompt_groupname)" || return
  if group_exists "${group}"; then
    wt_msg "Error" "Group already exists: ${group}" 8 50
    log_action "Add group ${group}" "exists"
    return
  fi
  groupadd "${group}"
  wt_msg "Success" "Group created: ${group}" 8 50
  log_action "Add group ${group}" "success"
}

group_modify() {
  require_root || return
  local group
  local new_group
  group="$(prompt_groupname)" || return
  if ! group_exists "${group}"; then
    wt_msg "Error" "Group not found: ${group}" 8 50
    log_action "Modify group ${group}" "not found"
    return
  fi
  new_group=$(wt_input "Modify Group" "Enter new group name:") || return
  if [ -z "${new_group}" ]; then
    wt_msg "Info" "No changes made." 8 50
    log_action "Modify group ${group}" "skipped"
    return
  fi
  if ! validate_groupname "${new_group}"; then
    wt_msg "Error" "Invalid group name." 8 50
    log_action "Modify group ${group}" "invalid"
    return
  fi
  groupmod -n "${new_group}" "${group}"
  wt_msg "Success" "Group renamed to: ${new_group}" 8 50
  log_action "Modify group ${group}" "success"
}

group_delete() {
  require_root || return
  local group
  group="$(prompt_groupname)" || return
  if ! group_exists "${group}"; then
    wt_msg "Error" "Group not found: ${group}" 8 50
    log_action "Delete group ${group}" "not found"
    return
  fi
  if wt_confirm "Confirm" "Delete group ${group}?"; then
    groupdel "${group}"
    wt_msg "Success" "Group deleted: ${group}" 8 50
    log_action "Delete group ${group}" "success"
  fi
}

group_list() {
  local tmp
  tmp=$(mktemp)
  cut -d: -f1 /etc/group | sort > "${tmp}"
  wt_textbox "Groups" "${tmp}" 20 70
  rm -f "${tmp}"
  log_action "List groups" "success"
}

group_search() {
  local term
  local tmp
  term=$(wt_input "Search Group" "Enter search term:") || return
  if [ -z "${term}" ]; then
    wt_msg "Error" "Search term cannot be empty." 8 50
    return
  fi
  tmp=$(mktemp)
  cut -d: -f1 /etc/group | sort | grep -i "${term}" > "${tmp}" || true
  if [ ! -s "${tmp}" ]; then
    wt_msg "Result" "No matches found." 8 50
  else
    wt_textbox "Result" "${tmp}" 20 70
  fi
  rm -f "${tmp}"
  log_action "Search group ${term}" "success"
}
