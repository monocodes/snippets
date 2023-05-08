---
title: Small Bash Scripts
categories:
  - bash
  - scripts
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [ssh to different hosts and execute commands there](#ssh-to-different-hosts-and-execute-commands-there)
- [small script to test monitoring alarms](#small-script-to-test-monitoring-alarms)

## ssh to different hosts and execute commands there

remhosts

```properties
web01
web02
web03
```

```sh
for host in `cat remhosts`; do ssh devops@$host uptime;done
```

---

## small script to test monitoring alarms

stress.sh

```sh
#!/bin/bash
sudo stress -c 4 -t 60 && sleep 60 && stress -c 4 -t 60 && sleep 60 && stress -c 4 -t 360 && sleep  && stress -c 4 -t 460 && sleep 30 && stress -c 4 -t 360 && sleep 60
```

run it in background

```sh
nohup ./stress.sh &
```
