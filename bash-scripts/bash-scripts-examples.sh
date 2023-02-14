# ssh to different hosts and execute commands there
       │ File: remhosts
───────┼─────────────────────────────────────────────────────────────────────────────────────────────
   1   │ web01
   2   │ web02
   3   │ web03

for host in `cat remhosts`; do ssh devops@$host uptime;done