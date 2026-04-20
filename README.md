# Bash-2-AccessFlow

Simple menu-based tool to manage Linux users and groups.

## What it does
- Add, modify, delete users
- List and search users
- Add, modify, delete groups
- List and search groups
- Lock/unlock accounts
- Change or force passwords
- Export users/groups
- Show system info and disk usage
- Restart network, reboot, shutdown

## How to run
1. Open a terminal.
2. Go to the project folder.
3. Run:

```bash
sudo ./bash-2-accessflow.sh
```

## Notes
- Some actions need root permissions.
- The tool uses `whiptail` for menus.
- Logs are saved in `logs/`.
- Exports are saved in `export/`.

## Folder structure
- `bash-2-accessflow.sh`: main script
- `lib/`: feature scripts
- `logs/`: action logs
- `export/`: exported files
