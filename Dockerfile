FROM ubuntu:19.10

ENV container docker
ENV DEBIAN_FRONTEND noninteractive

# Install systemd
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
RUN apt-get update && apt-get install -y \
    dbus dbus-x11 systemd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* &&\
    dpkg-divert --local --rename --add /sbin/udevadm &&\
    ln -s /bin/true /sbin/udevadm
# TODO maybe disable other targets: https://developers.redhat.com/blog/2014/05/05/running-systemd-within-docker-container/
RUN systemctl disable systemd-resolved
VOLUME ["/sys/fs/cgroup"]
STOPSIGNAL SIGRTMIN+3
CMD [ "/sbin/init" ]

# Install GNOME
# NOTE if you want plain gnome, use: apt-get install -y --no-install-recommends gnome-shell gnome-terminal
RUN apt-get update \
  && apt-get install -y ubuntu-desktop \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install TigerVNC server
# TODO check if it works with default config file
# NOTE tigervnc because of XKB extension: https://github.com/i3/i3/issues/1983
RUN apt-get update \
  && apt-get install -y tigervnc-common tigervnc-scraping-server tigervnc-standalone-server tigervnc-viewer tigervnc-xorg-extension \
  && rm -f /etc/vnc.conf \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
# TODO specify options like geometry as environment variables -> source variables in service via EnvironmentFile=/path/to/env
COPY tigervnc.service /etc/systemd/system/tigervnc.service
RUN systemctl enable tigervnc

# Create unprivileged user
# NOTE user hardcoded in tigervnc.service
# NOTE alternative is to use libnss_switch and create user at runtime -> use entrypoint script
ARG UID=1000
ARG USER=default
RUN useradd ${USER} -u ${UID} -U -d /home/${USER} -m -s /bin/bash
RUN apt-get update && apt-get install -y sudo && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${USER}" && \
    chmod 440 "/etc/sudoers.d/${USER}"
USER "${USER}"
ENV USER="${USER}" \
    HOME="/home/${USER}"
WORKDIR "/home/${USER}"

# Set up VNC
RUN mkdir -p $HOME/.vnc
COPY xstartup $HOME/.vnc/xstartup
RUN echo "acoman" | vncpasswd -f >> $HOME/.vnc/passwd && chmod 600 $HOME/.vnc/passwd
EXPOSE 5901

# switch back to root to start systemd
USER root

