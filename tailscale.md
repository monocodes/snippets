---
title: tailscale
categories:
  - software
  - guides
  - notes
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [tailscale commands](#tailscale-commands)
- [tailscale ACL](#tailscale-acl)
	- [tailscale - corporate VPN with exit-nodes + default ACL](#tailscale---corporate-vpn-with-exit-nodes--default-acl)
	- [tailscale - homelab default ACL](#tailscale---homelab-default-acl)

## tailscale commands

- exit node

  ```sh
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

  ```sh
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

## tailscale ACL

### tailscale - corporate VPN with exit-nodes + default ACL

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

/*
//Default ACL
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
	"nodeAttrs": [
		{"target": ["100.69.175.69"], "attr": ["mullvad"]},
		{"target": ["100.102.94.75"], "attr": ["mullvad"]},
		{"target": ["100.85.13.110"], "attr": ["mullvad"]},
		{"target": ["100.116.22.56"], "attr": ["mullvad"]},
		{"target": ["100.90.199.50"], "attr": ["mullvad"]},
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
*/
```

### tailscale - homelab default ACL

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
