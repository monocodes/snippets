---
title: Small Bash Scripts
categories:
  - bash
  - scripts
author: wandering-mono
url: https://github.com/wandering-mono/snippets.git
---

# Small Bash Scripts

- [Small Bash Scripts](#small-bash-scripts)
  - [ssh to different hosts and execute commands there](#ssh-to-different-hosts-and-execute-commands-there)
  - [small script to test monitoring alarms](#small-script-to-test-monitoring-alarms)

## ssh to different hosts and execute commands there

remhosts

```bash
web01
web02
web03
```

```bash
for host in `cat remhosts`; do ssh devops@$host uptime;done
```

---

## small script to test monitoring alarms

stress.sh

```bash
#!/bin/bash
sudo stress -c 4 -t 60 && sleep 60 && stress -c 4 -t 60 && sleep 60 && stress -c 4 -t 360 && sleep  && stress -c 4 -t 460 && sleep 30 && stress -c 4 -t 360 && sleep 60
```

run it in background

```bash
nohup ./stress.sh &
```
