### example ###
#       30      20      *               *       1-5     /opt/scripts/11_monit.sh
# run the script every day during monday-friday at 20:30



#       minute  hour    day of month    month   day of week # 0 for sunday
#       MM      HH      DOM             mm      DOW     COMMAND
        *       *       *               *       *       /opt/scripts/11_monit.sh &>> /var/log/monit_httpd.log