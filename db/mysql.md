---
title: mysql
categories:
  - software
  - notes
  - guides
author: wandering-mono
url: https://github.com/monocodes/snippets.git
---

- [mysql paths](#mysql-paths)
- [mysql commands](#mysql-commands)
- [mysql-client commands](#mysql-client-commands)
- [mysql backup](#mysql-backup)
- [mysql notes](#mysql-notes)

## mysql paths

mysql default db path

```sh
/var/lib/path
```

---

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

```sh
mysql -h hostname -u username -pPassword
```

> example

```sh
mysql -h vprofile-rds-mysql.cyg76sxmwbec.us-east-1.rds.amazonaws.com -u admin -pG6TfrbTYjU2uM3TidgP0
```

connect to mysql instance and select database

```sh
mysql -h hostname -u username -pPassword database-name
```

---

## mysql backup

restore mysql database backup

```sh
mysql -h hostname -u username -pPassword database-name < backup-name.sql
```

> example

```sh
mysql -h vprofile-rds-mysql.cyg76sxmwbec.us-east-1.rds.amazonaws.com -u admin -pG6TfrbTYjU2uM3TidgP0 accounts < db_backup.sql
```

---

## mysql notes

ignore if directory not empty, example with k8s

```yaml
spec:
      containers:
        - name: vprodb
          image: vprofile/vprofiledb:V1
          args:
            - "--ignore-db-dir=lost+found"
```
