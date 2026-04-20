#!/usr/bin/env bash

set -euo pipefail

main_menu() {
  local choice
  local title
  title="Main Menu"
  if [ -n "${SESSION_ROLE}" ]; then
    title="Main Menu (${SESSION_ROLE})"
  fi
  while true; do
    choice=$(wt --title "${title}" --menu "Select an option:" 40 120 24 \
      "01. Add User" "Add User — Add user to the system." \
      "02. Modify User" "Modify User — Modify an existing user." \
      "03. Delete User" "Delete User — Delete an existing user." \
      "04. List Users" "List Users — List all users on the system." \
      "05. Search User" "Search User — Search for a user by name." \
      "06. Show User" "Show User — Show user details." \
      "07. Add Group" "Add Group — Add a user group to the system." \
      "08. Modify Group" "Modify Group — Modify an existing group." \
      "09. Delete Group" "Delete Group — Delete an existing group." \
      "10. List Groups" "List Groups — List all groups on the system." \
      "11. Search Group" "Search Group — Search for a group by name." \
      "12. Disable User" "Disable User — Disable a user account." \
      "13. Enable User" "Enable User — Enable a user account." \
      "14. Change Password" "Change Password — Change a user's password." \
      "15. Force Password" "Force Password — Force a password change." \
      "16. Export" "Export — Export users and groups to a file." \
      "17. System Info" "System Info — Show system information." \
      "18. Disk Usage" "Disk Usage — Show disk usage summary." \
      "19. Restart Network" "Restart Network — Restart the networking service." \
      "20. About" "About — Show information about this program." \
      "21. Reboot" "Reboot — Reboot the system." \
      "22. Shutdown" "Shutdown — Shut down the system." \
      "23. Logout" "Logout — Log out of the current session." \
      3>&1 1>&2 2>&3) || break

    case "${choice}" in
      "01. Add User") user_add ;;
      "02. Modify User") user_modify ;;
      "03. Delete User") user_delete ;;
      "04. List Users") user_list ;;
      "05. Search User") user_search ;;
      "06. Show User") user_show_details ;;
      "07. Add Group") group_add ;;
      "08. Modify Group") group_modify ;;
      "09. Delete Group") group_delete ;;
      "10. List Groups") group_list ;;
      "11. Search Group") group_search ;;
      "12. Disable User") user_disable ;;
      "13. Enable User") user_enable ;;
      "14. Change Password") user_change_password ;;
      "15. Force Password") user_force_password_change ;;
      "16. Export") report_export_users_groups ;;
      "17. System Info") report_system_info ;;
      "18. Disk Usage") system_disk_usage ;;
      "19. Restart Network") system_restart_networking ;;
      "20. About") report_about ;;
      "21. Reboot") system_reboot ;;
      "22. Shutdown") system_shutdown ;;
      "23. Logout") system_logout ;;
      *) break ;;
    esac
  done
}
