# ssh to different hosts and execute commands there
       │ File: remhosts
───────┼─────────────────────────────────────────────────────────────────────────────────────────────
   1   │ web01
   2   │ web02
   3   │ web03

for host in `cat remhosts`; do ssh devops@$host uptime;done




-------------------------------------------------
# small script to test monitoring alarms
# stress.sh
#!/bin/bash
sudo stress -c 4 -t 60 && sleep 60 && stress -c 4 -t 60 && sleep 60 && stress -c 4 -t 360 && sleep  && stress -c 4 -t 460 && sleep 30 && stress -c 4 -t 360 && sleep 60

# run it in background
nohup ./stress.sh &