---
title: synology
categories:
  - software
  - hardware
  - guides
  - notes
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [cmd](#cmd)
- [packages](#packages)
  - [vim](#vim)
  - [tailscale](#tailscale)
    - [Make synology nas as subnet router](#make-synology-nas-as-subnet-router)
    - [Access Synology NAS from anywhere](#access-synology-nas-from-anywhere)
      - [Installation steps](#installation-steps)
      - [Features](#features)
      - [Limitations \& known issues](#limitations--known-issues)
      - [Manual installation steps](#manual-installation-steps)
      - [Enabling Synology outbound connections](#enabling-synology-outbound-connections)
        - [If the Synology firewall is enabled: adjust the firewall settings](#if-the-synology-firewall-is-enabled-adjust-the-firewall-settings)
      - [Special thanks](#special-thanks)
      - [Support](#support)
- [PIA ports for gluetun and firewall](#pia-ports-for-gluetun-and-firewall)

## cmd

To add an alias or to modify `$PATH` to shell edit or create `~/.bashrc`. See [this discussion](https://www.synoforum.com/threads/how-to-make-an-alias-in-shell.1211/).

```sh
# $PATH
echo 'export PATH="/volume1/@appstore/vim/bin/vim:$PATH"' >> ~/.bashrc

# alias vim
echo 'alias vim="/volume1/@appstore/vim/bin/vim"' >> ~/.bashrc
```

renew Let's Encrypt Certificates

```sh
/usr/syno/sbin/syno-letsencrypt renew-all
```

disable Firewall

```sh
/usr/syno/bin/synofirewall --disable
```

---

## packages

### vim

Install last version of **vim** from [SynoCommunity](https://packages.synocommunity.com/) and enable syntax in it

1. Add [SynoCommunity](https://packages.synocommunity.com/) repo to a Package Center  
   Package Center -> Settings -> Package Sources -> SynoCommunity - <https://packages.synocommunity.com/>

2. Install **vim** from SynoCommunity

3. Ssh to Synology box with your user

   ```sh
   # via $PATH
   echo 'export PATH="/volume1/@appstore/vim/bin/:$PATH"' >> ~/.bashrc && \
     source ./.bashrc && \
     echo -e "filetype plugin indent on\nsyntax on" >> ~/.vimrc && \
     vim --version
   
   # or via alias
   echo 'alias vim="/volume1/@appstore/vim/bin/vim"' >> ~/.bashrc && \
     source ./.bashrc && \
     echo -e "filetype plugin indent on\nsyntax on" >> ~/.vimrc && \
     vim --version
   ```

---

### tailscale

> Maybe now you can do that just from admin panel

#### [Make synology nas as subnet router](https://youtu.be/uJ8PsImiDrM)

```sh
sudo tailscale up --advertise-routes=192.168.1.0/24 --reset
```

then edit subnet routes in tailscale admin panel, add `subnet` and `DISABLE KEY EXPIRE` on subnet router

To disable subnet routing on nas:

```sh
sudo tailscale ip --reset
```

don't forget to remove subnet routes from admin panel and ENABLE KEY EXPIRE

---

#### [Access Synology NAS from anywhere](https://tailscale.com/kb/1131/synology/)

Tailscale makes it easy to securely connect to your Synology NAS devices over WireGuard®.

Tailscale is free for most personal uses, including accessing your NAS.

##### [Installation steps](https://tailscale.com/kb/1131/synology/#installation-steps)

1. Visit the Synology Package Center ([tutorial](https://kb.synology.com/en-sg/DSM/tutorial/How_to_install_applications_with_Package_Center)).

2. Search for and install the **Tailscale** app.

   ![img](./synology.assets/synology-packagecenter.png)

3. Once the app is installed, follow the instructions to Log in using your preferred identity provider. If you don’t already have a Tailscale account, a free account will be created automatically.

   ![img](./synology.assets/synology-login.png)

4. Now your Synology NAS is available on your tailnet. Connect to it from your PC, laptop, phone, or tablet by [installing Tailscale on another device](https://tailscale.com/download).

That’s it!

##### [Features](https://tailscale.com/kb/1131/synology/#features)

When used with Synology, Tailscale supports these features:

- Web-based login to any [supported identity provider](https://tailscale.com/kb/1013/sso-providers/).
- Access your Synology NAS from anywhere, [without opening firewall ports](https://tailscale.com/blog/how-nat-traversal-works/).
- Share your NAS with designated Tailscale users, using [node sharing](https://tailscale.com/kb/1084/sharing/).
- Restrict access to your NAS using [ACLs](https://tailscale.com/kb/1018/acls/).
- Use your NAS as a [subnet router](https://tailscale.com/kb/1019/subnets/) to provide external access to your LAN. (Currently requires command-line steps.)
- Use your NAS as an [exit node](https://tailscale.com/kb/1103/exit-nodes/) for secure Internet access from anywhere. (Currently requires command-line steps.)

##### [Limitations & known issues](https://tailscale.com/kb/1131/synology/#limitations--known-issues)

Some things to be aware of:

- If you upgrade Synology from DSM6 to DSM7, you will need to uninstall and then reinstall the Tailscale app. **Do not perform the Synology DSM7 upgrade over Tailscale or you may lose your connection during the upgrade.**
- Tailscale uses [hybrid networking mode](https://tailscale.com/kb/1112/userspace-networking/) on Synology, which means that if you share subnets, they will be reachable over UDP and TCP, but not necessarily pingable.
- Other Synology packages cannot make outgoing connections to your other Tailscale nodes by default on DSM7. See instructions below to enable.
- Tailscale on Synology currently can do `--advertise-routes` but not `--accept-routes`. This means that if you have other [subnet routers](https://tailscale.com/kb/1019/subnets/), devices on those other subnets will not yet be able to reach your NAS or devices on its local subnet.
- Advertising subnet routes can only be configured from the command line, not the web GUI.
- [Tailscale SSH](https://tailscale.com/kb/1193/tailscale-ssh) does not run on Synology.

Some of these limitations are imposed on Tailscale by the DSM7 sandbox.

See our [Synology tracking issue on GitHub](https://github.com/tailscale/tailscale/issues/1995) for the latest status on the above issues.

##### [Manual installation steps](https://tailscale.com/kb/1131/synology/#manual-installation-steps)

An alternative to the recommended approach of [installing Tailscale from the Synology Package Center](https://tailscale.com/kb/1131/synology/#installation-steps) is to install Tailscale using a downloadable Synology package (SPK). A reason you might want to install from an SPK is to access new Tailscale features that are not yet released in the Tailscale version that is available from the Synology Package Center.

To manually install Tailscale:

1. Download the SPK for your Synology device from the [Tailscale Packages](https://pkgs.tailscale.com/) server. Synology SPKs are available from both [stable](https://pkgs.tailscale.com/stable/#spks) and [unstable](https://pkgs.tailscale.com/unstable/#spks) release tracks. To determine which download is appropriate for your Synology device, visit the [Synology and SynoCommunity Package Architectures](https://github.com/SynoCommunity/spksrc/wiki/Synology-and-SynoCommunity-Package-Architectures) page and look up your architecture by Synology model. Then, find the SPK download at [Tailscale Packages](https://pkgs.tailscale.com/) that corresponds to your model.
2. In the Synology DSM web admin UI, go to **Main menu** > **Package Center**.
3. Click **Manual Install**, click **Browse**, select the SPK (.spk) file that you downloaded, and then click **Next**.
4. Follow the remaining prompts to confirm settings and complete installation.
5. At this point `tailscaled` should be up and running on your Synology device and you can configure it either using the Tailscale package’s Synology web UI or [the CLI](https://tailscale.com/kb/1080/cli/) over SSH. (For instructions on using SSH to access Synology, see [How can I sign in to DSM/SRM with root privilege via SSH?](https://kb.synology.com/en-id/DSM/tutorial/How_to_login_to_DSM_with_root_permission_via_SSH_Telnet)).

##### [Enabling Synology outbound connections](https://tailscale.com/kb/1131/synology/#enabling-synology-outbound-connections)

Synology DSM7 introduced tighter restrictions on what packages are allowed to do. If you’re running DSM6, Tailscale runs as root with full permissions and these steps are not required.

By default, Tailscale on Synology with DSM7 only allows inbound connections to your Synology device but outbound Tailscale access from other apps running on your Synology is not enabled.

The reason for this is that the Tailscale package does not have permission to create a [TUN device](https://en.wikipedia.org/wiki/TUN/TAP).

To enable TUN, to permit outbound connections from other things running on your Synology:

1. Make sure you’re running Tailscale 1.22.2 or later, either from the Synology Package Center or a manually installed `*.spk` from the [Tailscale Packages](https://pkgs.tailscale.com/) server.

2. In Synology, go to **Control Panel** > **Task Scheduler**, click **Create**, and select **Triggered Task**.

3. Select **User-defined script**.

4. When the **Create task** window appears, click **General**.

5. In **General Settings**, enter a task name, select **root** as the user that the task will run for, and select **Boot-up** as the event that triggers the task. Ensure the task is enabled.

6. Click **Task Settings** and enter the following for **User-defined script**.

   ```sh
   /var/packages/Tailscale/target/bin/tailscale configure-host; synosystemctl restart pkgctl-Tailscale.service
   ```

   (If you’re curious what it does, you can read the [`configure-host` code](https://github.com/tailscale/tailscale/blob/main/cmd/tailscale/cli/configure-synology.go).)

7. Click **OK** to save the settings.

8. Reboot your Synology. (Alternatively, to avoid a reboot, run the above user-defined script as root on the device and then restart the Tailscale package.)

Your TUN settings should now be persisted across reboots of your device.

###### [If the Synology firewall is enabled: adjust the firewall settings](https://tailscale.com/kb/1131/synology/#if-the-synology-firewall-is-enabled-adjust-the-firewall-settings)

By enabling TUN, Tailscale traffic will be subject to Synology’s built-in firewall.

The firewall is disabled by default. However, if you have it enabled, add an exception for the Tailscale subnet, 100.64.0.0/10. In **Main menu** > **Control Panel** > **Security** > **Firewall**, add a firewall rule in the default profile that allows traffic from the source IP subnet 100.64.0.0 with subnet mask 255.192.0.0.

##### [Special thanks](https://tailscale.com/kb/1131/synology/#special-thanks)

Special thanks to [Guilherme de Maio (nirev)](https://github.com/nirev/), who contributed the original [Synology-Tailscale package builder](https://github.com/tailscale/tailscale-synology). Tailscale now maintains this package builder and produces our official Synology packages.

##### [Support](https://tailscale.com/kb/1131/synology/#support)

If you run into problems, [contact support](https://tailscale.com/contact/support) or visit the linked GitHub issues.

---

## PIA ports for gluetun and firewall

In order to connect to our service using one of the VPN methods we provide, please verify you can connect over these ports:

- For the PIA Client:
  - **UDP** ports  8080, 853, 123, 53
  - **TCP** ports  8443, 853, 443, 80
- For OpenVPN:
  - **UDP** ports 1197, 1198
  - **TCP** ports  501, 502

If you can connect over any of those, you should be able to use at least one of our connection methods.

In addition, the PIA application pings our gateways over port 8888. This is used to connect you to the server with the lowest latency when you use the auto connect feature.

We also have more in-depth information on our OpenVPN ports including the protocols, settings, and certificates that should be used with them in this [article](https://www.privateinternetaccess.com/helpdesk/kb/articles/which-encryption-auth-settings-should-i-use-for-ports-on-your-gateways-3).
