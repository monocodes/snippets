---
title: nginx
categories:
  - software
  - notes
  - guides
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [install NGINX](#install-nginx)
  - [Rocky Linux 9](#rocky-linux-9)
- [NGINX paths](#nginx-paths)
- [NGINX syntax](#nginx-syntax)
  - [Location Matches](#location-matches)
- [NGINX commands](#nginx-commands)
- [NGINX notes](#nginx-notes)
  - [Error messages](#error-messages)

## install NGINX

### Rocky Linux 9

nginx install one-liner

```sh
sudo dnf install nginx -y && \
  sudo systemctl enable --now nginx && \
  sudo firewall-cmd --permanent --add-service=http && \
  sudo firewall-cmd --reload
```

---

## NGINX paths

config

```sh
/etc/nginx
```

logs

```sh
/var/log/nginx
```

delete old logs and create new

```sh
# delete the old files
sudo rm /var/log/nginx/access.log /var/log/nginx/error.log

# create new files
sudo touch /var/log/nginx/access.log /var/log/nginx/error.log

# reopen the log files
sudo nginx -s reopen
```

---

## NGINX syntax

### Location Matches

| MATCH               | MODIFIER    |
| :------------------ | :---------- |
| Exact               | `=`         |
| Preferential Prefix | `^~`        |
| REGEX               | `~` or `~*` |
| Prefix              | `None`      |

---

## NGINX commands

test current config

```sh
nginx -t
```

restart nginx  
`-s` - option is used for dispatching various signals to NGINX  
The available signals are `stop`, `quit`, `reload` and `reopen`.

```sh
sudo nginx -s reload
# or
sudo systemctl restart nginx
```

---

## NGINX notes

- [Alphabetical index of directives](https://nginx.org/en/docs/dirindex.html)
- [Alphabetical index of variables](https://nginx.org/en/docs/varindex.html)

---

### Error messages

Error messages have levels. A `notice` entry in the error log is harmless, but an `emerg` or emergency entry has to be addressed right away.

There are eight levels of error messages:

- `debug` – Useful debugging information to help determine where the problem lies.
- `info` – Informational messages that aren't necessary to read but may be good to know.
- `notice` – Something normal happened that is worth noting.
- `warn` – Something unexpected happened, however is not a cause for concern. **`warn` is optimal log level.**
- `error` – Something was unsuccessful.
- `crit` – There are problems that need to be critically addressed.
- `alert` – Prompt action is required.
- `emerg` – The system is in an unusable state and requires immediate attention.

By default, NGINX records all level of messages. You can override this behavior using the `error_log` directive. If you want to set the minimum level of a message to be `warn`, then update your configuration file as follows:

```nginx
events {

}

http {

    include /etc/nginx/mime.types;

    server {

        listen 80;
        server_name nginx-handbook.test;
	
    	error_log /var/log/error.log warn;

        return 200 "..." "...";
    }

}
```

---
