#!/usr/bin/env bash

set -euo pipefail

authenticate_user() {
  local username
  while true; do
    username=$(wt_input "Login" "Username:") || exit 0
    if [ -z "${username}" ]; then
      wt_msg "Error" "Username cannot be empty." 8 50
      continue
    fi
    if ! user_exists "${username}"; then
      wt_msg "Error" "User not found: ${username}" 8 50
      continue
    fi

    if is_root; then
      SESSION_USER="${username}"
      SESSION_ROLE="root"
      wt_msg "Login" "Authenticated via sudo/root session." 8 50
      break
    else
      if [ "${username}" != "$(whoami)" ]; then
        wt_msg "Error" "You can only log in as the current user: $(whoami)" 8 60
        continue
      fi
      SESSION_USER="${username}"
      SESSION_ROLE="standard"
      break
    fi
  done
}
