### SYNOLOGY ------------------------------------

### Backup speed and smb setting ###
https://forums.veeam.com/veeam-agent-for-windows-f33/solved-veeam-backup-to-synology-nas-takes-forever-t63558.html
It took me some signifianct time to search the internet on Veeam's and Synology's web sites and some other support forums to find a hint which really improved the situation. In the end the fix was "trivial", just changing a single checkbox in the Synology setup: On the Synology system just check "Do not reserve disk space when creating files"
within Control Panel -> File Services -> SMB -> Advanced Settings . Actually you even have to scroll down in that dialogue in order to see that option ... ;-)


### data checksum for advanced data integrity ###
Turn off data checksum for advanced data integrity on Time Machine folder and other backup and VMs folders.




