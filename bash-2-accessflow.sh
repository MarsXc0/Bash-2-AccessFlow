#!/usr/bin/env bash

set -euo pipefail

APP_TITLE="User & Group Manager"
APP_VERSION="1.0"
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${BASE_DIR}/logs/actions.log"
EXPORT_DIR="${BASE_DIR}/export"
SESSION_USER=""
SESSION_ROLE=""

source "${BASE_DIR}/lib/utils.sh"
source "${BASE_DIR}/lib/auth.sh"
source "${BASE_DIR}/lib/users.sh"
source "${BASE_DIR}/lib/groups.sh"
source "${BASE_DIR}/lib/reports.sh"
source "${BASE_DIR}/lib/menu.sh"

init_environment
authenticate_user
main_menu
