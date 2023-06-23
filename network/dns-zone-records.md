---
title: dns-zone-records
categories:
  - software
  - network
  - notes
  - guides
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [dns-cheatsheet by chrisachard @ chrisachard.com](#dns-cheatsheet-by-chrisachard--chrisachardcom)
  - [Defining DNS Records](#defining-dns-records)
  - [Most common types of DNS records](#most-common-types-of-dns-records)
- [Common DNS Records](#common-dns-records)
- [Common record types](#common-record-types)
  - [Common DNS records](#common-dns-records-1)
    - [1. Root domain (`example.com`)](#1-root-domain-examplecom)
      - [To verify](#to-verify)
    - [2. www subdomain: (`www.example.com`)](#2-www-subdomain-wwwexamplecom)
      - [To verify](#to-verify-1)
    - [3. MX email records](#3-mx-email-records)
      - [To verify](#to-verify-2)
    - [4. CAA record](#4-caa-record)
      - [To verify](#to-verify-3)

## dns-cheatsheet by chrisachard @ [chrisachard.com](https://chrisachard.com)

### Defining DNS Records

| Name     | Example                                                      |
| -------- | ------------------------------------------------------------ |
| TYPE     | A, AAAA, CNAME, ALIAS, ANAME, TXT, MX                        |
| HOST     | The root (@ or blank) or subdomain (www, app, blog, etc) where you want to place the record |
| VALUE    | Can be an IP address (A, AAAA) another domain (CNAME, ALIAS, ANAME, MX) or arbitrary value (TXT) |
| PRIORITY | Only for MX records you will be given what value and priority to use by your email provider |
| TTL      | Time to Live How long to let record values be cached Shorter = better for fast changing values Longer = faster resolution time and less          traffic for your DNS server |

### Most common types of DNS records

| DNS record | Example                                                      |
| ---------- | ------------------------------------------------------------ |
| A          | Map domain name to IPv4 address Ex: `example.com => 127.0.0.1` |
| AAAA       | Map domain name to IPv6 address Ex: `example.com => ::1`     |
| CNAME      | Map domain name to another domain name CAUTION! Don’t do this on the root (@) Ex: `www.example.com => example.com` |
| ALIAS      | Map domain name to another domain name CAN do this on the root Ex: `example.com => example.herokudns.com` |
| ANAME      | Another name for ALIAS (different providers name it differently; also “virtual CNAME”) Ex: `example.com => example.netlify.com` |
| TXT        | Set arbitrary data on your domain record Ex: `@ => my-domain-is-awesome-123` |
| MX         | Setup custom email for your domain Ex: `@ => ASPMX.L.GOOGLE.COM. 1` |

---

## [Common DNS Records](https://support.dnsimple.com/articles/common-dns-records/#common-dns-records-1)

The Domain Name System (DNS) is composed of many different record types (or resource records): `A`, `AAAA`, `CNAME`, `MX`, `CAA`, etc. Some record types are common. Others are less relevant, deprecated, or replaced.

[DNSimple supports common and traditional record types](https://support.dnsimple.com/articles/supported-dns-records), along with some newer types introduced to provide innovative services. In this article, we’ll look at the most common record types, and explore the most common DNS records you need for your domains to work.

## Common record types

These are the most common DNS record types:

| Type                                                         | Description                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [`A` record](https://support.dnsimple.com/articles/a-record) | This is the most popular type. A records create a DNS record that points to an IPv4 address. It allows you to use memonic names, such as `www.example.com`, in place of IP addresses like `127.0.0.1`. |
| [`CNAME` record](https://support.dnsimple.com/articles/cname-record) | This record works as an alias and maps one name to another. It’s often used to reduce duplication in domain name configurations. It also simplifies the maintenance of multiple records connected to the same IP address. It’s one of the common mechanisms that’s been adopted by cloud services to provision customer-specific services. |
| [`MX` record](https://support.dnsimple.com/articles/mx-record) | This record is used to identify the servers mail should be delivered to for a domain. You need to have these records configured to receive emails. |
| [`TXT` record](https://support.dnsimple.com/articles/txt-record) | This record is used to associate text with a domain.         |
| [`NS` record](https://support.dnsimple.com/articles/ns-record) | This record is used to delegate a subzone to a set of name servers. These are the types of records you need to modify when you want to delegate a domain to a DNS provider. |
| [`SOA` record](https://support.dnsimple.com/articles/soa-record) | This record stores important information about the DNS zone (your domain). Each zone must have an SOA record. However, it’s unlikely you’ll have to create a SOA record directly. DNSimple automatically manages the SOA records for all your domains. |

---

### Common DNS records

Although each domain is unique, and will likely have a special DNS configuration, there’s a basic set of DNS records that’s common among the majority of domains.

If you just purchased a domain or are reviewing your domain’s DNS configuration, compare the DNS records in your domain with the following to determine whether or not anything’s missing:

This article assumes `example.com` is your domain name.

#### 1. Root domain (`example.com`)

Each domain needs to have a record for the root domain. Otherwise your domain won’t resolve, and accessing the URL in the browser will return a resolution error.

In most cases, this configuration is an A record pointing to the IP where your site is hosted. However, it can also be an ALIAS if your site is hosted elsewhere (this is common when you want to point your root domain to a cloud service, such as Heroku, Netlify, GitHub, etc.), or a URL record if the domain needs to redirect elsewhere.

##### To verify

1. Use `dig example.com` to check the presence of a root record.

2. The answer should return at least one A record as below:

   ```sh
    dig dnsimple.com
   
    ;; ANSWER SECTION:
    dnsimple.com.		59	IN	A	104.245.210.170
   ```

   Both ALIAS and URL records are synthetized as A records.

   If you see a CNAME record, your configuration is invalid. The CNAME can’t be used for the root domain.

#### 2. www subdomain: (`www.example.com`)

It’s common to have the `www` subdomain configured in addition to the root domain. There are several possibilities:

1. Using an A record to point to the same IP of the root domain.
2. Using a CNAME record to point to the root domain.
3. Using a URL record to redirect to the root domain.

Using an ALIAS record for the `www` subdomain is not incorrect, however it’s generally unnecessary. In most cases, you can replace the ALIAS with the CNAME.

##### To verify

1. Use `dig www.example.com` to check the presence of a www record.

2. The answer should return at least one A record or exactly one CNAME record as below:

   ```sh
    dig www.dnsimple.com
   
    ;; ANSWER SECTION:
    www.dnsimple.com.	59	IN	A	104.245.210.170
   ```

   ```sh
    dig www.dnsimple.com
   
    ;; ANSWER SECTION:
    www.dnsimple.com.	3599	IN	CNAME	dnsimple.com.
    dnsimple.com.		59	IN	A	104.245.210.170
   ```

#### 3. MX email records

If you want to receive emails for your domain, you need to have at least one MX record pointing to your doamin mail server. For rendudancy, there are generally two or more MX records, each with different content and priority.

##### To verify

1. Use `dig MX example.com` to check the presence of MX records on the root domain.

2. The answer should return at least one MX record as below:

   ```sh
    dig MX www.dnsimple.com
   
    ;; ANSWER SECTION:
    dnsimple.com.		3599	IN	MX	1 aspmx.l.google.com.
    dnsimple.com.		3599	IN	MX	5 alt1.aspmx.l.google.com.
    dnsimple.com.		3599	IN	MX	5 alt2.aspmx.l.google.com.
    dnsimple.com.		3599	IN	MX	10 alt3.aspmx.l.google.com.
    dnsimple.com.		3599	IN	MX	10 alt4.aspmx.l.google.com.
   ```

#### 4. CAA record

It’s advisable to [add a CAA record](https://support.dnsimple.com/articles/caa-record) to the root domain to specify which certificate authorities can issue a certificate for your domain.

##### To verify

1. Use `dig CAA example.com` to check for the presence of a CAA record on the root domain.

2. The answer should return at least one CAA record as below:

   ```sh
    dig CAA www.dnsimple.com
   
    ;; ANSWER SECTION:
    dnsimple.com.		3599	IN	CAA	0 iodef "mailto:ops@dnsimple.com"
    dnsimple.com.		3599	IN	CAA	0 issue "amazonaws.com"
    dnsimple.com.		3599	IN	CAA	0 issue "sectigo.com"
    dnsimple.com.		3599	IN	CAA	0 issue "letsencrypt.org"
    dnsimple.com.		3599	IN	CAA	0 issuewild "sectigo.com"
   ```

---
