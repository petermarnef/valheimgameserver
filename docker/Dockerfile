FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

# Install base dependencies

RUN set -ex; \
    apt-get update -y; \
    apt-get install -q -y locales; \
    rm -rf /var/lib/apt/lists/*; \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

RUN set -ex; \
    dpkg --add-architecture i386; \
    apt-get update -y; \
    apt-get install -y \
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
    tar \
    telnet \
    tmux \
    unzip \
    util-linux \
    wget \
    xz-utils \
    zlib1g \
    zlib1g:i386 \
    cron \
    gosu; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

# Install linuxgsm

RUN wget https://raw.githubusercontent.com/GameServerManagers/LinuxGSM/master/linuxgsm.sh

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

ENV TERM=xterm
ENV PATH=$PATH:/home/linuxgsm

# Install steamcmd

USER root

RUN echo steam steam/question select "I AGREE" | debconf-set-selections; \
    echo steam steam/license note '' | debconf-set-selections; \
    dpkg --add-architecture i386; \
    apt-get update -y; \
    apt-get install -q -y --no-install-recommends steamcmd; \
    ln -sf /usr/games/steamcmd /usr/bin/steamcmd; \
    apt-get autoremove -q -y; \
    rm -rf /var/lib/apt/lists/*;

# Install vhserver

COPY ./vhserverstart.sh .
RUN chmod +x vhserverstart.sh;

USER linuxgsm

RUN echo 109 | ./linuxgsm.sh install; \
    printf "Y\nY\nY\n" | vhserver install; \
    mkdir valheimgameserverbackup;

COPY ./vhserver.cfg ./lgsm/config-lgsm/vhserver/

# Container config

EXPOSE 2456-2458

ENTRYPOINT ["vhserverstart.sh"]
