---
title: firewalld
categories:
  - software
  - guides
author: Rocky Linux Documentation
url: https://docs.rockylinux.org/guides/security/firewalld/
---

`firewalld` for Beginners[¶](https://docs.rockylinux.org/guides/security/firewalld-beginners/#firewalld-for-beginners)

- [Introduction¶](#introduction)
  - [A note on using the command line for managing your firewall¶](#a-note-on-using-the-command-line-for-managing-your-firewall)
- [Prerequisites and Assumptions¶](#prerequisites-and-assumptions)
- [Basic Usage¶](#basic-usage)
  - [System service commands¶](#system-service-commands)
  - [Basic `firewalld` configuration and management commands¶](#basic-firewalld-configuration-and-management-commands)
  - [Saving your changes¶](#saving-your-changes)
- [Managing Zones¶](#managing-zones)
  - [Zone management commands¶](#zone-management-commands)
- [Managing Ports¶](#managing-ports)
  - [Port management commands¶](#port-management-commands)
- [Managing Services¶](#managing-services)
- [Service management commands¶](#service-management-commands)
- [Restricting Access¶](#restricting-access)
- [Final Notes¶](#final-notes)
- [Conclusion¶](#conclusion)

## Introduction[¶](https://docs.rockylinux.org/guides/security/firewalld-beginners/#introduction)

A long time ago, I was a little newbie computer user who heard that having a firewall was *supposed* to be super good. It would let me decide what got in, and what got out of my computer, right? But it mostly seemed to stop my video games from accessing the internet; I was *not* a happy camper.

Of course, if you're here, you probably have a better idea what a firewall is and what it does than I did. But if your firewall experience amounts to telling Windows Defender that yes, for the love of all that is holy, your new app is allowed to use the internet, don't worry. It says "for Beginners" up top; I've got you.

In other words, my fellow nerds should be aware that there will be a lot of explanations incoming.

So let's talk about what we're here for. `firewalld` is the default firewall app packaged with Rocky Linux, and it's designed to be pretty simple to use. You just need to know a little bit about how firewalls work, and not be afraid to use the command line.

Here you'll learn:

- The very basics of how `firewalld` works
- How to use `firewalld` to restrict or allow incoming and outgoing connections
- How to allow only people from certain IP addresses or places to log into your machine remotely
- How to manage some `firewalld`-specific features like Zones.

This is *not* intended to be a complete or exhaustive guide.

### A note on using the command line for managing your firewall[¶](https://docs.rockylinux.org/guides/security/firewalld-beginners/#a-note-on-using-the-command-line-for-managing-your-firewall)

Well... there *are* graphical firewall configuration options. On the desktop, there's `firewall-config` which can be installed from the repos, and on servers you can [install Cockpit](https://linoxide.com/install-cockpit-on-almalinux-or-rocky-linux/) to help you manage firewalls and a whole bunch of other stuff. **However, I'll be teaching you the command-line way to do things in this tutorial for a couple of reasons:**

1. If you're running a server, you'll be using the command line for most of this stuff anyway. Lots of tutorials and guides for Rocky server will give command line instructions for firewall management, and it's best that you understand those instructions, rather than just copying and pasting whatever you see.
2. Understanding how the `firewalld` commands work might help you better grasp how the firewall software works. You can take the same principles you learn here, and have a better idea what you're doing if you do decide to use a graphical interface in the future.

## Prerequisites and Assumptions[¶](https://docs.rockylinux.org/guides/security/firewalld-beginners/#prerequisites-and-assumptions)

You'll need:

- A Rocky Linux machine of any kind, local or remote, physical or virtual
- Access to the terminal, and a willingness to use it
- You need root access, or at least the ability to use `sudo` on your user account. For simplicity's sake, I'm assuming all commands are being run as root.
- A basic understanding of SSH wouldn't hurt for managing remote machines.

## Basic Usage[¶](https://docs.rockylinux.org/guides/security/firewalld-beginners/#basic-usage)

### System service commands[¶](https://docs.rockylinux.org/guides/security/firewalld-beginners/#system-service-commands)

`firewalld` is run as a service on your machine. It starts when the machine does, or it should. If for some reason `firewalld` is not already enabled on your machine, you can do that with a simple command:

```sh
systemctl enable --now firewalld
```

The `--now` flag starts the service as soon as its enabled, and let's you skip the `systemctl start firewalld` step.

As with all services on Rocky Linux, you can check if the firewall is running with:

```sh
systemctl status firewalld
```

To stop it altogether:

```sh
systemctl stop firewalld
```

And to give the service a hard restart:

```sh
systemctl restart firewalld
```

### Basic `firewalld` configuration and management commands[¶](https://docs.rockylinux.org/guides/security/firewalld-beginners/#basic-firewalld-configuration-and-management-commands)

`firewalld` is configured with the `firewall-cmd` command. You can, for example, check the status of `firewalld` with:

```sh
firewall-cmd --state
```

After every *permanent* change to your firewall, you'll need to reload it to see the changes. You can give the firewall configurations a "soft restart" with:

```sh
firewall-cmd --reload
```

Note

If you reload your configurations that haven't been made permanent, they'll disappear on you.

You can see all of your configurations and settings at once with:

```sh
firewall-cmd --list-all
```

That command will output something that looks like this:

```sh
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp9s0
  sources:
  services: ssh
  ports:
  protocols:
  forward: no
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

### Saving your changes[¶](https://docs.rockylinux.org/guides/security/firewalld-beginners/#saving-your-changes)

Warning: Seriously, read this next bit.

By default, all changes to `firewalld`'s configuration are temporary. If you restart the whole `firewalld` service, or restart your machine, none of your changes to the firewall will be saved unless you do one of two very specific things.

It's best practice to test all of your changes one by one, reloading your firewall config as you go. That way, if you accidentally lock yourself out of anything, you can restart the service (or the machine), all of those changes disappear as mentioned above.

But once you have a working configuration, you can save your changes permanently with:

```sh
firewall-cmd --runtime-to-permanent
```

However, if you're absolutely sure about what you're doing, and just want to add the rule and move on with your life, you can add the `--permanent` flag to any configuration command:

```sh
firewall-cmd --permanent [the rest of your command]
```

## Managing Zones[¶](https://docs.rockylinux.org/guides/security/firewalld-beginners/#managing-zones)

Before anything else, I need to explain zones. Zones are a feature that basically allow you to define different sets of rules for different situations. Zones are a huge part of `firewalld` so it pays to understand how they work.

If your machine has multiple ways to connect to different networks (eg. Ethernet and WiFi), you can decide that one connection is more trusted than the other. You might set your Ethernet connection to the "trusted" zone if it's only connected to a local network that you built, and put the WiFi (which might be connected to the internet) in the "public" zone with more stringent restrictions.

Note

A zone can *only* be in an active state if it has one of these two conditions:

1. The zone is assigned to a network interface
2. The zone is assigned source IPs or network ranges. (More on that below)

Default zones include the following (I've taken this explanation from [DigitalOcean's guide to `firewalld`](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-firewalld-on-centos-8), which you should also read):

> **drop:** The lowest level of trust. All incoming connections are dropped without reply and only outgoing connections are possible.
>
> **block:** Similar to the above, but instead of simply dropping connections, incoming requests are rejected with an icmp-host-prohibited or icmp6-adm-prohibited message.
>
> **public:** Represents public, untrusted networks. You don’t trust other computers but may allow selected incoming connections on a case-by-case basis.
>
> **external:** External networks in the event that you are using the firewall as your gateway. It is configured for NAT masquerading so that your internal network remains private but reachable.
>
> **internal:** The other side of the external zone, used for the internal portion of a gateway. The computers are fairly trustworthy and some additional services are available.
>
> **dmz:** Used for computers located in a DMZ (isolated computers that will not have access to the rest of your network). Only certain incoming connections are allowed.
>
> **work:** Used for work machines. Trust most of the computers in the network. A few more services might be allowed.
>
> **home:** A home environment. It generally implies that you trust most of the other computers and that a few more services will be accepted.
>
> **trusted:** Trust all of the machines in the network. The most open of the available options and should be used sparingly.

Okay, so some of those explanations get complicated, but Honestly? The average beginner can get by with understanding "trusted", "home", and "public", and when to use which.

### Zone management commands[¶](https://docs.rockylinux.org/guides/security/firewalld-beginners/#zone-management-commands)

To see your default zone, run:

```sh
firewall-cmd --get-default-zone
```

To see which zones are active and doing things, run:

```sh
firewall-cmd --get-active-zones
```

Note: Some of this might have been done for you.

If you're running Rocky Linux on a VPS, it's probable that a basic configuration has been set up for you. Specifically, you should be able to access the server via SSH, and the network interface will already have been added to the "public" zone.

To change the default zone:

```sh
firewall-cmd --set-default-zone [your-zone]
```

To add a network interface to a zone:

```sh
firewall-cmd --zone=[your-zone] --add-interface=[your-network-device]
```

To change the zone of a network interface:

```sh
firewall-cmd --zone=[your-zone] --change-interface=[your-network-device]
```

To remove an interface from a zone completely:

```sh
firewall-cmd --zone=[your-zone] --remove-interface=[your-network-device]
```

To make your own brand new zone with a completely custom set of rules, and to check that it was added properly:

```sh
firewall-cmd --new-zone=[your-new-zone]
firewall-cmd --get-zones
```

## Managing Ports[¶](https://docs.rockylinux.org/guides/security/firewalld-beginners/#managing-ports)

For the uninitiated, ports (in this context) are just virtual endpoints where computers connect to each other so they can send information back and forth. Think of them like physical Ethernet or USB ports on your computer, but invisible, and you can have up to 65,535 of them all going at once.

I wouldn't, but you can.

Every port is defined by a number, and some ports are reserved for specific services, and kinds of information. If you've ever worked with web servers to build a website, for example, you may be familiar with port 80, and port 443. Those ports allow for the transmission of web page data.

Specifically, port 80 allows for transferring data via the Hypertext Transfer Protocol (HTTP), and port 443 is reserved for Hypertext Transfer Protocol Secure (HTTPS) data. *

Port 22 is reserved for the Secure Shell protocol (SSH) which lets you log into and manage other machines via the command line (see [our short guide](https://docs.rockylinux.org/guides/security/ssh_public_private_keys/) on the suject).A brand new remote server might only allow connections over port 22 for SSH, and nothing else.

Other examples include FTP (ports 20 and 21), SSH (port 22), and so many more. You can also set custom ports to be used by new apps you might install, that don't already have a standard number.

Note: You shouldn't use ports for everything.

For things like SSH, HTTP/S, FTP, and more, it's actually recommended to add them to your firewall zone as *services*, and not as port numbers. I'll show you how that works below. That said, you still need to know how to open ports manually.

\* For absolute beginners, HTTPS is basically (more or less) the same as HTTP, but encrypted.

### Port management commands[¶](https://docs.rockylinux.org/guides/security/firewalld-beginners/#port-management-commands)

For this section, I'll be using `--zone=public`... and port 9001 as a random example, because it's over 9,000.

To see all open ports:

```sh
firewall-cmd --list-ports
```

To add a port to your firewall zone (thus opening it for use), just run this command:

```sh
firewall-cmd --zone=public --add-port=9001/tcp
```

Note

About that `/tcp` bit:

That `/tcp` bit at the end tells the firewall that connections will be coming in over the Transfer Control Protocol, which is what you'll be using for most server-and-home-related stuff.

Alternatives like UDP are for debugging, or other very specific kinds of stuff that frankly aren't in the scope of this guide. Refer to the documentation of whatever app or service you specifically want to open up a port for.

To remove a port, just reverse the command with a single word change:

```sh
firewall-cmd --zone=public --remove-port=9001/tcp
```

## Managing Services[¶](https://docs.rockylinux.org/guides/security/firewalld-beginners/#managing-services)

Services, as you might imagine, are fairly standardized programs that run on your computer. `firewalld` is set up so that it can just open the way for most common services whenever you need to do that.

This is the preferred way to open up the ports for these common services, and a whole lot more:

- HTTP and HTTPS: for web servers
- FTP: For moving files back and forth (the old fashioned way)
- SSH: For controlling remote machines and moving files back and forth the new way
- Samba: For sharing files with Windows machines

Warning

**Never remove the SSH service from a remote server's firewall!**

Remember, SSH is what you use to log in to your server. Unless you have another way to access the physical server, or its shell (ie via. a control panel provided by the host), removing the SSH service will lock you out permanently.

You'll either need to contact support to get your access back, or reinstall the OS entirely.

## Service management commands[¶](https://docs.rockylinux.org/guides/security/firewalld-beginners/#service-management-commands)

To see a list of all available service services that you could potentially add to your firewall, run:

```sh
firewall-cmd --get-services
```

To see what services you currently have active on your firewall, use:

```sh
firewall-cmd --list-services
```

To open up a service in your firewall (eg. HTTP in the public zone), use:

```sh
firewall-cmd --zone=public --add-service=http
```

To remove/close a service on your firewall, just change one word again:

```sh
firewall-cmd --zone=public --remove-service=http
```

Note: You can add your own services

And customize the heck out of them, too. However, that's a topic that gets kind of complex. Get familiar with `firewalld` first, and go from there.

## Restricting Access[¶](https://docs.rockylinux.org/guides/security/firewalld-beginners/#restricting-access)

Let's say you have a server, and you just don't want to make it public. if you want to define just who is allowed to access it via SSH, or view some private web pages/apps, you can do that.

There are a couple of methods to accomplish this. First, for a more locked-down server, you can pick one of the more restrictive zones, assign your network device to it, add the SSH service to it as shown above, and then whitelist your own public IP address like so:

```sh
firewall-cmd --permanent --zone=trusted --add-source=192.168.1.0 [< insert your IP here]
```

You can make it a range of IP addresses by adding a higher number at the end like so:

```sh
firewall-cmd --permanent --zone=trusted --add-source=192.168.1.0/24 [< insert your IP here]
```

Again, just change `--add-source` to `--remove-source` in order to reverse the process.

However, if you're managing a remote server with a website on it that needs to be public, and still only want to open up SSH for one IP address or a small range of them, you have a couple of options. In both of these examples, the sole network interface is assigned to the public zone.

First, you can use a "rich rule" to your public zone, and it would look something like this:

```sh
# firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="192.168.1.0/24" service name="ssh" accept'
```

Once the rich rule is in place, *don't* make the rules permanent yet. First, remove the SSH service from the public zone configuration, and test your connection to make sure you can still access the server via SSH.

Your configuration should now look like this:

```sh
your@server ~# firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: wlp3s0
  sources:
  services: cockpit dhcpv6-client
  ports: 80/tcp 443/tcp
  protocols:
  forward: no
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
        rule family="ipv4" source address="192.168.1.0/24" service name="ssh" accept
```

Secondly, you can use two different zones at a time. If you have your interface bound to the public zone, you can activate a second zone (the "trusted" zone for example) by adding a source IP or IP range to it as shown above. Then, add the SSH service to the trusted zone, and remove it from the public zone.

When you're done, the output should look a bit like this:

```sh
your@server ~# firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: wlp3s0
  sources:
  services: cockpit dhcpv6-client
  ports: 80/tcp 443/tcp
  protocols:
  forward: no
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
your@server ~# firewall-cmd --list-all --zone=trusted
trusted (active)
  target: default
  icmp-block-inversion: no
  interfaces:
  sources: 192.168.0.0/24
  services: ssh
  ports:
  protocols:
  forward: no
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

If you get locked out, restart the server (most VPS control panels have an option for this) and try again.

Warning

These techniques only work if you have a static IP address.

If you're stuck with an internet service provider that changes your IP address every time your modem reboots, don't use these rules (at least not for SSH) until you have a fix for that. You'll lock yourself out of your server

Either upgrade your internet plan/provider, or get a VPN that provides you with a dedicated IP, and *never, ever* lose it.

In the meantime, [install and configure fail2ban](https://wiki.crowncloud.net/?How_to_Install_Fail2Ban_on_RockyLinux_8), which can help cut down on brute force attacks.

Obviously, on a local network that you control (and where you can set every machine's IP address manually), you can use all of these rules as much as you like.

## Final Notes[¶](https://docs.rockylinux.org/guides/security/firewalld-beginners/#final-notes)

This is far from an exhaustive guide, and you can learn a whole lot more with the [official `firewalld` documentation](https://firewalld.org/documentation/). There are also handy app-specific guides all over the internet that will show you how to set up your firewall for for those specific apps.

For you fans of `iptables` (if you've gotten this far...), [we have a guide](https://docs.rockylinux.org/guides/security/firewalld/) detailing some of the differences in how `firewalld` and `iptables` work. That guide might help you figure out if you want to stay with `firewalld` or go back to The Old Ways(TM). There is something to be said for The Old Ways(TM), in this case.

## Conclusion[¶](https://docs.rockylinux.org/guides/security/firewalld-beginners/#conclusion)

And that is `firewalld` in as few words as I could manage while still explaining all the basics. Take it slow, experiment carefully, and don't make any rules permanent until you're sure they work.

And, you know, have fun. Once you have the basics down, actually setting up a decent, workable firewall can take 5-10 minutes.
