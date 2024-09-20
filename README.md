# Proxmox Network Configuration Script

## Description

This script safely applies network configuration changes to a Proxmox server with an automatic rollback mechanism if connectivity is lost. It's designed to minimize the risk of losing access to your server when modifying network settings.

## Key Features

- Applies a predefined network configuration to Proxmox
- Automatically reverts changes if network connectivity is lost
- Supports complex configurations including bonding and VLAN-aware bridges

## How It Works

1. **Backup**: Creates a backup of the current network configuration.
2. **Apply**: Applies the new network configuration.
3. **Test**: Attempts to ping 8.8.8.8 for 30 seconds.
4. **Decision**:
   - If successful ping: Keeps the new configuration.
   - If no successful ping: Reverts to the original configuration.

## Usage

1. Clone this repository or download the script.
2. Make it executable: `chmod +x apply_network_config.sh`
3. Run with sudo: `sudo ./apply_network_config.sh`

## Customization

Edit the script to modify the network configuration within the heredoc (between `cat << EOF` and `EOF`).

## Warning

This script modifies your network configuration. Always test in a non-production environment first and ensure out-of-band access to your server.

## License

[MIT](https://choosealicense.com/licenses/mit/)
