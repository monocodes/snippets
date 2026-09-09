---
title: certbot
categories:
  - software
  - notes
  - guides
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [certbot install](#certbot-install)
  - [Ubuntu](#ubuntu)
- [certbot commands](#certbot-commands)

## certbot install

- [Certbot Instructions](https://certbot.eff.org/instructions?ws=nginx&os=ubuntufocal&tab=wildcard)
- [Certbot Documentation](https://eff-certbot.readthedocs.io/en/stable/index.html)
- [Certbot DNS Plugins](https://eff-certbot.readthedocs.io/en/stable/using.html#dns-plugins)

Ensure that your version of snapd is up to date

```bash
sudo snap install core; sudo snap refresh core
```

Remove certbot-auto and any Certbot OS packages

```bash
sudo apt purge certbot
sudo dnf remove certbot
sudo yum remove certbot
```

Install Certbot

```bash
sudo snap install --classic certbot
```

Confirm plugin containment level

Run this command on the command line on the machine to acknowledge that the installed plugin will have the same `classic` containment as the Certbot snap.

```bash
sudo snap set certbot trust-plugin-with-root=ok
```

Install correct DNS plugin

```bash
sudo snap install certbot-dns-plugin-name

# example
sudo snap install certbot-dns-cloudflare
```

### Ubuntu

certbot install one-liner

```bash
sudo snap install core; sudo snap refresh core &&
sudo apt purge certbot -y &&
sudo snap install --classic certbot &&
sudo snap set certbot trust-plugin-with-root=ok &&
sudo snap install certbot-dns-cloudflare
```

---

## certbot commands

check certbot autorenew

```bash
sudo certbot certificates
```

automatically issue wildcard certs for domains in nginx configs with cloudflare plugin, edit these configs and append certs

```bash
sudo certbot -i nginx \
  --dns-cloudflare \
  --dns-cloudflare-credentials ~/.secrets/certbot/cloudflare.ini \
  -d *.mono.codes
```

automatically issue certs for domains in nginx configs with cloudflare plugin edit these configs and append certs

```bash
sudo certbot -i nginx \
  --dns-cloudflare \
  --dns-cloudflare-credentials ~/.secrets/certbot/cloudflare.ini \
  -d qb.mono.codes \
  -d www.qb.mono.codes \
  -d nas.mono.codes \
  -d www.nas.mono.codes
```

just issue certs for domains in nginx configs with cloudflare plugin

```bash
certbot certonly \
  --dns-cloudflare \
  --dns-cloudflare-credentials ~/.secrets/certbot/cloudflare.ini \
  -d example.com \
  -d www.example.com
```

just issue certs for domains in nginx configs, edit these configs and append certs

```bash
sudo certbot --nginx
```

just issue certs for domains in nginx configs

```bash
sudo certbot certonly --nginx
```

The Certbot packages on your system come with a cron job or systemd timer that will renew your certificates automatically before they expire. You will not need to run Certbot again, unless you change your configuration. You can test automatic renewal for your certificates by running this command:

check certs renewal

```bash
sudo certbot renew --dry-run
```

The command to renew certbot is installed in one of the following locations:

```bash
/etc/crontab/
/etc/cron.*/*
systemctl list-timers
```

delete certbot cert

```bash
sudo certbot delete
```

delete Certbot Certificate by Domain Name

```bash
sudo certbot delete --cert-name example.com
```

---
