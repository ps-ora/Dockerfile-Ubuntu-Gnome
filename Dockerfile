FROM darkdragon001/ubuntu-gnome-vnc:latest
# TODO split and run build with --squash (wait for hub.docker.com support: https://github.com/docker/hub-feedback/issues/955)

### Install software
# TODO chromium-browser uses snaps: https://github.com/ConSol/docker-headless-vnc-container/issues/137
RUN wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
# TODO wait for ppas to publish version
#RUN apt-add-repository -y ppa:ubuntuhandbook1/avidemux          # avidemux
RUN apt-add-repository -y ppa:heyarje/makemkv-beta              # makemkv-bin makemkv-oss
RUN wget -q -O - https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt | sudo apt-key add - \
    && apt-add-repository -y 'https://mkvtoolnix.download/ubuntu'  # mkvtoolnix mkvtoolnix-gui
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    openssh-server \
    default-jre \
    bzip2 cifs-utils zip unzip rar unrar p7zip-full p7zip-rar genisoimage squashfs-tools xarchiver \
    less nano vim \
    curl filezilla inetutils-ping nmap wget \
    git meld \
    terminator \
    atom evince gimp inkscape libreoffice \
    firefox \
    imagemagick libimage-exiftool-perl exiv2 jhead \
    acidrip ffmpeg handbrake makemkv-bin makemkv-oss mediainfo mkvtoolnix mkvtoolnix-gui vcdimager vlc \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
# TODO modify settings/customizations

