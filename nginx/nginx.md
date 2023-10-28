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
  - [Ubuntu 22](#ubuntu-22)
    - [Installing a Prebuilt Ubuntu Package from an Ubuntu Repository](#installing-a-prebuilt-ubuntu-package-from-an-ubuntu-repository)
    - [Installing a Prebuilt Ubuntu STABLE Package from the Official NGINX Repository](#installing-a-prebuilt-ubuntu-stable-package-from-the-official-nginx-repository)
    - [Installing a Prebuilt Ubuntu MAINLINE Package from the Official NGINX Repository](#installing-a-prebuilt-ubuntu-mainline-package-from-the-official-nginx-repository)
  - [Rocky Linux 9](#rocky-linux-9)
  - [NGINX install from sources](#nginx-install-from-sources)
    - [NGINX MasterClass. NGINX Server and Custom Load Balancer - Cloud99 Tech - Udemy](#nginx-masterclass-nginx-server-and-custom-load-balancer---cloud99-tech---udemy)
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
  - [NGINX directives](#nginx-directives)
    - [proxy](#proxy)
      - [proxy\_request\_buffering](#proxy_request_buffering)
      - [proxy\_read\_timeout](#proxy_read_timeout)
    - [`http2` directive in NGINX \>1.25.1](#http2-directive-in-nginx-1251)
- [NGINX commands](#nginx-commands)
- [NGINX modules](#nginx-modules)
  - [php-fpm](#php-fpm)
- [NGINX notes](#nginx-notes)
  - [NGINX configs](#nginx-configs)
    - [Default](#default)
      - [nginx/1.24.0 (stable)](#nginx1240-stable)
      - [nginx/1.18.0 (Ubuntu 22.04.2 LTS (Jammy Jellyfish))](#nginx1180-ubuntu-22042-lts-jammy-jellyfish)
    - [NGINX Proxy with load-balancing for MinIO Server](#nginx-proxy-with-load-balancing-for-minio-server)
      - [Dedicated DNS](#dedicated-dns)
      - [Subdomain](#subdomain)
  - [Error messages (log levels)](#error-messages-log-levels)
- [NGINX guides](#nginx-guides)
  - [WebSocket proxying](#websocket-proxying)
  - [Serving Multiple Proxy Endpoints Under a Location in Nginx](#serving-multiple-proxy-endpoints-under-a-location-in-nginx)
    - [1. Overview](#1-overview)
    - [2. Nginx Configuration](#2-nginx-configuration)
      - [2.1. The *server* Block Directive](#21-the-server-block-directive)
      - [2.2. The *location* Block Directive](#22-the-location-block-directive)
      - [2.3. Nginx Configuration Reloading](#23-nginx-configuration-reloading)
    - [3. Serving Multiple Proxy Endpoints](#3-serving-multiple-proxy-endpoints)
      - [3.1. Creating the Endpoints](#31-creating-the-endpoints)
      - [3.2. The *proxy\_pass* Directive](#32-the-proxy_pass-directive)
      - [3.3. Sample Data Creation](#33-sample-data-creation)
      - [3.4. Testing](#34-testing)
  - [Single server, nginx as a reverse proxy, multiple domains/websites](#single-server-nginx-as-a-reverse-proxy-multiple-domainswebsites)
    - [Question](#question)
    - [Answer](#answer)
  - [How to create reverse proxy for multiple websites in nginx](#how-to-create-reverse-proxy-for-multiple-websites-in-nginx)
    - [Question](#question-1)
    - [Answer](#answer-1)

## [install NGINX](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/)

check NGINX version and configure arguments

```sh
nginx -V
```

[official NGINX repo](http://nginx.org/packages/)

### Ubuntu 22

#### [Installing a Prebuilt Ubuntu Package from an Ubuntu Repository](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#installing-a-prebuilt-ubuntu-package-from-an-ubuntu-repository)

nginx install

```sh
sudo apt install nginx
# or
sudo apt install nginx-full
```

#### [Installing a Prebuilt Ubuntu STABLE Package from the Official NGINX Repository](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#installing-a-prebuilt-ubuntu-package-from-the-official-nginx-repository)

```sh
sudo apt update && \
  sudo apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring -y && \
  curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
  | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null && \
  echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
  http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
  | sudo tee /etc/apt/sources.list.d/nginx.list && \
  echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
  | sudo tee /etc/apt/preferences.d/99nginx && \
  sudo apt update && \
  sudo apt install nginx -y && \
  sudo systemctl enable --now nginx && \
  curl -I 127.0.0.1
```

#### [Installing a Prebuilt Ubuntu MAINLINE Package from the Official NGINX Repository](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#installing-a-prebuilt-ubuntu-package-from-the-official-nginx-repository)

```sh
sudo apt update && \
  sudo apt install curl gnupg2 ca-certificates lsb-release debian-archive-keyring -y && \
  curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
  | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null && \
  echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
  http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" \
  | sudo tee /etc/apt/sources.list.d/nginx.list && \
  echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
  | sudo tee /etc/apt/preferences.d/99nginx && \
  sudo apt update && \
  sudo apt install nginx -y && \
  sudo systemctl enable --now nginx && \
  curl -I 127.0.0.1
```

---

### Rocky Linux 9

nginx install one-liner

```sh
sudo dnf install nginx -y && \
  sudo systemctl enable --now nginx && \
  sudo firewall-cmd --permanent --add-service=http && \
  sudo firewall-cmd --reload
```

### NGINX install from sources

#### [NGINX MasterClass. NGINX Server and Custom Load Balancer - Cloud99 Tech - Udemy](https://www.udemy.com/course/-training/)

1. Update Packages

    ```sh
    apt-get update # Ubuntu
    yum update # CentOS
    ```

2. Download the NGINX source code from nginx.org

    <https://nginx.org/download/nginx-1.19.1.tar.gz>

3. Unzip the file.

    ```sh
    tar -zxvf nginx-1.19.1.tar.gz
    ```

4. Configure source code to the build.

    ```sh
    ./configure
    ```

5. Install code compiler

    ```sh
    apt-get install build-essential # Ubuntu
    yum groupinstall "Development Tools" # CentOS
    ```

6. Configure source code to the build.

    ```sh
    ./configure
    ```

7. GET Support Libraries

    ```sh
    apt-get install libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev make # Ubuntu
    yum install pcre pcre-devel zlib zlib-devel openssl openssl-devel make # CentOS
    ```

8. Execute configuration again

    ```sh
    ./configure --sbin-path=/usr/bin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-pcre --pid-path=/var/run/nginx.pid --with-http_ssl_module
    ```

9. Compile and install Nginx

    ```sh
    make
    make install
    ```

**Add NGINX Process in Systemd Services to make the WebServer Resilient.**

1. NGINX Init Services File.

    <https://www.nginx.com/resources/wiki/start/topics/examples/systemd/>

2. Start Service

    ```sh
    systemctl start nginx
    ```

3. Stop Service

    ```sh
    systemctl stop nginx
    ```

4. Restart-Service

    ```sh
    systemctl restart nginx
    ```

5. Check Service Status

    ```sh
    systemctl status nginx
    ```

6. Enable service, auto-start on boot

    ```sh
    systemctl enable nginx
    ```

---

## NGINX paths

main config

```sh
/etc/nginx/nginx.conf
```

default site location

```sh
/usr/share/nginx/html
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

upload static site to user dir example

```sh
scp -r bloggingtemplate/ ub22-nginx:~/
```

---

### [Nginx Web Server / Directory Structure](https://wiki.debian.org/Nginx/DirectoryStructure)

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

you can check available CPUs on machine with

```sh
nproc
nproc --all
lscpu
cat /proc/cpuinfo
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

The list of all the matches in descending order of priority is as follows:

| MATCH               | MODIFIER    |
| :------------------ | :---------- |
| Exact               | `=`         |
| Preferential Prefix | `^~`        |
| REGEX               | `~` or `~*` |
| Prefix              | `None`      |

---

### NGINX directives

#### proxy

```nginx
# upload optimizing for big files
client_max_body_size 0;
proxy_request_buffering off;
proxy_read_timeout 3600;
# proxy_buffering off;
# proxy_connect_timeout 3600;
# proxy_read_timeout 3600;
# proxy_send_timeout 3600;
# proxy_ignore_client_abort on;
# chunked_transfer_encoding off;
```

##### [proxy_request_buffering](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_request_buffering)

> If there are problems with big files uploads thought NGINX reverse proxy, for example more that **2GB**, check free space on NGINX server.
>
> Also, the problem might be with the app. App could have its own timeouts, and we can do nothing with that. So, the only way to fix upload errors is to use `proxy_request_buffering`
>
> More here:
>
> - [NGINX: upstream timed out (110: Connection timed out) while reading response header from upstream](https://stackoverflow.com/questions/18740635/nginx-upstream-timed-out-110-connection-timed-out-while-reading-response-hea)
> - [Error uploading large files (>2gb) through nginx reverse proxy to container](https://serverfault.com/questions/1098725/error-uploading-large-files-2gb-through-nginx-reverse-proxy-to-container)

NGINX store big uploaded files more than [proxy_max_temp_file_size](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_max_temp_file_size) (default `1024m;`) on disk and doesn't stream them but use buffering.

Buffering can be turned off with [proxy_request_buffering](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_request_buffering) `off;`.

*Without buffering uploads will be significantly slower.*

More info here:

- [Error uploading large files (>2gb) through nginx reverse proxy to container](https://serverfault.com/questions/1098725/error-uploading-large-files-2gb-through-nginx-reverse-proxy-to-container)
- [what is the difference between proxy_request_buffering and proxy_buffering on nginx?](https://serverfault.com/questions/741610/what-is-the-difference-between-proxy-request-buffering-and-proxy-buffering-on-ng)

**Tests on Synology 920+, nginx/1.24.0 on Ubuntu 22**

| Filename | Size    | Resources          | Nginx parameters | Time     |
| -------- | ------- | ------------------ | ---------------- | -------- |
| IMG_1065 | 1.23 GB |                    | no nginx         | 05:09,03 |
| IMG_1065 | 1.23 GB | 1 vCPU, 768 MB RAM | buffering on     | 05:38,13 |
| IMG_1065 | 1.23 GB | 1 vCPU, 768 MB RAM | buffering off    | 07:14,40 |
| IMG_1098 | 5.65 GB |                    | no nginx         | 19:16,47 |
| IMG_1098 | 5.65 GB | 1 vCPU, 768 MB RAM | buffering on     | 20:23,92 |
| IMG_1098 | 5.65 GB | 1 vCPU, 768 MB RAM | buffering off    | 28:36,95 |

---

##### [proxy_read_timeout](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_read_timeout)

- Syntax: proxy_read_timeout time;
- Default: proxy_read_timeout 60s;
- Context: http, server, location

Defines a timeout for reading a response from the proxied server. The timeout is set only between two successive read operations, not for the transmission of the whole response. If the proxied server does not transmit anything within this time, the connection is closed.

---

#### `http2` directive in NGINX >1.25.1

Since nginx 1.25.1, the "listen ... http2" directive is deprecated, use the "http2" directive instead

the old format is

```nginx
server {
    listen      x.x.x.x:443 ssl http2;
```

and the new format for nginx >= 1.25.1 is

```nginx
server {
    listen      x.x.x.x:443 ssl;
    http2  on;
```

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

## NGINX modules

### php-fpm

> NGINX worker processes must be launched with the same user as php-fpm workers. Usually it is *www-data* user.

If you have multiple PHP-FPM versions installed, you can simply list all the socket file locations by executing the following command:

```sh
ls /run/php/ | grep php
# output
php-fpm.sock
php8.1-fpm.pid
php8.1-fpm.sock

# or

sudo find / -name *fpm.sock
# output
/run/php/php8.1-fpm.sock
/run/php/php-fpm.sock # Use this! It's a symlink to /var/lib/dpkg/alternatives/php-fpm.sock
/var/lib/dpkg/alternatives/php-fpm.sock # It's symlink to /run/php/php8.1-fpm.sock
```

`info.php` file

```php
<?php phpinfo(); ?>
```

---

## NGINX notes

- [Alphabetical index of directives](https://nginx.org/en/docs/dirindex.html)
- [Alphabetical index of variables](https://nginx.org/en/docs/varindex.html)
- [NGINX Getting Started](https://www.nginx.com/resources/wiki/start/)
- [NGINX as SSL-Offloader](https://www.nginx.com/resources/wiki/start/topics/examples/SSL-Offloader/)

---

### NGINX configs

#### Default

##### nginx/1.24.0 (stable)

*/etc/nginx/nginx.conf*

```nginx
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
}
```

*/etc/nginx/conf.d/default.conf*

```nginx
server {
    listen       80;
    server_name  localhost;

    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    #location ~ \.php$ {
    #    root           html;
    #    fastcgi_pass   127.0.0.1:9000;
    #    fastcgi_index  index.php;
    #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
    #    include        fastcgi_params;
    #}

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}
```

---

##### nginx/1.18.0 (Ubuntu 22.04.2 LTS (Jammy Jellyfish))

*/etc/nginx/nginx.conf*

```nginx
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
	worker_connections 768;
	# multi_accept on;
}

http {

	##
	# Basic Settings
	##

	sendfile on;
	tcp_nopush on;
	types_hash_max_size 2048;
	# server_tokens off;

	# server_names_hash_bucket_size 64;
	# server_name_in_redirect off;

	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	##
	# SSL Settings
	##

	ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
	ssl_prefer_server_ciphers on;

	##
	# Logging Settings
	##

	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;

	##
	# Gzip Settings
	##

	gzip on;

	# gzip_vary on;
	# gzip_proxied any;
	# gzip_comp_level 6;
	# gzip_buffers 16 8k;
	# gzip_http_version 1.1;
	# gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

	##
	# Virtual Host Configs
	##

	include /etc/nginx/conf.d/*.conf;
	include /etc/nginx/sites-enabled/*;
}


#mail {
#	# See sample authentication script at:
#	# http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
#
#	# auth_http localhost/auth.php;
#	# pop3_capabilities "TOP" "USER";
#	# imap_capabilities "IMAP4rev1" "UIDPLUS";
#
#	server {
#		listen     localhost:110;
#		protocol   pop3;
#		proxy      on;
#	}
#
#	server {
#		listen     localhost:143;
#		protocol   imap;
#		proxy      on;
#	}
#}
```

*/etc/nginx/sites-available/default*

```nginx
##
# You should look at the following URL's in order to grasp a solid understanding
# of Nginx configuration files in order to fully unleash the power of Nginx.
# https://www.nginx.com/resources/wiki/start/
# https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/
# https://wiki.debian.org/Nginx/DirectoryStructure
#
# In most cases, administrators will remove this file from sites-enabled/ and
# leave it as reference inside of sites-available where it will continue to be
# updated by the nginx packaging team.
#
# This file will automatically load configuration files provided by other
# applications, such as Drupal or Wordpress. These applications will be made
# available underneath a path with that package name, such as /drupal8.
#
# Please see /usr/share/doc/nginx-doc/examples/ for more detailed examples.
##

# Default server configuration
#
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	# SSL configuration
	#
	# listen 443 ssl default_server;
	# listen [::]:443 ssl default_server;
	#
	# Note: You should disable gzip for SSL traffic.
	# See: https://bugs.debian.org/773332
	#
	# Read up on ssl_ciphers to ensure a secure configuration.
	# See: https://bugs.debian.org/765782
	#
	# Self signed certs generated by the ssl-cert package
	# Don't use them in a production server!
	#
	# include snippets/snakeoil.conf;

	root /var/www/html;

	# Add index.php to the list if you are using PHP
	index index.html index.htm index.nginx-debian.html;

	server_name _;

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files $uri $uri/ =404;
	}

	# pass PHP scripts to FastCGI server
	#
	#location ~ \.php$ {
	#	include snippets/fastcgi-php.conf;
	#
	#	# With php-fpm (or other unix sockets):
	#	fastcgi_pass unix:/run/php/php7.4-fpm.sock;
	#	# With php-cgi (or other tcp sockets):
	#	fastcgi_pass 127.0.0.1:9000;
	#}

	# deny access to .htaccess files, if Apache's document root
	# concurs with nginx's one
	#
	#location ~ /\.ht {
	#	deny all;
	#}
}


# Virtual Host configuration for example.com
#
# You can move that to a different file under sites-available/ and symlink that
# to sites-enabled/ to enable it.
#
#server {
#	listen 80;
#	listen [::]:80;
#
#	server_name example.com;
#
#	root /var/www/example.com;
#	index index.html;
#
#	location / {
#		try_files $uri $uri/ =404;
#	}
#}
```

*/etc/nginx/proxy_params*

```nginx
proxy_set_header Host $http_host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;
```

---

#### [NGINX Proxy with load-balancing for MinIO Server](https://min.io/docs/minio/linux/integrations/setup-nginx-proxy-with-minio.html)

The following documentation provides a baseline for configuring NGINX to proxy requests to MinIO in a Linux environment. It is not intended as a comprehensive approach to NGINX, proxying, or reverse proxying in general. Modify the configuration as necessary for your infrastructure.

This documentation assumes the following:

- An existing [NGINX](http://nginx.org/en/download.html) deployment
- An existing [MinIO](https://min.io/docs/minio/linux/operations/installation.html#minio-installation) deployment
- A DNS hostname which uniquely identifies the MinIO deployment

There are two models for proxying requests to the MinIO Server API and the MinIO Console:

##### Dedicated DNS

Create or configure a dedicated DNS name for the MinIO service.

For the MinIO Server S3 API, proxy requests to the root of that domain. For the MinIO Console Web GUI, proxy requests to the `/minio` subpath.

For example, given the hostname `minio.example.net`:

- Proxy requests to the root `https://minio.example.net` to the MinIO Server listening on `https://minio.local:9000`.
- Proxy requests to the subpath `https://minio.example.net/minio/ui` to the MinIO Console listening on `https://minio.local:9090`.

The following location blocks provide a template for further customization in your unique environment:

```nginx
upstream minio_s3 {
   least_conn;
   server minio-01.internal-domain.com:9000;
   server minio-02.internal-domain.com:9000;
   server minio-03.internal-domain.com:9000;
   server minio-04.internal-domain.com:9000;
}

upstream minio_console {
   least_conn;
   server minio-01.internal-domain.com:9090;
   server minio-02.internal-domain.com:9090;
   server minio-03.internal-domain.com:9090;
   server minio-04.internal-domain.com:9090;
}

server {
   listen       80;
   listen  [::]:80;
   server_name  minio.example.net;

   # Allow special characters in headers
   ignore_invalid_headers off;
   # Allow any size file to be uploaded.
   # Set to a value such as 1000m; to restrict file size to a specific value
   client_max_body_size 0;
   # Disable buffering
   proxy_buffering off;
   proxy_request_buffering off;

   location / {
      proxy_set_header Host $http_host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;

      proxy_connect_timeout 300;
      # Default is HTTP/1, keepalive is only enabled in HTTP/1.1
      proxy_http_version 1.1;
      proxy_set_header Connection "";
      chunked_transfer_encoding off;

      proxy_pass https://minio_s3; # This uses the upstream directive definition to load balance
   }

   location /minio/ui/ {
      rewrite ^/minio/ui/(.*) /$1 break;
      proxy_set_header Host $http_host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-NginX-Proxy true;

      # This is necessary to pass the correct IP to be hashed
      real_ip_header X-Real-IP;

      proxy_connect_timeout 300;

      # To support websockets in MinIO versions released after January 2023
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "upgrade";
      # Some environments may encounter CORS errors (Kubernetes + Nginx Ingress)
      # Uncomment the following line to set the Origin request to an empty string
      # proxy_set_header Origin '';

      chunked_transfer_encoding off;

      proxy_pass https://minio_console; # This uses the upstream directive definition to load balance
   }
}
```

The S3 API signature calculation algorithm does *not* support proxy schemes where you host the MinIO Server API such as `example.net/s3/`.

You must also set the following environment variables for the MinIO deployment:

- Set [`MINIO_SERVER_URL`](https://min.io/docs/minio/linux/reference/minio-server/minio-server.html#envvar.MINIO_SERVER_URL) to the proxy host FQDN of the MinIO Server (`https://minio.example.net`)
- Set the [`MINIO_BROWSER_REDIRECT_URL`](https://min.io/docs/minio/linux/reference/minio-server/minio-server.html#envvar.MINIO_BROWSER_REDIRECT_URL) to the proxy host FQDN of the MinIO Console (`https://example.net/minio/ui`)

##### Subdomain

Create or configure separate, unique subdomains for the MinIO Server S3 API and for the MinIO Console Web GUI.

For example, given the root domain of `example.net`:

- Proxy request to the subdomain `minio.example.net` to the MinIO Server listening on `https://minio.local:9000`
- Proxy requests to the subdomain `console.example.net` to the MinIO Console listening on `https://minio.local:9090`

The following location blocks provide a template for further customization in your unique environment:

```nginx
upstream minio_s3 {
   least_conn;
   server minio-01.internal-domain.com:9000;
   server minio-02.internal-domain.com:9000;
   server minio-03.internal-domain.com:9000;
   server minio-04.internal-domain.com:9000;
}

upstream minio_console {
   least_conn;
   server minio-01.internal-domain.com:9090;
   server minio-02.internal-domain.com:9090;
   server minio-03.internal-domain.com:9090;
   server minio-04.internal-domain.com:9090;
}

server {
   listen       80;
   listen  [::]:80;
   server_name  minio.example.net;

   # Allow special characters in headers
   ignore_invalid_headers off;
   # Allow any size file to be uploaded.
   # Set to a value such as 1000m; to restrict file size to a specific value
   client_max_body_size 0;
   # Disable buffering
   proxy_buffering off;
   proxy_request_buffering off;

   location / {
      proxy_set_header Host $http_host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;

      proxy_connect_timeout 300;
      # Default is HTTP/1, keepalive is only enabled in HTTP/1.1
      proxy_http_version 1.1;
      proxy_set_header Connection "";
      chunked_transfer_encoding off;

      proxy_pass http://minio_s3; # This uses the upstream directive definition to load balance
   }
}

server {

   listen       80;
   listen  [::]:80;
   server_name  console.example.net;

   # Allow special characters in headers
   ignore_invalid_headers off;
   # Allow any size file to be uploaded.
   # Set to a value such as 1000m; to restrict file size to a specific value
   client_max_body_size 0;
   # Disable buffering
   proxy_buffering off;
   proxy_request_buffering off;

   location / {
      proxy_set_header Host $http_host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-NginX-Proxy true;

      # This is necessary to pass the correct IP to be hashed
      real_ip_header X-Real-IP;

      proxy_connect_timeout 300;

      # To support websocket
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "upgrade";

      chunked_transfer_encoding off;

      proxy_pass http://minio_console/; # This uses the upstream directive definition to load balance
   }
}
```

The S3 API signature calculation algorithm does *not* support proxy schemes where you host the MinIO Server API on a subpath, such as `minio.example.net/s3/`.

You must also set the following environment variables for the MinIO deployment:

- Set [`MINIO_SERVER_URL`](https://min.io/docs/minio/linux/reference/minio-server/minio-server.html#envvar.MINIO_SERVER_URL) to the proxy host FQDN of the MinIO Server (`https://minio.example.net`)
- Set the [`MINIO_BROWSER_REDIRECT_URL`](https://min.io/docs/minio/linux/reference/minio-server/minio-server.html#envvar.MINIO_BROWSER_REDIRECT_URL) to the proxy host FQDN of the MinIO Console (`https://console.example.net/`)

---

### Error messages (log levels)

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

## NGINX guides

### [WebSocket proxying](https://nginx.org/en/docs/http/websocket.html)

To turn a connection between a client and server from HTTP/1.1 into WebSocket, the [protocol switch](https://datatracker.ietf.org/doc/html/rfc2616#section-14.42) mechanism available in HTTP/1.1 is used.

There is one subtlety however: since the “Upgrade” is a [hop-by-hop](https://datatracker.ietf.org/doc/html/rfc2616#section-13.5.1) header, it is not passed from a client to proxied server. With forward proxying, clients may use the `CONNECT` method to circumvent this issue. This does not work with reverse proxying however, since clients are not aware of any proxy servers, and special processing on a proxy server is required.

Since version 1.3.13, nginx implements special mode of operation that allows setting up a tunnel between a client and proxied server if the proxied server returned a response with the code 101 (Switching Protocols), and the client asked for a protocol switch via the “Upgrade” header in a request.

As noted above, hop-by-hop headers including “Upgrade” and “Connection” are not passed from a client to proxied server, therefore in order for the proxied server to know about the client’s intention to switch a protocol to WebSocket, these headers have to be passed explicitly:

```nginx
location /chat/ {
  proxy_pass http://backend;
  proxy_http_version 1.1;
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection "upgrade";
}
```

A more sophisticated example in which a value of the “Connection” header field in a request to the proxied server depends on the presence of the “Upgrade” field in the client request header:

```nginx
http {
 map $http_upgrade $connection_upgrade {
     default upgrade;
     ''      close;
 }

 server {
     ...

     location /chat/ {
         proxy_pass http://backend;
         proxy_http_version 1.1;
         proxy_set_header Upgrade $http_upgrade;
         proxy_set_header Connection $connection_upgrade;
     }
 }
```

By default, the connection will be closed if the proxied server does not transmit any data within 60 seconds. This timeout can be increased with the [proxy_read_timeout](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_read_timeout) directive. Alternatively, the proxied server can be configured to periodically send WebSocket ping frames to reset the timeout and check if the connection is still alive.

---

### [Serving Multiple Proxy Endpoints Under a Location in Nginx](https://www.baeldung.com/linux/nginx-multiple-proxy-endpoints)

#### 1. Overview

**[Nginx](https://www.baeldung.com/linux/nginx-docker-container#2-installing-nginx) is a popular web server that we can also use as a load balancer, [forward proxy](https://www.baeldung.com/nginx-forward-proxy), or reverse proxy**. Reverse proxies are applications that stand between clients and internal servers. They accept network traffic from clients and forward it to the internal network. As a result, clients can’t directly access internal servers. Instead, they can reach them only through the reverse proxy.

In this tutorial, we’ll learn how we can configure Nginx to serve multiple endpoints under the same location. To that end, we’ll use the reverse proxy settings of the Nginx server.

#### 2. Nginx Configuration

**Nginx uses configuration files where we can define how the server processes HTTP requests**. The main Nginx configuration file is *nginx.conf*. On Ubuntu systems, we can find it under the */etc/nginx* directory. We can enter Nginx directives into this file.

Furthermore, directives can be grouped into blocks. These blocks are called contexts.

##### 2.1. The *server* Block Directive

**The [\*server\*](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) block defines a virtual server.** To set a listening port and a hostname or IP address, we use the [*listen*](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen) directive:

```nginx
server {
   listen 127.0.0.1:8080;
}
```

Here, we created a virtual server that listens on port *8080* on the *localhost* address (*127.0.0.1*).

##### 2.2. The *location* Block Directive

**A [\*location\*](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) block contains configuration for how the server should handle a set of matched HTTP requests**. We define a *location* with either a prefix string or a regular expression. So, Nginx tries to match the URL of an incoming HTTP request to the string prefix or the regular expression of a *location* block. If there’s a match, it selects this *location* block to process the HTTP request.

Also, we can use the [*root*](https://nginx.org/en/docs/http/ngx_http_core_module.html#root) directive to set a filesystem directory to serve the content:

```nginx
server {
   listen 127.0.0.1:8080;
   location /books {
      root /data/categories;
   }
}
```

In the above example, we added a *location* that returns files from the */data/categories* directory of the local filesystem. Moreover, we set the prefix string */books* to *location*. Consequently, we’ll match URLs starting with */books*.

Notably, **the** **Nginx \*root\* directive appends the whole HTTP request’s URL path to the local directory path**. For example, the URL path */books/echo.json* will be translated to the */data/categories/books/echo.json* path of the local filesystem.

An alternative to the *root* directive is the [*alias*](https://nginx.org/en/docs/http/ngx_http_core_module.html#alias) directive. **The \*alias\* directive appends the HTTP request’s URL to the local directory path, but omits the string prefix**:

```nginx
location /books { 
   alias /data/categories; 
}
```

So, the above block translates the URL path */books/echo.json* to */data/categories/echo.json*.

##### 2.3. Nginx Configuration Reloading

A nice feature of the Nginx server is that we can reload the configuration without restarting the server:

```sh
sudo nginx -s reloadCopy
```

Here, we use the *-s* option to send a *reload* signal to the Nginx server. Thus, we reload the configuration files. So, we can use this option instead of restarting the server, avoiding downtime.

#### 3. Serving Multiple Proxy Endpoints

In this example, first, we’ll create two virtual servers that simulate two endpoints. Then, we configure the Nginx server to proxy requests to the endpoints under the same URL path.

##### 3.1. Creating the Endpoints

Let’s create the two dummy endpoints:

```nginx
server {
   listen 8081;
   location /client1 {
      alias /data/client1;
   }
}

server {
   listen 8082;
   location /client2 {
      alias /data/client2;
   }
}
```

As we can see, we defined two virtual servers. Each *server* block contains a *location*:

- the first listens on port *8081*, serves content from the */data/client* directory, matching requests with the */client1* prefix string
- the second listens on port *8082*, serves content from the */data/client2* directory, matching requests with the */client2* prefix string

Now, we can set the forwarding.

##### 3.2. The *proxy_pass* Directive

To set up forwarding, we insert the [*proxy_pass*](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass) directive inside a *location* block. **The \*proxy_pass\* directive forwards HTTP requests to a specified network address**. The latter can be an IP address or a domain name:

```nginx
server {
   listen 8000;
   location /api {
      proxy_pass http://127.0.0.1:8081/client1;
   }

    location /api/client2 {
       proxy_pass http://127.0.0.1:8082/client2;
    }
}
```

Here, we created a virtual server that listens on port *8000*. Moreover, we created two locations inside the virtual server:

- *location* */api* forwards requests to the first endpoint (*<http://127.0.0.1:8081/client1>*)
- *location* */api/client2* forwards requests to the second endpoint (*<http://127.0.0.1/8082/client2>*)

Another key point is how *proxy_pass* forwards URL paths. There are two cases:

1. *proxy_pass* references a URL with a URL path, like *<http://127.0.0.1:8081/client1>*
2. *proxy_pass* references a URL with a hostname a port and no path, like *<http://127.0.0.1:8081>*

**In the first case, the request URL path is appended to the \*proxy_pass\* address without the \*location\* prefix string**. So, */api/echo.json* will be forwarded to *<http://127.0.0.1:8081/client1/echo.json>.* In other words, */api* is replaced by */client1.*

**In the second case, the request URL path is appended to the \*proxy_pass\* address with the \*location\* prefix string**:

```sh
location /api {
    proxy_pass http://127.0.0.1:8081; 
}Copy
```

Here, a request URL path */api/echo.json* will be proxied to *<http://127.0.0.1:8081/api/echo.json>*.

##### 3.3. Sample Data Creation

Before we test our settings, we should create some test files in the */data/client1* and */data/client2* directories:

```sh
$ sudo echo { 'message' : 'Hello from client1' } | sudo tee /data/client1/echo.json
{ message : Hello from client1 }
$ sudo echo { 'message' : 'Hello from client2' } | sudo tee /data/client2/echo.json
{ message : Hello from client2 }Copy
```

It’s worth noting that we should have [*sudo*](https://www.baeldung.com/linux/sudo-command) rights to create files or sub-directories in the */data* directory.

##### 3.4. Testing

Now we’re ready to test:

```sh
$ curl http://127.0.0.1:8000/api/echo.json
{ message : Hello from client1 }
$ curl http://127.0.0.1:8000/api/client2/echo.json
{ message : Hello from client2 }Copy
```

As expected, the requested JSON files were printed to the output. To sum up, let’s look at the processing of the first HTTP request:

1. The server forwarded the request URL *<http://127.0.0.1:8000/api/echo.json>* to *<http://127.0.0.1:8081/client1/echo.json>*
2. The server processed the request *<http://127.0.0.1:8081/client1/echo.json>* and returned the filesystem resource */data/client1/echo.json*

Moreover, the second message had similar processing. In fact, the only difference is that the HTTP request path */api/client2/echo.json* is translated to /*client2/echo.json*.

---

### [Single server, nginx as a reverse proxy, multiple domains/websites](https://serverfault.com/questions/886582/single-server-nginx-as-a-reverse-proxy-multiple-domains-websites)

#### Question

I have this nginx config for my website on https where nginx is used as a reverse proxy server:

```nginx
  server {
      listen 80 default_server;
      listen [::]:80 default_server;
      server_name my_domain123.com www.my_domain123.com;
      return 301 https://$server_name$request_uri;
  }

  server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name localhost www.my_domain123.com;
    return 301 https://my_domain123.com$request_uri;
  }

  server {
      listen 443 ssl default_server;
      listen [::]:443 ssl default_server;
      server_name my_domain123.com;

    location / {
      proxy_redirect      http://localhost:4000 https://my_domain123.com;
      # ...........................

    }
```

How should I adjust it so that I can host **multiple** websites with **different** domain names on the **same server**? Where in the config exactly should I insert the new configuration for that new website?

Or should I create one more site-available/enabled for it also? **Yet, the question remains:** how would I combine 2 or more configurations -- same server, multiple domains -- properly?

#### Answer

Normally you create a new config file `/etc/nginx/sites-available/newserver.conf` for the new server and link it from `/etc/nginx/sites-enabled`.
To use nginx as reverse proxy, you configure SSL in nginx (`ssl_certificate`, ...) and in the location section you use `proxy_pass` to the non SSL server at localhost. `proxy_redirect` is also needed, but that only modifies the `Location` header in case your non SSL local server sends one.
You find an example in the following [article](https://www.digitalocean.com/community/tutorials/how-to-configure-nginx-with-ssl-as-a-reverse-proxy-for-jenkins).

**Multiple http servers on localhost using different ports**

```nginx
server {
    server_name mydomain-01.com;

    location / {
      proxy_redirect http://localhost:8001 https://mydomain-01.com;
      ...
    }
}
server {
    server_name mydomain-02.com;

    location / {
      proxy_redirect http://localhost:8002 https://mydomain-02.com;
      ...
    }
}
```

**Single http server on localhost using hostname based sites**

```nginx
server {
    server_name mydomain-01.com;

    location / {
      proxy_redirect http://s1.localdomain:4000 https://mydomain-01.com;
      ...
    }
}
server {
    server_name mydomain-02.com;

    location / {
      proxy_redirect http://s2.localdomain:4000 https://mydomain-02.com;
      ...
    }
}
```

---

### [How to create reverse proxy for multiple websites in nginx](https://stackoverflow.com/questions/68196179/how-to-create-reverse-proxy-for-multiple-websites-in-nginx)

#### Question

I have many different technologies serving APIs and sites on my local machine. I want to be able to see them via human-readable names, rather than ports.

For example, I have:

- localhost:8000 => laravel api for user panel
- localhost:8001 => laravel api for admin panel
- localhost:3000 => react client for user panel
- localhost:3001 => nextjs client for site
- localhost:3002 => react client for admin panel

And this list goes on.

Remembering all these ports is not possible of course. Thus I thought to setup a reverse proxy for them:

- api.user.example.local
- api.admin.example.local
- example.local
- user.example.local
- admin.example.local

I know I have to add these host headers to `/etc/hosts` file. I also read about [how to configure nginx as a reverse proxy](https://www.interserver.net/tips/kb/local-domain-names-ubuntu/) **for one domain**.

I don't know how to do it for many sites. And only as a reverse proxy, not as a server.

#### Answer

Please note: I'm not considering myself as really super nginx expert, just starting to learn nginx, but I think I can help you with this task.

Here is my approach:

First, make sure your default nginx config (usually `/etc/nginx/nginx.conf`) has line `include /etc/nginx/conf.d/*.conf;` in its `http` block, so you may specify internal servers in separate config files for ease of use.

Create additional config file `/etc/nginx/conf.d/local_domains.conf` and add following server blocks in it:

```nginx
server {
    listen         80;
    server_name    api.user.example.local;

    location / {
    set $target http://localhost:8000;
    proxy_pass $target;
  }
}

server {
    listen         80;
    server_name    api.admin.example.local;

    location / {
    set $target http://localhost:8001;
    proxy_pass $target;
  }
}

server {
    listen         80;
    server_name    example.local;

    location / {
    set $target http://localhost:3000;
    proxy_pass $target;
  }
}

server {
    listen         80;
    server_name    user.example.local;

    location / {
    set $target http://localhost:3001;
    proxy_pass $target;
  }
}

server {
    listen         80;
    server_name    admin.example.local;

    location / {
    set $target http://localhost:3002;
    proxy_pass $target;
  }
}
```

On the client machine, add these records to the `hosts` file

```properties
192.168.1.1  api.user.example.local
192.168.1.1  api.admin.example.local
192.168.1.1  example.local
192.168.1.1  user.example.local
192.168.1.1  admin.example.local
```

Where `192.168.1.1` is the address of your nginx server.

That's it, it should work if your internal servers are using HTTP protocol.

But if you need to use HTTPS for internal servers and for the main nginx server, modify each server block as follows:

```nginx
server {
    listen         443 ssl http2;
    server_name    api.user.example.local;

    ssl_certificate          /usr/local/share/ca-certificates/example.local.crt;
    ssl_certificate_key      /usr/local/share/ca-certificates/example.local.key;
    add_header Strict-Transport-Security "max-age=31536000" always;

    location / {
    set $target https://api.user.example.local:8000;
    proxy_pass $target;
  }
}

and so on
```

`ssl_certificate` and `ssl_certificate_key` should point to correct certificate and key files for the domain.

If you would like nginx main server to listen port 80 and redirect all traffic to https, add additional server blocks for each server:

```nginx
server {
    server_name api.user.example.local;
    listen 80;

  # Force redirection to https on nginx side
  location / {
        return 301 https://$host$request_uri;
    }
}

and so on
```

More information on NGINX Reverse Proxy

- [NGINX Reverse Proxy](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)
- [Module ngx_http_proxy_module](https://nginx.org/en/docs/http/ngx_http_proxy_module.html)
