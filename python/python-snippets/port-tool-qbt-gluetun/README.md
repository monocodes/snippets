# qBittorrent Forwarded Port Tool

This script is used to update the qBittorrent listening port based on the current forwarded port pulled from the VPN container.  
It has been tested with <https://github.com/linuxserver/docker-qbittorrent> and <https://github.com/qdm12/gluetun>.  If your VPN container
provides a different API for accessing the forwarded port, the class `VpnControlServerApi` would need to be updated to handle that
API instead.

## Configuration

1. Update `_TORRENT_HOST` and `_TORRENT_PORT` to match the host and port of the qBittorrent web user interface
1. Update `_VPN_HOST` and `_VPN_CTRL_PORT` to match the host and API port of the VPN container (see the [wiki](https://github.com/qdm12/gluetun/wiki/HTTP-Control-server) for API docs)
1. Change the username and password for the qBittorrent web ui to match your setup
1. Finally, make sure the Python packages `qbittorrentapi` and `requests` are installed

## Usage

You can run this script manually or on a timer (such as `cron` or `systemd`).  In either mode, the script gathers the current
qbittorrent listening port and the current VPN forwarded port.  If these do not match, the qbittorrent port is updated to match
the VPN port.
