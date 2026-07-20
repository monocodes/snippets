#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Optimized utility for managing qBittorrent connection port.
Uses direct file-based reads via Docker Shared Volume for zero-latency,
auth-free synchronization with Gluetun.
"""

import logging
import sys
import os
from typing import Final
from distutils.util import strtobool

import qbittorrentapi

# ==========================================
# CONFIGURATION
# ==========================================
# QBit settings
_TORRENT_HOST: Final[str] = os.getenv('QBT_HOST', 'host.docker.internal')
_TORRENT_PORT: Final[int] = os.getenv('QBT_WEBUI_PORT', 8080)
_QBT_USER: Final[str] = os.getenv('QBT_USERNAME', 'admin')
_QBT_PASS: Final[str] = os.getenv('QBT_PASSWORD', 'adminadmin')
_VERIFY_CERT: Final[bool] = strtobool(os.getenv('VERIFY_QBT_WEBUI_CERT', 'False'))

# VPN settings (File Path via Shared Volume)
_VPN_PORT_FILE: Final[str] = os.getenv('GLUETUN_PORT_FILE', '/tmp/gluetun/forwarded_port')

# ==========================================
# LOGGING SETUP
# ==========================================
logging.basicConfig(level=logging.INFO,
                    datefmt="%Y-%m-%d %H:%M:%S",
                    format='%(asctime)s %(name)-10s %(levelname)-8s %(message)s')
logger = logging.getLogger("port-tool")


def get_vpn_port_from_file(file_path: str) -> int:
    """Reads the forwarded port directly from Gluetun's state file."""
    try:
        with open(file_path, 'r') as f:
            port = int(f.read().strip())
            if 1023 < port < 65535:
                return port
            else:
                logger.error(f"Invalid port range read from file: {port}")
                sys.exit(1)
    except FileNotFoundError:
        logger.error(f"Port file not found at {file_path}. Is the Docker Volume mounted?")
        sys.exit(1)
    except ValueError as e:
        logger.error(f"Failed to parse port data: {e}")
        sys.exit(1)


def main():
    logger.info("Initializing qBittorrent port sync (Volume-Based)")

    # 1. Fetch VPN Port locally (Bypassing HTTP/Auth completely)
    vpn_port = get_vpn_port_from_file(_VPN_PORT_FILE)
    logger.info(f"Gluetun Forwarded Port: {vpn_port}")

    # 2. Connect to qBittorrent via WebAPI
    try:
        qbt_client = qbittorrentapi.Client(
            host=f'http://{_TORRENT_HOST}:{_TORRENT_PORT}',
            username=_QBT_USER,
            password=_QBT_PASS,
            VERIFY_WEBUI_CERTIFICATE=_VERIFY_CERT
        )
        qbt_client.auth_log_in()
        logger.info(f'qBittorrent Version: {qbt_client.app.version} | API: {qbt_client.app.web_api_version}')

        # 3. Retrieve current qBit Port
        if "listen_port" in qbt_client.app.preferences:
            qbit_port = int(qbt_client.app.preferences["listen_port"])
            logger.info(f"Current qBittorrent Port: {qbit_port}")
        else:
            logger.error("Preference 'listen_port' missing in qBittorrent configuration.")
            sys.exit(1)

        # 4. Compare and Update
        if vpn_port != qbit_port:
            qbt_client.app.preferences = dict(listen_port=vpn_port)
            logger.info(f"SUCCESS: Port dynamically updated to {vpn_port}")
        else:
            logger.info(f"State matching ({vpn_port} == {qbit_port}). No write operations required.")

    except qbittorrentapi.LoginFailed as e:
        logger.error(f"qBittorrent Auth Failure: Check QBT_USERNAME/QBT_PASSWORD. Details: {e}")
        sys.exit(1)
    except Exception as e:
        logger.error(f"Unexpected Runtime Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()