#
# Ubuntu Desktop (Gnome) Dockerfile
#
# https://github.com/darkdragon-001/Docker-Ubuntu-Desktop-Gnome
#

# Pull base image
FROM ubuntu:19.04

# Install GNOME and tightvnc server
# TODO get gnome-shell or gnome-session (gnome-session-flashback) running -> apt install and start in xstartup
ENV DEBIAN_FRONTEND noninteractive
RUN sed -i 's/^#\s+\(deb.*universe\)$/\1/g' /etc/apt/sources.list
RUN apt-get update \
  && apt-get install -y --no-install-recommends ubuntu-desktop \
  && apt-get install -y gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal \
  && apt-get install -y tightvncserver \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*

# Set up VNC
RUN mkdir -p /root/.vnc
COPY xstartup /root/.vnc/xstartup
COPY spawn-desktop.sh /usr/local/etc/spawn-desktop.sh
# TODO use TigerVNC: https://www.cyberciti.biz/faq/install-and-configure-tigervnc-server-on-ubuntu-18-04/
# -> get rid of expect.deb and start-vnc-expect-script.sh -> see spawn-desktop.sh
RUN apt-get update && apt-get install -y \
  expect  \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*
COPY start-vnc-expect-script.sh /usr/local/etc/start-vnc-expect-script.sh

# Define entrypoint
ENTRYPOINT ["/usr/local/etc/spawn-desktop.sh"]
CMD ["bash"]

# Expose ports
EXPOSE 5901

