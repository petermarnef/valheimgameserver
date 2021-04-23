FROM ubuntu:18.04 AS original-dockerfile

ENV DEBIAN_FRONTEND noninteractive

RUN set -ex; \
apt-get update; \
apt-get install -y locales; \
rm -rf /var/lib/apt/lists/*; \
localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

## Base System
RUN set -ex; \
dpkg --add-architecture i386; \
apt update -y; \
apt install -y \
    vim \
    apt-transport-https \
    bc \
    binutils \
    bsdmainutils \
    bzip2 \
    ca-certificates \
    curl \
    default-jre \
    expect \
    file \
    gzip \
    iproute2 \
    jq \
    lib32gcc1 \
    lib32stdc++6 \
    lib32tinfo5 \
    lib32z1 \
    libcurl4-gnutls-dev:i386 \
    libdbus-glib-1-2:i386 \
    libglu1-mesa:i386 \
    libldap-2.4-2:i386 \
    libncurses5:i386 \
    libnm-glib-dev:i386 \
    libnm-glib4:i386 \
    libopenal1:i386 \
    libpulse0:i386 \
    libsdl1.2debian \
    libsdl2-2.0-0:i386 \
    libssl1.0.0:i386 \
    libstdc++5:i386 \
    libstdc++6 \
    libstdc++6:i386 \
    libtbb2 \
    libtcmalloc-minimal4:i386 \
    libusb-1.0-0:i386 \
    libxrandr2:i386 \
    libxtst6:i386 \
    mailutils \
    netcat \
    postfix \
    python \
    speex:i386 \
    telnet \
    tmux \
    unzip \
    util-linux \
    wget \
    xz-utils \
    zlib1g \
    zlib1g:i386; \
apt-get clean; \
rm -rf /var/lib/apt/lists/*

## linuxgsm.sh
RUN set -ex; \
wget https://raw.githubusercontent.com/GameServerManagers/LinuxGSM/master/linuxgsm.sh

## user config
RUN set -ex; \
groupadd -g 750 -o linuxgsm; \
adduser --uid 750 --disabled-password --gecos "" --ingroup linuxgsm linuxgsm; \
chown linuxgsm:linuxgsm /linuxgsm.sh; \
chmod +x /linuxgsm.sh; \
cp /linuxgsm.sh /home/linuxgsm/linuxgsm.sh; \
usermod -G tty linuxgsm; \
chown -R linuxgsm:linuxgsm /home/linuxgsm/; \
chmod 755 /home/linuxgsm

USER linuxgsm

WORKDIR /home/linuxgsm

# need use xterm for LinuxGSM
ENV TERM=xterm

## Docker Details
ENV PATH=$PATH:/home/linuxgsm

# CUSTOM STUFF
FROM original-dockerfile AS withdependencies

USER root

RUN dpkg --add-architecture i386; apt-get update; apt-get install -y curl wget file tar bzip2 gzip unzip bsdmainutils python util-linux ca-certificates binutils bc jq tmux netcat lib32gcc1 lib32stdc++6; \
    echo steam steam/question select "I AGREE" | debconf-set-selections; \
    echo steam steam/license note '' | debconf-set-selections; \
    dpkg --add-architecture i386; \
    apt-get -q -y update DEBIAN_FRONTEND=noninteractive; \
    apt-get install -q -y --no-install-recommends lib32gcc1 steamcmd ca-certificates gosu; \
    ln -sf /usr/games/steamcmd /usr/bin/steamcmd; \
    DEBIAN_FRONTEND=noninteractive apt-get autoremove -q -y; \
    rm -rf /var/lib/apt/lists/*;

COPY ./files-used-during-docker-build/vhserverstart.sh .
RUN chmod +x ./vhserverstart.sh;

USER linuxgsm

RUN echo 109 | ./linuxgsm.sh install; \
    printf "Y\nY\nY\n" | vhserver install; \
    mkdir valheimgameserverbackup;

COPY ./files-used-during-docker-build/vhserver.cfg ./lgsm/config-lgsm/vhserver/

EXPOSE 2456-2458

ENTRYPOINT ["vhserverstart.sh"]