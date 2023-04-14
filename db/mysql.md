---
title: mysql
categories:
  - software
  - notes
  - guides
author: wandering-mono
url: https://github.com/wandering-mono/snippets.git
---

# mysql

- [mysql](#mysql)
  - [mysql commands](#mysql-commands)
  - [mysql-client commands](#mysql-client-commands)
  - [mysql backup](#mysql-backup)

## mysql commands

show databases

```mysql
show databases;
```

create database

```mysql
create database-name;
```

select database

```mysql
use database-name;
```

show tables

```mysql
show tables;
```

---

## mysql-client commands

connect to mysql instance via `mysql-client`  
`-h` - host

```shell
mysql -h hostname -u username -pPassword
```

> example

```shell
mysql -h vprofile-rds-mysql.cyg76sxmwbec.us-east-1.rds.amazonaws.com -u admin -pG6TfrbTYjU2uM3TidgP0
```

connect to mysql instance and select database

```shell
mysql -h hostname -u username -pPassword database-name
```

---

## mysql backup

restore mysql database backup

```shell
mysql -h hostname -u username -pPassword database-name < backup-name.sql
```

> example

```shell
mysql -h vprofile-rds-mysql.cyg76sxmwbec.us-east-1.rds.amazonaws.com -u admin -pG6TfrbTYjU2uM3TidgP0 accounts < db_backup.sql
```

---
