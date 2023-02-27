******************************************************************************
# crontab
******************************************************************************

#       30      20      *               *       1-5     /opt/scripts/11_monit.sh
# run the script every day during monday-friday at 20:30



#       minute  hour    day of month    month   day of week # 0 for sunday
#       MM      HH      DOM             mm      DOW     COMMAND
        *       *       *               *       *       /opt/scripts/11_monit.sh &>> /var/log/monit_httpd.log





******************************************************************************
# fstab
******************************************************************************

#
# /etc/fstab
# Created by anaconda on Sun Nov 14 11:52:41 2021
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
UUID=44a6a613-4e21-478b-a909-ab653c9d39df /                       xfs     defaults        0 0
/dev/xvdf1      /var/www/html/images    ext4    defaults        0 0
/dev/xvdg1      /var/lib/mysql  ext4    defaults        0 0