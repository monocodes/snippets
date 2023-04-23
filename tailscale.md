# tailscale

- [tailscale](#tailscale)
  - [how to make synology nas as subnet router](#how-to-make-synology-nas-as-subnet-router)

## how to make synology nas as subnet router

> <https://youtu.be/uJ8PsImiDrM>

1. ```sh
    sudo tailscale up --advertise-routes=192.168.1.0/24 --reset
    ```

2. then edit subnet routes in tailscale admin panel, add `subnet` and `DISABLE KEY EXPIRE` on subnet router

To disable subnet routing on nas:

1. ```sh
    sudo tailscale ip --reset
    ```

2. don't forget to remove subnet routes from admin panel and ENABLE KEY EXPIRE
