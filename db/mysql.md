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
- [BigQuery](#bigquery)
  - [it-gws-logs-419913](#it-gws-logs-419913)
    - [Check dataset size](#check-dataset-size)
    - [Check min and max dates for activity](#check-min-and-max-dates-for-activity)
    - [Email report for one user](#email-report-for-one-user)
    - [Email reports for all by date](#email-reports-for-all-by-date)
    - [Minimal data check in usage](#minimal-data-check-in-usage)
    - [Total sent and received emails for full domain](#total-sent-and-received-emails-for-full-domain)
  - [metabase-sso-373616](#metabase-sso-373616)
    - [Usage DB](#usage-db)
      - [GWS → BigQuery Email Reports](#gws--bigquery-email-reports)
      - [GWS → BigQuery Email Reports for all by date](#gws--bigquery-email-reports-for-all-by-date)
      - [GWS → BigQuery Check last date](#gws--bigquery-check-last-date)
    - [Activity DB](#activity-db)
      - [GWS → BigQuery Check min and max date](#gws--bigquery-check-min-and-max-date)

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

---

## BigQuery

### it-gws-logs-419913

#### Check dataset size

```sql
select 
  sum(size_bytes)/pow(10,9) as size
from
  `it-gws-logs-419913.LogsData`.__TABLES__
```

#### Check min and max dates for activity

```sql
SELECT
  min(TIMESTAMP_TRUNC(_PARTITIONTIME, DAY)) as min_date,
  max(TIMESTAMP_TRUNC(_PARTITIONTIME, DAY)) as max_date
FROM `it-gws-logs-419913.LogsData.activity`
--WHERE TIMESTAMP_TRUNC(_PARTITIONTIME, DAY) = TIMESTAMP("2024-01-24")
--LIMIT 1000
```

#### Email report for one user

```sql
SELECT
  user_email,
  min(date) as min_date,
  max(date) as max_date,
  sum(gmail.num_emails_received) as received,
  sum(gmail.num_emails_sent) as sent
FROM `it-gws-logs-419913.LogsData.usage`
WHERE user_email != ''
  -- AND date between '2023-12-19' and '2024-01-18'
  AND user_email = 'user@domain.com'
GROUP BY user_email
```

#### Email reports for all by date

```sql
SELECT
  user_email,
  sum(gmail.num_emails_sent) as sent,
  sum(gmail.num_emails_received) as received,
  min(date) as min_date,
  max(date) as max_date,
FROM `it-gws-logs-419913.LogsData.usage`
WHERE user_email != ''
  AND date between '2024-11-09' and '2024-12-09'
  AND user_email in ('user@domain.com,'user2@domain.com','')
GROUP BY user_email
order by user_email
```

#### Minimal data check in usage

```sql
SELECT min(date) FROM `it-gws-logs-419913.LogsData.usage`
```

#### Total sent and received emails for full domain

```sql
SELECT
  -- user_email,
  sum(gmail.num_emails_sent) as sent,
  sum(gmail.num_emails_received) as received,
  min(date) as min_date,
  max(date) as max_date,
FROM `it-gws-logs-419913.LogsData.usage`
-- WHERE user_email != ''
  WHERE date between '2024-07-09' and '2024-08-09'
  -- AND user_email in ('user@domain.com,'user2@domain.com','')
-- GROUP BY user_email
-- order by user_email
```

### metabase-sso-373616

#### Usage DB

##### GWS → BigQuery Email Reports

```sql
SELECT
  user_email,
  min(date) as min_date,
  max(date) as max_date,
  sum(gmail.num_emails_received) as received,
  sum(gmail.num_emails_sent) as sent
FROM `metabase-sso-373616.LogsData.usage`
WHERE user_email != ''
  AND date between '2023-12-19' and '2024-01-18'
  AND user_email = 'user@domain.com'
GROUP BY user_email
```

##### GWS → BigQuery Email Reports for all by date

```sql
SELECT
  user_email,
  sum(gmail.num_emails_sent) as sent,
  sum(gmail.num_emails_received) as received,
  min(date) as min_date,
  max(date) as max_date,
FROM `metabase-sso-373616.LogsData.usage`
WHERE user_email != ''
  AND date between '2023-11-25' and '2023-12-25'
  AND user_email in ('user@domain.com',)
GROUP BY user_email
order by user_email
```

##### GWS → BigQuery Check last date

```sql
SELECT min(date) FROM `metabase-sso-373616.LogsData.usage`
```

#### Activity DB

##### GWS → BigQuery Check min and max date

```sql
SELECT
  min(TIMESTAMP_TRUNC(_PARTITIONTIME, DAY)) as min_date,
  max(TIMESTAMP_TRUNC(_PARTITIONTIME, DAY)) as max_date
FROM `metabase-sso-373616.LogsData.activity`
--WHERE TIMESTAMP_TRUNC(_PARTITIONTIME, DAY) = TIMESTAMP("2024-01-24")
--LIMIT 1000
```

---
