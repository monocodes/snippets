# keenetic-cli

- [keenetic-cli](#keenetic-cli)

connect to the router via ssh

show dns settings including static dns records

```text
show dns-proxy
```

add new static dns record

```text
ip host hostname ip-address
ip host h-ub22-ud-01 192.168.1.11
system configuration save
```

delete static dns record

```text
no ip host hostname ip-address
no ip host h-ub22-ud-01 192.168.1.11
system configuration save
```
