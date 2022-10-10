# how to make synology nas as subnet router
# https://youtu.be/uJ8PsImiDrM
sudo tailscale up --advertise-routes=192.168.1.0/24 --reset

# then edit subnet routes in tailscale admin panel, add subnet and DISABLE KEY EXPIRE on subnet router

# to disable subnet routing on nas:
sudo tailscale ip --reset

# don't forget to remove subnet routes from admin panel and ENABLE KEY EXPIRE