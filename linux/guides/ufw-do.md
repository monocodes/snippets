---
title: ufw-do
categories:
  - software
  - guides
author: Digital Ocean
url: https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04
---

Published on April 26, 2022

- [Firewall](https://www.digitalocean.com/community/tags/firewall)
- [Networking](https://www.digitalocean.com/community/tags/networking)
- [Security](https://www.digitalocean.com/community/tags/security)
- [Ubuntu 22.04](https://www.digitalocean.com/community/tags/ubuntu-22-04)
- [Ubuntu](https://www.digitalocean.com/community/tags/ubuntu)

By [Brian Boucheron](https://www.digitalocean.com/community/users/bboucheron) and [Jamon Camisso](https://www.digitalocean.com/community/users/jamonation)

- [Prerequisites](#prerequisites)
- [Step 1 — Using IPv6 with UFW (Optional)](#step-1--using-ipv6-with-ufw-optional)
- [Step 2 — Setting Up Default Policies](#step-2--setting-up-default-policies)
- [Step 3 — Allowing SSH Connections](#step-3--allowing-ssh-connections)
  - [ufw Application Integration](#ufw-application-integration)
- [Step 4 — Enabling UFW](#step-4--enabling-ufw)
- [Step 5 — Allowing Other Connections](#step-5--allowing-other-connections)
  - [Specific Port Ranges](#specific-port-ranges)
  - [Specific IP Addresses](#specific-ip-addresses)
  - [Subnets](#subnets)
  - [Connections to a Specific Network Interface](#connections-to-a-specific-network-interface)
- [Step 6 — Denying Connections](#step-6--denying-connections)
- [Step 7 — Deleting Rules](#step-7--deleting-rules)
  - [By Rule Number](#by-rule-number)
  - [By Actual Rule](#by-actual-rule)
- [Step 8 — Checking UFW Status and Rules](#step-8--checking-ufw-status-and-rules)
- [Step 9 — Disabling or Resetting UFW (optional)](#step-9--disabling-or-resetting-ufw-optional)
- [Conclusion](#conclusion)

### [Introduction](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#introduction)

UFW, or Uncomplicated Firewall, is a simplified firewall management interface that hides the complexity of lower-level packet filtering technologies such as `iptables` and `nftables`. If you’re looking to get started securing your network, and you’re not sure which tool to use, UFW may be the right choice for you.

This tutorial will show you how to set up a firewall with UFW on Ubuntu 22.04.

## [Prerequisites](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#prerequisites)

To follow this tutorial, you will need:

- One Ubuntu 22.04 server with a sudo non-root user, which you can set up by following our [Initial Server Setup with Ubuntu 22.04 tutorial](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-22-04).

UFW is installed by default on Ubuntu. If it has been uninstalled for some reason, you can install it with `sudo apt install ufw`.

## [Step 1 — Using IPv6 with UFW (Optional)](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#step-1-using-ipv6-with-ufw-optional)

This tutorial is written with IPv4 in mind, but will work for IPv6 as well as long as you enable it. If your Ubuntu server has IPv6 enabled, ensure that UFW is configured to support IPv6 so that it will manage firewall rules for IPv6 in addition to IPv4. To do this, open the UFW configuration with `nano` or your favorite editor.

```sh
sudo nano /etc/default/ufw
```

Then make sure the value of `IPV6` is `yes`. It should look like this:

/etc/default/ufw excerpt

```sh
IPV6=yes
```

Save and close the file. Now, when UFW is enabled, it will be configured to write both IPv4 and IPv6 firewall rules. However, before enabling UFW, we will want to ensure that your firewall is configured to allow you to connect via SSH. Let’s start with setting the default policies.

## [Step 2 — Setting Up Default Policies](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#step-2-setting-up-default-policies)

If you’re just getting started with your firewall, the first rules to define are your default policies. These rules control how to handle traffic that does not explicitly match any other rules. By default, UFW is set to deny all incoming connections and allow all outgoing connections. This means anyone trying to reach your server would not be able to connect, while any application within the server would be able to reach the outside world.

Let’s set your UFW rules back to the defaults so we can be sure that you’ll be able to follow along with this tutorial. To set the defaults used by UFW, use these commands:

```sh
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

You will receive output like the following:

```pro
OutputDefault incoming policy changed to 'deny'
(be sure to update your rules accordingly)
Default outgoing policy changed to 'allow'
(be sure to update your rules accordingly)
```

These commands set the defaults to deny incoming and allow outgoing connections. These firewall defaults alone might suffice for a personal computer, but servers typically need to respond to incoming requests from outside users. We’ll look into that next.

## [Step 3 — Allowing SSH Connections](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#step-3-allowing-ssh-connections)

If we enabled our UFW firewall now, it would deny all incoming connections. This means that we will need to create rules that explicitly allow legitimate incoming connections — SSH or HTTP connections, for example — if we want our server to respond to those types of requests. If you’re using a cloud server, you will probably want to allow incoming SSH connections so you can connect to and manage your server.

List rules when the firewall is disabled

This method will show the user added rules even if the firewall is inactive. This is a better way because you should be checking the rules before you turn on the firewall.

```sh
sudo ufw show added
```

To configure your server to allow incoming SSH connections, you can use this command:

```sh
sudo ufw allow ssh
```

This will create firewall rules that will allow all connections on port `22`, which is the port that the SSH daemon listens on by default. UFW knows what port `allow ssh` means because it’s listed as a service in the `/etc/services` file.

However, we can actually write the equivalent rule by specifying the port instead of the service name. For example, this command works the same as the one above:

```sh
sudo ufw allow 22
```

If you configured your SSH daemon to use a different port, you will have to specify the appropriate port. For example, if your SSH server is listening on port `2222`, you can use this command to allow connections on that port:

```sh
sudo ufw allow 2222
```

Now that your firewall is configured to allow incoming SSH connections, we can enable it.

### ufw Application Integration

Applications that open ports can include an ufw profile, which details the ports needed for the application to function properly. The profiles are kept in `/etc/ufw/applications.d`, and can be edited if the default ports have been changed.

- To view which applications have installed a profile, enter the following in a terminal:

  ```sh
  sudo ufw app list
  ```

- Similar to allowing traffic to a port, using an application profile is accomplished by entering:

  ```sh
  sudo ufw allow Samba
  ```

- An extended syntax is available as well:

  ```sh
  ufw allow from 192.168.0.0/24 to any app Samba
  ```

  Replace *Samba* and *192.168.0.0/24* with the application profile you are using and the IP range for your network.

  > **Note**
  >
  > There is no need to specify the *protocol* for the application, because that information is detailed in the profile. Also, note that the *app* name replaces the *port* number.

- To view details about which ports, protocols, etc., are defined for an application, enter:

  ```sh
  sudo ufw app info Samba
  ```

Not all applications that require opening a network port come with ufw profiles, but if you have profiled an application and want the file to be included with the package, please file a bug against the package in Launchpad.

```sh
ubuntu-bug nameofpackage
```

## [Step 4 — Enabling UFW](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#step-4-enabling-ufw)

To enable UFW, use this command:

```sh
sudo ufw enable
```

You will receive a warning that says the command may disrupt existing SSH connections. You already set up a firewall rule that allows SSH connections, so it should be fine to continue. Respond to the prompt with `y` and hit `ENTER`.

The firewall is now active. Run the `sudo ufw status verbose` command to see the rules that are set. The rest of this tutorial covers how to use UFW in more detail, like allowing or denying different kinds of connections.

## [Step 5 — Allowing Other Connections](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#step-5-allowing-other-connections)

At this point, you should allow all of the other connections that your server needs to respond to. The connections that you should allow depends on your specific needs. Luckily, you already know how to write rules that allow connections based on a service name or port; we already did this for SSH on port `22`. You can also do this for:

- HTTP on port 80, which is what unencrypted web servers use, using `sudo ufw allow http` or `sudo ufw allow 80`
- HTTPS on port 443, which is what encrypted web servers use, using `sudo ufw allow https` or `sudo ufw allow 443`

There are several others ways to allow other connections, aside from specifying a port or known service.

### [Specific Port Ranges](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#specific-port-ranges)

You can specify port ranges with UFW. Some applications use multiple ports, instead of a single port.

For example, to allow X11 connections, which use ports `6000`-`6007`, use these commands:

```sh
sudo ufw allow 6000:6007/tcp
sudo ufw allow 6000:6007/udp
```

When specifying port ranges with UFW, you must specify the protocol (`tcp` or `udp`) that the rules should apply to. We haven’t mentioned this before because not specifying the protocol automatically allows both protocols, which is OK in most cases.

### [Specific IP Addresses](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#specific-ip-addresses)

When working with UFW, you can also specify IP addresses. For example, if you want to allow connections from a specific IP address, such as a work or home IP address of `203.0.113.4`, you need to specify `from`, then the IP address:

```sh
sudo ufw allow from 203.0.113.4
```

You can also specify a specific port that the IP address is allowed to connect to by adding `to any port` followed by the port number. For example, If you want to allow `203.0.113.4` to connect to port `22` (SSH), use this command:

```sh
sudo ufw allow from 203.0.113.4 to any port 22
```

### [Subnets](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#subnets)

If you want to allow a subnet of IP addresses, you can do so using CIDR notation to specify a netmask. For example, if you want to allow all of the IP addresses ranging from `203.0.113.1` to `203.0.113.254` you could use this command:

```sh
sudo ufw allow from 203.0.113.0/24
```

Likewise, you may also specify the destination port that the subnet `203.0.113.0/24` is allowed to connect to. Again, we’ll use port `22` (SSH) as an example:

```sh
sudo ufw allow from 203.0.113.0/24 to any port 22
```

### [Connections to a Specific Network Interface](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#connections-to-a-specific-network-interface)

If you want to create a firewall rule that only applies to a specific network interface, you can do so by specifying “allow in on” followed by the name of the network interface.

You may want to look up your network interfaces before continuing. To do so, use this command:

```sh
ip addr
```

```sh
Output Excerpt2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state
. . .
3: enp0s4: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default
. . .
```

The highlighted output indicates the network interface names. They are typically named something like `eth0`, `ens1` or `enp3s2`.

So, if your server has a public network interface called `ens3`, you could allow HTTP traffic (port `80`) to it with this command:

```sh
sudo ufw allow in on ens3 to any port 80
```

Doing so would allow your server to receive HTTP requests from the public internet.

Or, if you want your MySQL database server (port `3306`) to listen for connections on the private network interface `eth1`, for example, you could use this command:

```sh
sudo ufw allow in on eth1 to any port 3306
```

This would allow other servers on your private network to connect to your MySQL database.

## [Step 6 — Denying Connections](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#step-6-denying-connections)

If you haven’t changed the default policy for incoming connections, UFW is configured to deny all incoming connections. Generally, this simplifies the process of creating a secure firewall policy by requiring you to create rules that explicitly allow specific ports and IP addresses through.

However, sometimes you will want to deny specific connections based on the source IP address or subnet, perhaps because you know that your server is being attacked from there. Also, if you want to change your default incoming policy to **allow** (which is not recommended), you would need to create **deny** rules for any services or IP addresses that you don’t want to allow connections for.

To write **deny** rules, you can use the commands described above, replacing **allow** with **deny**.

For example, to deny HTTP connections, you could use this command:

```sh
sudo ufw deny http
```

Or if you want to deny all connections from `203.0.113.4` you could use this command:

```sh
sudo ufw deny from 203.0.113.4
```

Now let’s take a look at how to delete rules.

## [Step 7 — Deleting Rules](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#step-7-deleting-rules)

Knowing how to delete firewall rules is just as important as knowing how to create them. There are two different ways to specify which rules to delete: by rule number or by the actual rule (similar to how the rules were specified when they were created). We’ll start with the **delete by rule number** method because it is easier.

### [By Rule Number](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#by-rule-number)

If you’re using the rule number to delete firewall rules, the first thing you’ll want to do is get a list of your firewall rules. The UFW status command has an option to display numbers next to each rule, as demonstrated here:

```sh
sudo ufw status numbered
```

```properties
Numbered Output:Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22                         ALLOW IN    15.15.15.0/24
[ 2] 80                         ALLOW IN    Anywhere
```

If you decide that you want to delete rule 2, the one that allows port 80 (HTTP) connections, you can specify it in a UFW delete command like this:

```sh
sudo ufw delete 2
```

This would show a confirmation prompt then delete rule 2, which allows HTTP connections. Note that if you have IPv6 enabled, you would want to delete the corresponding IPv6 rule as well.

### [By Actual Rule](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#by-actual-rule)

The alternative to rule numbers is to specify the actual rule to delete. For example, if you want to remove the `allow http` rule, you could write it like this:

```sh
sudo ufw delete allow http
```

You could also specify the rule by `allow 80`, instead of by service name:

```sh
sudo ufw delete allow 80
```

This method will delete both IPv4 and IPv6 rules, if they exist.

## [Step 8 — Checking UFW Status and Rules](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#step-8-checking-ufw-status-and-rules)

At any time, you can check the status of UFW with this command:

```sh
sudo ufw status verbose
```

If UFW is disabled, which it is by default, you’ll see something like this:

```sh
OutputStatus: inactive
```

If UFW is active, which it should be if you followed Step 3, the output will say that it’s active and it will list any rules that are set. For example, if the firewall is set to allow SSH (port `22`) connections from anywhere, the output might look something like this:

```properties
OutputStatus: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), deny (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
22 (v6)                    ALLOW IN    Anywhere (v6)
```

Use the `status` command if you want to check how UFW has configured the firewall.

## [Step 9 — Disabling or Resetting UFW (optional)](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#step-9-disabling-or-resetting-ufw-optional)

If you decide you don’t want to use UFW, you can disable it with this command:

```sh
sudo ufw disable
```

Any rules that you created with UFW will no longer be active. You can always run `sudo ufw enable` if you need to activate it later.

If you already have UFW rules configured but you decide that you want to start over, you can use the reset command:

```sh
sudo ufw reset
```

This will disable UFW and delete any rules that were previously defined. Keep in mind that the default policies won’t change to their original settings, if you modified them at any point. This should give you a fresh start with UFW.

## [Conclusion](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#conclusion)

Your firewall is now configured to allow (at least) SSH connections. Be sure to allow any other incoming connections that your server needs, while limiting any unnecessary connections, so your server will be functional and secure.

To learn about more common UFW configurations, check out the [UFW Essentials: Common Firewall Rules and Commands](https://www.digitalocean.com/community/tutorials/ufw-essentials-common-firewall-rules-and-commands) tutorial.
