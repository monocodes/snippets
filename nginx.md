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
  - [WebSocket proxying](#websocket-proxying)

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

### [WebSocket proxying](https://nginx.org/en/docs/http/websocket.html)

To turn a connection between a client and server from HTTP/1.1 into WebSocket, the [protocol switch](https://datatracker.ietf.org/doc/html/rfc2616#section-14.42) mechanism available in HTTP/1.1 is used.

There is one subtlety however: since the “Upgrade” is a [hop-by-hop](https://datatracker.ietf.org/doc/html/rfc2616#section-13.5.1) header, it is not passed from a client to proxied server. With forward proxying, clients may use the `CONNECT` method to circumvent this issue. This does not work with reverse proxying however, since clients are not aware of any proxy servers, and special processing on a proxy server is required.

Since version 1.3.13, nginx implements special mode of operation that allows setting up a tunnel between a client and proxied server if the proxied server returned a response with the code 101 (Switching Protocols), and the client asked for a protocol switch via the “Upgrade” header in a request.

As noted above, hop-by-hop headers including “Upgrade” and “Connection” are not passed from a client to proxied server, therefore in order for the proxied server to know about the client’s intention to switch a protocol to WebSocket, these headers have to be passed explicitly:

> ```nginx
> location /chat/ {
>     proxy_pass http://backend;
>     proxy_http_version 1.1;
>     proxy_set_header Upgrade $http_upgrade;
>     proxy_set_header Connection "upgrade";
> }
> ```

A more sophisticated example in which a value of the “Connection” header field in a request to the proxied server depends on the presence of the “Upgrade” field in the client request header:

> ```nginx
> http {
>     map $http_upgrade $connection_upgrade {
>         default upgrade;
>         ''      close;
>     }
> 
>     server {
>         ...
> 
>         location /chat/ {
>             proxy_pass http://backend;
>             proxy_http_version 1.1;
>             proxy_set_header Upgrade $http_upgrade;
>             proxy_set_header Connection $connection_upgrade;
>         }
>     }
> ```

By default, the connection will be closed if the proxied server does not transmit any data within 60 seconds. This timeout can be increased with the [proxy_read_timeout](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_read_timeout) directive. Alternatively, the proxied server can be configured to periodically send WebSocket ping frames to reset the timeout and check if the connection is still alive.

---
