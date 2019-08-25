## Ubuntu Desktop (GNOME 3) Dockerfile


This repository contains the *Dockerfile* and *associated files* for setting up a container with Ubuntu, GNOME and TigerVNC.

* The VNC Server currently defaults to 1366*768 24bit.

### Dependencies

* [ubuntu:19.10](https://hub.docker.com/_/ubuntu)


### Usage

#### Container actions

* Start container:

      sudo docker run --name=ubuntu-gnome -it -d --rm \
        --tmpfs /run --tmpfs /run/lock --tmpfs /tmp \
        --cap-add SYS_ADMIN --security-opt apparmor:unconfined \
        -v /sys/fs/cgroup:/sys/fs/cgroup \
        -p 5901:5901 \
        darkdragon001/ubuntu-gnome-vnc`

* Open (root) shell:

      sudo docker exec -it ubuntu-gnome bash

* Open shell as user:

      sudo docker exec -it -u default ubuntu-gnome bash

* Stop container:

      sudo docker stop ubuntu-gnome

#### Connecting to instance

* Connect to `vnc://<host>:5901` via your VNC client. currently the password is hardcoded to "acoman"

#### Using the desktop

* Gain root access via `sudo`


### Known issues

* Sidebar/dock hidden by default
* Settings panel not working
* User switching / gdm3 not working
