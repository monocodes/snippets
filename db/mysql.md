---
title: mysql
categories:
  - software
  - notes
  - guides
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [mysql install](#mysql-install)
  - [mysql paths](#mysql-paths)
- [mysql commands](#mysql-commands)
- [mysql-client commands](#mysql-client-commands)
- [mysql backup](#mysql-backup)
- [mysql notes](#mysql-notes)

## mysql install

install mysql on **deb-based distro**

```sh
apt install mysql
```

install mysql on **rpm-based** distro

```sh
dnf install mariadb-server
```

install **mysql** client on **deb-based** distro

```sh
apt install mysql-client
```

install **mysql** client on **rpm-based** distro

```sh
sudo dnf install mysql
```

---

### mysql paths

mysql default db path

```sh
/var/lib/mysql
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

check table entries

```mysql
describe table-name;

select quaries;

select * from table-name;
```

---

## mysql-client commands

connect to mysql instance via `mysql-client`  
`-h` - host

```sh
mysql -h hostname -u username -pPassword

# example
mysql -h vprofile-rds-mysql.cyg76sxmwbec.us-east-1.rds.amazonaws.com -u admin -pG6TfrbTYjU2uM3TidgP0
```

connect to mysql instance and select database

```sh
mysql -h hostname -u username -pPassword database-name
```

restore mysql backup to a running mysql instance

```sh
mysql -h vprofile-bean-rds.cyg76sxmwbec.us-east-1.rds.amazonaws.com -u admin -pQuz9qrKNPY97jqVa5T8B accounts < src/main/resources/db_backup.sql
```

---

## mysql backup

restore mysql database backup

```sh
mysql -h hostname -u username -pPassword database-name < backup-name.sql

# example
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
