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
  - [Nginx Web Server / Directory Structure](#nginx-web-server--directory-structure)
    - [/etc/nginx/](#etcnginx)
    - [/etc/nginx/nginx.conf](#etcnginxnginxconf)
    - [/etc/nginx/conf.d/\*.conf](#etcnginxconfdconf)
    - [Extra Parameters](#extra-parameters)
  - [Packaged Applications](#packaged-applications)
    - [upstream providers](#upstream-providers)
    - [init](#init)
    - [uwsgi](#uwsgi)
- [NGINX syntax](#nginx-syntax)
  - [Optimizing NGINX config](#optimizing-nginx-config)
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

main config

```sh
/etc/nginx/nginx.conf
```

logs

```sh
/var/log/nginx

# access_log
/var/log/nginx/access.log

# error_log
/var/log/nginx/error.log
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

> You need to reopen logs every time you swap main `nginx.conf` file.

---

### Nginx Web Server / Directory Structure

Contents

1. Nginx Web Server / Directory Structure
   1. [/etc/nginx/](https://wiki.debian.org/Nginx/DirectoryStructure#A.2Fetc.2Fnginx.2F)
   2. [/etc/nginx/nginx.conf](https://wiki.debian.org/Nginx/DirectoryStructure#A.2Fetc.2Fnginx.2Fnginx.conf)
   3. [/etc/nginx/conf.d/*.conf](https://wiki.debian.org/Nginx/DirectoryStructure#A.2Fetc.2Fnginx.2Fconf.d.2F.2A.conf)
   4. [Extra Parameters](https://wiki.debian.org/Nginx/DirectoryStructure#Extra_Parameters)
2. Packaged Applications
   1. [upstream providers](https://wiki.debian.org/Nginx/DirectoryStructure#upstream_providers)
   2. [init](https://wiki.debian.org/Nginx/DirectoryStructure#init)
   3. [uwsgi](https://wiki.debian.org/Nginx/DirectoryStructure#uwsgi)

[Nginx](https://wiki.debian.org/Nginx)

#### /etc/nginx/

Nginx keeps it's configuration in the expected */etc/nginx* directory. This directory is broken up as follows:

| **Path**            | **Purpose**                                            | **Ref.**                                                     |
| ------------------- | ------------------------------------------------------ | ------------------------------------------------------------ |
| ./conf.d/*.conf     | Extra configuration files.                             | [#conf.d](https://wiki.debian.org/Nginx/DirectoryStructure#conf.d), [#appincludes](https://wiki.debian.org/Nginx/DirectoryStructure#appincludes) |
| ./fastcgi.conf      | Commonly configured directives (nginx packaging team)  | [#params](https://wiki.debian.org/Nginx/DirectoryStructure#params) |
| ./fastcgi_params    | Commonly configured directives (upstream version)      | [#params](https://wiki.debian.org/Nginx/DirectoryStructure#params) |
| ./koi-utf           | Nginx Character Set                                    | [#charset](http://nginx.org/en/docs/http/ngx_http_charset_module.html) |
| ./koi-win           | Nginx Character Set                                    | [#charset](http://nginx.org/en/docs/http/ngx_http_charset_module.html) |
| ./mime.types        | Maps file name extensions to MIME types of responses   | [#mimetypes](http://nginx.org/en/docs/http/ngx_http_core_module.html#types) |
| ./nginx.conf        | The primary configuration file.                        | [#nginx.conf](https://wiki.debian.org/Nginx/DirectoryStructure#nginx.conf) |
| ./proxy_params      | Commonly configured directives                         | [#params](https://wiki.debian.org/Nginx/DirectoryStructure#params) |
| ./scgi_params       | Commonly configured directives                         | [#params](https://wiki.debian.org/Nginx/DirectoryStructure#params) |
| ./sites-available/* | Extra virtual host configuration files                 | -                                                            |
| ./sites-enabled/*   | Symlink to sites-available/file to enable vhost      | -                                                            |
| ./snippets/*.conf   | Configuration snippets that can be included in configs | -                                                            |
| ./apps.d/*.conf     | Files included by /etc/nginx/sites-available/default   | [#appincludes](https://wiki.debian.org/Nginx/DirectoryStructure#appincludes) |
| ./uwsgi_params      | Commonly configured directives                         | [#params](https://wiki.debian.org/Nginx/DirectoryStructure#params) |
| ./win-utf           | Nginx Character Set                                    | [#charset](http://nginx.org/en/docs/http/ngx_http_charset_module.html) |

---

#### /etc/nginx/nginx.conf

The first file that nginx reads when it starts is */etc/nginx/nginx.conf*. This file is maintained by Nginx package maintainers and it is recommended that administrators avoid editing this file unless they also follow changes made by upstream.

It's advised to instead add customizations underneath of the *conf.d/* directory which is described below.

---

#### /etc/nginx/conf.d/*.conf

The default nginx.conf file includes a line that will load additional configurations files into the http { } context. In most cases, options previously specified in the primary nginx.conf file can be overridden by creating a file at this location.

Example: **/etc/nginx/conf.d/ssl-tweaks.conf**

```nginx
add_header Strict-Transport-Security "max-age=31536000; includeSubdomains";
add_header X-Frame-Options DENY;
add_header X-Content-Type-Options nosniff;
ssl_ciphers 'kEECDH+CHACHA kEECDH+AESGCM HIGH+kEECDH AESGCM 3DES !SRP !PSK !DSS !MD5 !LOW !MEDIUM !aNULL !eNULL !DH !kECDH';
```

---

#### Extra Parameters

Some location blocks typically have extra configuration that is preferred to not be specified in a higher context. This is most often seen when running dynamic web applications such as Wordpress, Drupal, or Django. Depending on the protocol the backend application server speaks, a different set of parameters will need to be included.

**proxy_params**:

This file is most commonly included when Nginx is acting as a reverse proxy.

```nginx
include /etc/nginx/proxy_params;
proxy_pass http://localhost:8000;
```

**fastcgi_params**:

This is used to speak to applications servers that speak the FastCGI protocol. Most commonly, this will be associated with php-fpm.

```nginx
include fastcgi_params;
fastcgi_split_path_info ^(.+?\.php)(|/.*)$;
fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
```

**scgi_params**:

This file is used when passing requests to an SCGI server.

```nginx
include scgi_params;
scgi_pass unix:/var/run/rpc.sock;
```

**uwsgi_params**:

In most cases, this file is used when proxying requests to the uwsgi application.

```nginx
include uwsgi_params;
uwsgi_pass unix:/run/uwsgi/sockets/drupal7.sock;
```

---

### Packaged Applications

It's often expected that commands like **apt-get install drupal8** will result in a fully configured and running Drupal installation. Because Debian is magic, there's no reason choosing Nginx should keep this from being a reality.

We have provided directories for applications such as Drupal or Wordpress, or any other packaged web application to create configurations that are included when nginx is reloaded. These files will be included in the default server block.

Applications are expected to create files with the following syntax:

- [1] /etc/nginx/conf.d/pkg_<package_name>.conf
- [2] /etc/nginx/apps.d/pkg_<package_name>.conf

Files underneath of the *conf.d/* [1] directory should restrict their use to activities such as creating variables using the ``map`` directive. Additionally, any variables created should be prefixed with their respective package name.

Example: **/etc/nginx/conf.d/pkg_drupal8.conf**

```nginx
map $http_cookie $drupal8_php_sess {
    default 0;
    ~SESS 1; # PHP session cookie
}
```

Files underneath of the *apps.d* [2] are included in the default server block. It is expected that everything in this file be wrapped in a location directive respective to the package name.

Example: **/etc/nginx/apps.d/pkg_drupal7.conf**

```nginx
location ^~ /drupal7 {
    root /usr/share;

    location ~ ^/drupal7/sites/.*/private/ {
        return 403;
    }

    location /drupal7/ {
        try_files $uri /index.php?$query_string;
    }

    location ~ '\.php$|^/drupal7/update.php' {
        uwsgi_modifier1 14;
        include uwsgi_params;
        uwsgi_pass unix:/run/uwsgi/app/pkg_drupal7/socket;
    }
}
```

Package maintainers are strongly encouraged to contact the Nginx packaging team in order to build quality configuration files that meet these standards.

---

#### upstream providers

In addition to conf.d/pkg_name.conf, some packages may want to provide an upstream proxy location. The easiest example is php-fpm or uwsgi-plugin-php which may want to offer an upstream block for their application server.

In these situations, a package may provide an upstream { } block. This provider should be as generic as possible and start with the _provider prefix.

Example: **php-fpm: /etc/nginx/conf.d/pkg_php-fpm**

```nginx
upstream _provider_php {
    server unix:/var/run/php7-fpm.sock;
}
```

If uwsgi-plugin-php and php-fpm are both installed and provide a similar file, then two files will both provide the same upstream name and a reload or restart will fail. This is a situation for the user to handle.

---

#### init

If your package sets configuration files, as described here, it's likely you'll want to restart the nginx service for the changes to take effect. To help ensure we keep servers running, postinst scripts should use the **reload** feature of nginx and *not* **restart**. Additionally, *nginx -t* can be called to test that the current nginx configuration is valid before even attempting to reload the service.

---

#### uwsgi

The nginx packaging team recommends the use of uwsgi to run applications. This provides a consistent pattern to administrators and users. It also allows the nginx packaging team to more efficiently and more effectively help with web application packaging.

We recommend the use of: */etc/uwsgi/apps-available/pkg_<package_name>.ini*

Symlink to there from: */etc/uwsgi/apps-enabled/pkg_<package_name>.ini*

Example: **/etc/uwsgi/apps-available/pkg_drupal7.ini**

```nginx
[uwsgi]
plugins = php
master = true
workers = 2
uid = www-data
gid = www-data
```

---

## NGINX syntax

### Optimizing NGINX config

set user

```nginx
user www-data;

events...
```

set number of `worker_processes` to match available CPUs

```nginx
worker_processes auto;

events...
```

set number of `worker_connections` to match OS setup

- check OS setting for number of files OS is allowed to open per core

  ```sh
  ulimit -n
  
  # output
  1024
  ```

- `nginx.conf`

  ```nginx
  worker_processes auto;
  
  events {
      worker_connections 1024;
  }...
  ```

---

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
