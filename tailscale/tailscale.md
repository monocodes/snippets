---
title: tailscale
categories:
  - software
  - guides
  - notes
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [tailscale installation](#tailscale-installation)
- [tailscale commands](#tailscale-commands)
	- [tailscale cli macos](#tailscale-cli-macos)
		- [installation \& daemon management](#installation--daemon-management)
		- [connection \& session management](#connection--session-management)
		- [diagnostics \& network state](#diagnostics--network-state)
		- [advanced utilities](#advanced-utilities)
		- [tailscale: client/server version mismatch](#tailscale-clientserver-version-mismatch)
			- [root cause](#root-cause)
			- [primary fix (daemon restart)](#primary-fix-daemon-restart)
			- [hard reset (if daemon is unresponsive)](#hard-reset-if-daemon-is-unresponsive)
- [tailscale ACL](#tailscale-acl)
	- [tailscale - corporate Overlaying network / VPN / Exit-nodes](#tailscale---corporate-overlaying-network--vpn--exit-nodes)
	- [tailscale - corporate VPN with exit-nodes](#tailscale---corporate-vpn-with-exit-nodes)
	- [tailscale - homelab current ACL with grants](#tailscale---homelab-current-acl-with-grants)
	- [tailscale - homelab old ACL](#tailscale---homelab-old-acl)

## tailscale installation

- exit node

  ```bash
  curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null &&
  curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list 
  sudo apt-get update && sudo apt-get install tailscale -y &&
  echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf &&
  echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf &&
  sudo sysctl -p /etc/sysctl.d/99-tailscale.conf &&
  printf '#!/bin/sh\n\nethtool -K %s rx-udp-gro-forwarding on rx-gro-list off \n' "$(ip route show 0/0 | cut -f5 -d" ")" |\
  sudo tee /etc/networkd-dispatcher/routable.d/50-tailscale &&
  sudo chmod 755 /etc/networkd-dispatcher/routable.d/50-tailscale &&
  sudo /etc/networkd-dispatcher/routable.d/50-tailscale
  sudo tailscale login --advertise-tags=tag:exit-node --advertise-exit-node --accept-routes
  ```

- subnet router

  ```bash
  curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null &&
  curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list 
  sudo apt-get update && sudo apt-get install tailscale -y &&
  echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf &&
  echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf &&
  sudo sysctl -p /etc/sysctl.d/99-tailscale.conf &&
  printf '#!/bin/sh\n\nethtool -K %s rx-udp-gro-forwarding on rx-gro-list off \n' "$(ip route show 0/0 | cut -f5 -d" ")" |\
  sudo tee /etc/networkd-dispatcher/routable.d/50-tailscale &&
  sudo chmod 755 /etc/networkd-dispatcher/routable.d/50-tailscale &&
  sudo /etc/networkd-dispatcher/routable.d/50-tailscale
  sudo tailscale login --advertise-tags=tag:subnet-router --advertise-routes=192.168.1.0/24 --accept-routes
  ```
  
- Check if IP forwarding is working on Linux

  ```bash
  sudo sysctl net.ipv4.ip_forward
  
  # output
  net.ipv4.ip_forward = 1 # it's working
  net.ipv4.ip_forward = 0 # it's not working
  ```

---

## tailscale commands

### tailscale cli macos

#### installation & daemon management

- install the console version via homebrew (bypasses corporate edr restrictions)

```bash
brew install tailscale
```

- start the system daemon (requires root privileges to create the utun interface)

```bash
sudo brew services start tailscale
```

- stop the system daemon

```bash
sudo brew services stop tailscale
```

#### connection & session management

- basic launch (initializes connection and outputs auth url)

```bash
sudo tailscale up
```

- launch and accept subnet routes advertised by other nodes

```bash
sudo tailscale up --accept-routes
```

- forced re-authentication with a hardcoded hostname and subnet route acceptance

```bash
sudo tailscale up --force-reauth --hostname=sk-mac --accept-routes
```

- disconnect from the tailnet (stops traffic routing but keeps the session active)

```bash
sudo tailscale down
```

- state reset (destroys the current node cryptographic key and drops the session)

```bash
sudo tailscale logout
```

#### diagnostics & network state

- list peers, their ip addresses, and connection type (direct / derp relay)

```bash
tailscale status
```

- retrieve ipv4 and ipv6 addresses (100.x.x.x) of the current node

```bash
tailscale ip
```

- test end-to-end connectivity and latency to another node within the tailnet

```bash
tailscale ping <ip-or-hostname>
```

- report on udp, nat traversal, and nearest derp servers

```bash
tailscale netcheck
```

#### advanced utilities

- send a file to another node in your tailnet via taildrop

```bash
tailscale file cp <path-to-file> <hostname>:
```

- receive files sent to this mac via taildrop

```bash
tailscale file get <download-directory-path>
```

- connect to another node using tailscale ssh (if enabled in acls)

```bash
tailscale ssh <user>@<hostname>
```

- generate a diagnostic zip archive for troubleshooting and support

```bash
tailscale bugreport
```

#### tailscale: client/server version mismatch

**Warning:** `client version "X" != tailscaled server version "Y"`

##### root cause

Homebrew updated the `tailscale` CLI binary, but the `tailscaled` background daemon is still running the older version in system memory.

##### primary fix (daemon restart)

Restart the background service to load the newly installed binary.

```bash
sudo brew services restart tailscale
```

##### hard reset (if daemon is unresponsive)

If a simple restart doesn't sync the versions, perform a clean cycle to flush the state:

```bash
# 1. gracefully drop the current tunnel connections
sudo tailscale down

# 2. stop the daemon via homebrew
sudo brew services stop tailscale

# 3. start the daemon with the new binary
sudo brew services start tailscale

# 4. re-establish the tunnel and accept subnet routes
sudo tailscale up --accept-routes
```

---

## tailscale ACL

### tailscale - corporate Overlaying network / VPN / Exit-nodes

```json
{
	// Define the tags which can be applied to devices and by which users.
	"tagOwners": {
		"tag:devenv":     ["autogroup:admin"],
		"tag:infra":      ["autogroup:admin"],
		"tag:audit":      ["autogroup:admin"],
		"tag:prod-us":    ["autogroup:admin"],
		"tag:prod-eu":    ["autogroup:admin"],
		"tag:darkmatter": ["autogroup:admin"],
		// All Tailscale admins can manage which devices are tagged tag:corp and tag:prod
		// Users who are Tailscale admins can apply the tag tag:exit-node
		"tag:exit-node": ["autogroup:admin"],
	},
	"grants": [
		{ // allow all members access to their own devices
			"src": ["autogroup:member"],
			"dst": ["autogroup:self"],
			"ip":  ["*"],
		},
		{ // allow admins access to everything
			"src": ["group:vpn-admin@wallarm.com"],
			"dst": ["*"],
			"ip":  ["*"],
		},
		{ // allow exit node users access to the internet only through exit nodes
			"src": ["group:vpn-exit-node-users@wallarm.com"],
			"dst": ["autogroup:internet"],
			"via": ["tag:exit-node"],
			"ip":  ["*"],
		},
		{ // allow common users access to the internet or external apps through exit nodes or app connectors.
			"src": ["group:vpn-common-users@wallarm.com"],
			"dst": ["autogroup:internet"],
			"via": [
				"tag:devenv",
				"tag:infra",
				"tag:audit",
				"tag:prod-eu",
				"tag:prod-us",
				"tag:darkmatter",
			],
			"ip": ["*"],
		},
	],
	"nodeAttrs":
		[
			{
				"target": ["*"],
				"app":
					{
						"tailscale.com/app-connectors":
							[
								{
									"name":       "devenv",
									"connectors": ["tag:devenv"],
									"domains":    ["*.dev2.wallarm.tools"],
								},
								{
									"name":       "darkmatter",
									"connectors": ["tag:darkmatter"],
									"domains": [
										"*.darkmatter.wallarm.tools",
										"gtrrf12xdf.us-central1.gcp.clickhouse.cloud",
									],
								},
								{
									"name":       "infra",
									"connectors": ["tag:infra"],
									"domains": [
										"allure.wallarm.com",
										"vault.wallarm.com",
										"*.i.wallarm.com",
										"repolite.wallarm.com",
										"gl.wallarm.com",
										"dkr.wallarm.com",
										"*.i.gcp.wallarm.space",
									],
								},
								{
									"name":       "audit",
									"connectors": ["tag:audit"],
									"domains": [
										"audit-nodemetrics.wallarm.com",
										"qless.audit.wallarm.com",
										"grafana.audit.wallarm.com",
										"am-nodemetrics.audit.wallarm.com",
										"mon.audit.wallarm.com",
										"mon-agent.audit.wallarm.com",
										"mon-alertmanager.audit.wallarm.com",
										"mon-alert.audit.wallarm.com",
										"authorize.audit.wallarm.com",
										"authenticate.audit.wallarm.com",
										// ipfeed CH
										"jxjyeke2zh.us-east1.gcp.clickhouse.cloud",
										// sessions-api CH
										"o8id5maofk.us-east1.gcp.clickhouse.cloud",
									],
								},
								{
									"name":       "prod-eu",
									"connectors": ["tag:prod-eu"],
									"domains": [
										"eu1-nodemetrics.wallarm.com",
										"qless.eu1.wallarm.com",
										"grafana.eu1.wallarm.com",
										"am-nodemetrics.eu1.wallarm.com",
										"mon.eu1.wallarm.com",
										"mon-agent.eu1.wallarm.com",
										"mon-alertmanager.eu1.wallarm.com",
										"mon-alert.eu1.wallarm.com",
										"authorize.eu1.wallarm.com",
										"authenticate.eu1.wallarm.com",
										// Temporary for perftest
										"grafana.perf.wallarm.tools",
										// ipfeed CH
										"njblxyxaog.europe-west4.gcp.clickhouse.cloud",
										// sessions-api CH
										"uziubdiki0.europe-west4.gcp.clickhouse.cloud",
									],
								},
								{
									"name":       "prod-us",
									"connectors": ["tag:prod-us"],
									"domains": [
										"us1-nodemetrics.wallarm.com",
										"qless.us1.wallarm.com",
										"grafana.us1.wallarm.com",
										"am-nodemetrics.us1.wallarm.com",
										"mon.us1.wallarm.com",
										"mon-agent.us1.wallarm.com",
										"mon-alertmanager.us1.wallarm.com",
										"mon-alert.us1.wallarm.com",
										"authorize.us1.wallarm.com",
										"authenticate.us1.wallarm.com",
										// ipfeeds CH
										"dwm3rnqmbf.us-central1.gcp.clickhouse.cloud",
										// sessions-api CH
										"bsolbdbxww.us-central1.gcp.clickhouse.cloud",
									],
								},
							],
					},
			},
			// Exit nodes
			{"target": ["100.102.94.75"], "attr": ["mullvad"]},
			{"target": ["100.67.80.11"], "attr": ["mullvad"]},
			{"target": ["100.85.13.110"], "attr": ["mullvad"]},
		],
	"autoApprovers": {
		"exitNode":
			[
				"tag:exit-node",
				"autogroup:admin",
			],
		"routes": {
			"0.0.0.0/0": [
				"tag:devenv",
				"tag:infra",
				"tag:audit",
				"tag:prod-eu",
				"tag:prod-us",
				"tag:darkmatter",
				"autogroup:admin",
			],
			"::/0": [
				"tag:devenv",
				"tag:infra",
				"tag:audit",
				"tag:prod-eu",
				"tag:prod-us",
				"tag:darkmatter",
				"autogroup:admin",
			],
		},
	},
}

```

### tailscale - corporate VPN with exit-nodes

```json
{
	"acls": [
		// All employees can access their own devices
		{
			"action": "accept",
			"src":    ["autogroup:member"],
			"dst":    ["autogroup:self:*"],
		},
		// All employees can access devices tagged with tag:corp
		{"action": "accept", "src": ["autogroup:member"], "dst": ["tag:corp:*"]},
		// All Tailscale admins can access devices tagged with tag:prod
		{"action": "accept", "src": ["autogroup:admin"], "dst": ["tag:prod:*"]},
		// Allow all connections for admins.
		{"action": "accept", "src": ["autogroup:admin"], "dst": ["*:*"]},
		// All users can use exit nodes
		{
			"action": "accept",
			"src":    ["autogroup:member"],
			"dst":    ["autogroup:internet:*"],
		},
	],
	"tagOwners": {
		// All Tailscale admins can manage which devices are tagged tag:corp and tag:prod
		"tag:corp": ["autogroup:admin"],
		"tag:prod": ["autogroup:admin"],
		// Users who are Tailscale admins can apply the tag tag:exit-node
		"tag:exit-node":     ["autogroup:admin"],
		"tag:subnet-router": ["autogroup:admin"],
	},
	"autoApprovers": {
		// Exit nodes advertised by users who are Tailscale admins or devices tagged
		// with tag:exit-node will be automatically approved
		"exitNode": ["tag:exit-node", "autogroup:admin"],
		// Routes for subnet router advertised by users who are Tailscale admins or routes on devices tagged
		// with tag:subnet-router will be automatically approved
		"routes": {
			"0.0.0.0/0": ["tag:subnet-router", "autogroup:admin"],
			"::/0":      ["tag:subnet-router", "autogroup:admin"],
		},
	},
	"nodeAttrs": [
		{"target": ["100.102.94.75"], "attr": ["mullvad"]},
		{"target": ["100.67.80.11"], "attr": ["mullvad"]},
		{"target": ["100.85.13.110"], "attr": ["mullvad"]},
	],
}

```

### tailscale - homelab current ACL with grants

[Manage devices using the web interface](https://tailscale.com/kb/1325/device-web-interface#control-remote-access)

```json
// Example/default ACLs for unrestricted connections.
{
	// Declare static groups of users. Use autogroups for all users or users with a specific role.
	// "groups": {
	//  	"group:example": ["alice@example.com", "bob@example.com"],
	// },

	// Define the tags which can be applied to devices and by which users.
	// "tagOwners": {
	//  	"tag:example": ["autogroup:admin"],
	// },

	// Define access control lists for users, groups, autogroups, tags,
	// Tailscale IP addresses, and subnet ranges.
	"acls": [
		// Allow all connections.
		// Comment this section out if you want to define specific restrictions.
		{"action": "accept", "src": ["*"], "dst": ["*:*"]},

		// Allow users in "group:example" to access "tag:example", but only from
		// devices that are running macOS and have enabled Tailscale client auto-updating.
		// {"action": "accept", "src": ["group:example"], "dst": ["tag:example:*"], "srcPosture":["posture:autoUpdateMac"]},
	],
	"tagOwners": {
		// All Tailscale admins can manage which devices are tagged tag:shared and tag:home
		"tag:shared": ["autogroup:admin"],
		"tag:home":   ["autogroup:admin"],
		// Users who are Tailscale admins can apply the tag tag:exit-node and tag:subnet-router
		"tag:exit-node":     ["autogroup:admin"],
		"tag:subnet-router": ["autogroup:admin"],
	},
	"autoApprovers": {
		// Exit nodes advertised by users who are Tailscale admins or devices tagged
		// with tag:exit-node will be automatically approved
		"exitNode": ["tag:exit-node", "autogroup:admin"],
		// Routes for subnet router advertised by users who are Tailscale admins or routes on devices tagged
		// with tag:subnet-router will be automatically approved
		"routes": {
			"0.0.0.0/0": ["tag:subnet-router", "autogroup:admin"],
			"::/0":      ["tag:subnet-router", "autogroup:admin"],
		},
	},
	"grants": [
		{
			"src": ["serj.wander@gmail.com"],
			"dst": ["*"],
			"ip":  ["5252"],
			"app": {
				"tailscale.com/cap/webui": [
					{
						// Grants user@example.com edit access to "tag:dev" devices' web interfaces.
						"canEdit": ["ssh", "subnets"],
					},
				],
			},
		},
	],

	// Define postures that will be applied to all rules without any specific
	// srcPosture definition.
	// "defaultSrcPosture": [
	//      "posture:anyMac",
	// ],

	// Define device posture rules requiring devices to meet
	// certain criteria to access parts of your system.
	// "postures": {
	//      // Require devices running macOS, a stable Tailscale
	//      // version and auto update enabled for Tailscale.
	// 	"posture:autoUpdateMac": [
	// 	    "node:os == 'macos'",
	// 	    "node:tsReleaseTrack == 'stable'",
	// 	    "node:tsAutoUpdate",
	// 	],
	//      // Require devices running macOS and a stable
	//      // Tailscale version.
	// 	"posture:anyMac": [
	// 	    "node:os == 'macos'",
	// 	    "node:tsReleaseTrack == 'stable'",
	// 	],
	// },

	// Define users and devices that can use Tailscale SSH.
	"ssh": [
		// Allow all users to SSH into their own devices in check mode.
		// Comment this section out if you want to define specific restrictions.
		{
			"action": "check",
			"src":    ["autogroup:member"],
			"dst":    ["autogroup:self"],
			"users":  ["autogroup:nonroot", "root"],
		},
	],

	// Test access rules every time they're saved.
	// "tests": [
	//  	{
	//  		"src": "alice@example.com",
	//  		"accept": ["tag:example"],
	//  		"deny": ["100.101.102.103:443"],
	//  	},
	// ],
}

```

### tailscale - homelab old ACL

```json
// Example/default ACLs for unrestricted connections.
{
	// Declare static groups of users. Use autogroups for all users or users with a specific role.
	// "groups": {
	//  	"group:example": ["alice@example.com", "bob@example.com"],
	// },

	// Define the tags which can be applied to devices and by which users.
	// "tagOwners": {
	//  	"tag:example": ["autogroup:admin"],
	// },

	// Define access control lists for users, groups, autogroups, tags,
	// Tailscale IP addresses, and subnet ranges.
	"acls": [
		// Allow all connections.
		// Comment this section out if you want to define specific restrictions.
		{"action": "accept", "src": ["*"], "dst": ["*:*"]},

		// Allow users in "group:example" to access "tag:example", but only from
		// devices that are running macOS and have enabled Tailscale client auto-updating.
		// {"action": "accept", "src": ["group:example"], "dst": ["tag:example:*"], "srcPosture":["posture:autoUpdateMac"]},
	],
	"tagOwners": {
		// All Tailscale admins can manage which devices are tagged tag:shared and tag:home
		"tag:shared": ["autogroup:admin"],
		"tag:home":   ["autogroup:admin"],
		// Users who are Tailscale admins can apply the tag tag:exit-node and tag:subnet-router
		"tag:exit-node":     ["autogroup:admin"],
		"tag:subnet-router": ["autogroup:admin"],
	},
	"autoApprovers": {
		// Exit nodes advertised by users who are Tailscale admins or devices tagged
		// with tag:exit-node will be automatically approved
		"exitNode": ["tag:exit-node", "autogroup:admin"],
		// Routes for subnet router advertised by users who are Tailscale admins or routes on devices tagged
		// with tag:subnet-router will be automatically approved
		"routes": {
			"0.0.0.0/0": ["tag:subnet-router", "autogroup:admin"],
			"::/0":      ["tag:subnet-router", "autogroup:admin"],
		},
	},
	// Define postures that will be applied to all rules without any specific
	// srcPosture definition.
	// "defaultSrcPosture": [
	//      "posture:anyMac",
	// ],

	// Define device posture rules requiring devices to meet
	// certain criteria to access parts of your system.
	// "postures": {
	//      // Require devices running macOS, a stable Tailscale
	//      // version and auto update enabled for Tailscale.
	// 	"posture:autoUpdateMac": [
	// 	    "node:os == 'macos'",
	// 	    "node:tsReleaseTrack == 'stable'",
	// 	    "node:tsAutoUpdate",
	// 	],
	//      // Require devices running macOS and a stable
	//      // Tailscale version.
	// 	"posture:anyMac": [
	// 	    "node:os == 'macos'",
	// 	    "node:tsReleaseTrack == 'stable'",
	// 	],
	// },

	// Define users and devices that can use Tailscale SSH.
	"ssh": [
		// Allow all users to SSH into their own devices in check mode.
		// Comment this section out if you want to define specific restrictions.
		{
			"action": "check",
			"src":    ["autogroup:member"],
			"dst":    ["autogroup:self"],
			"users":  ["autogroup:nonroot", "root"],
		},
	],

	// Test access rules every time they're saved.
	// "tests": [
	//  	{
	//  		"src": "alice@example.com",
	//  		"accept": ["tag:example"],
	//  		"deny": ["100.101.102.103:443"],
	//  	},
	// ],
}

```
