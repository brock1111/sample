FROM ubuntu:20.04

ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get -qq -y update && apt-get -qq -y upgrade && apt-get -qq install -y software-properties-common \
        && add-apt-repository ppa:rock-core/qt4 \
        && apt-get -qq install -y tzdata python3 python3-pip \
        unzip p7zip-full p7zip-rar aria2 wget curl \
        pv jq ffmpeg locales python3-lxml xz-utils neofetch \
        git g++ gcc autoconf automake \
        m4 libtool qt4-qmake make libqt4-dev libcurl4-openssl-dev \
        libcrypto++-dev libsqlite3-dev libc-ares-dev \
        libsodium-dev libnautilus-extension-dev \
        libssl-dev libfreeimage-dev swig nginx apache2-utils


WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app


RUN apt-get -qq update


RUN add-apt-repository universe
RUN apt-get -qq update
RUN add-apt-repository multiverse
RUN apt-get -qq update
RUN add-apt-repository restricted
RUN apt-get -qq update
RUN apt-get install -y apt-transport-https coreutils
RUN apt-get -qq install -y --no-install-recommends cdtool curl git gnupg2 unzip wget pv jq
RUN apt-get install -y mkvtoolnix
RUN apt-get update && apt-get install -y software-properties-common
   

RUN apt-get install -y coreutils aria2 jq pv gcc g++ mediainfo \
    neofetch python3-dev git bash build-essential nodejs npm ruby \
    locales python-lxml gettext-base xz-utils \
    p7zip-full p7zip-rar rar unrar zip unzip \
    megatools mediainfo && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN wget https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-amd64-static.tar.xz && \
    tar xvf ffmpeg*.xz && \
    cd ffmpeg-*-static && \
    mv "${PWD}/ffmpeg" "${PWD}/ffprobe" /usr/local/bin/

ENV LANG C.UTF-8

ENV TZ Asia/Kolkata
RUN curl https://rclone.org/install.sh | bash
COPY . .
COPY default.conf.template /etc/nginx/conf.d/default.conf.template
COPY nginx.conf /etc/nginx/nginx.conf
RUN npm install

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
RUN dpkg --add-architecture i386 && apt-get update && apt-get -y dist-upgrade
RUN apt-get -qq -y purge autoconf automake g++ gcc libtool m4 make software-properties-common swig \
    && rm -rf -- /var/lib/apt/lists/* /var/cache/apt/archives/* /etc/apt/sources.list.d/* /var/tmp/* /tmp/* \
    && apt-get -qq -y update && apt-get -qq -y upgrade && apt-get -qq -y autoremove && apt-get -qq -y autoclean

CMD /bin/bash -c "envsubst '\$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf" && nginx -g 'daemon on;' && cd /usr/src/app && mkdir Downloads && bash start.sh
