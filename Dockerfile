# Jenkins.

FROM ubuntu:14.04
MAINTAINER Thomas Quintana <thomas@bettervoice.com>

# Enable the Ubuntu multiverse repository.
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/source.list
RUN echo "deb-src http://us.archive.ubuntu.com/ubuntu/ trusty multiverse">> /etc/apt/source.list
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/source.list
RUN echo "deb-src http://us.archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/source.list

# Enable 32-bit repositories.
RUN sudo dpkg --add-architecture i386

# Install Dependencies.
RUN apt-get update && apt-get install -y autoconf automake bison build-essential fail2ban gawk git-core groff groff-base erlang-dev libasound2-dev libavformat-dev libdb-dev libexpat1-dev libcurl3 libcurl4-openssl-dev libgdbm-dev libgnutls-dev libjpeg-dev libmp3lame-dev libncurses5 libncurses5-dev libperl-dev libogg-dev libsnmp-dev libssl-dev libtiff4-dev libtool libvorbis-dev libx11-dev libzrtpcpp-dev make portaudio19-dev python-dev snmp snmpd subversion unixodbc-dev uuid-dev zlib1g-dev libsqlite3-dev libpcre3-dev libspeex-dev libspeexdsp-dev libldns-dev libedit-dev libladspa-ocaml-dev libmemcached-dev libmp4v2-dev libmyodbc libpq-dev libvlc-dev libv8-dev liblua5.2-dev libyaml-dev libpython-dev odbc-postgresql pulseaudio sendmail unixodbc wget xvfb yasm

# Use Gawk.
RUN update-alternatives --set awk /usr/bin/gawk

# Install source code dependencies.
ADD build/install-deps.sh /root/install-deps.sh
WORKDIR /root
RUN chmod +x install-deps.sh
RUN ./install-deps.sh
RUN rm install-deps.sh

# Configure Fail2ban
ADD conf/freeswitch.conf /etc/fail2ban/filter.d/freeswitch.conf
ADD conf/freeswitch-dos.conf /etc/fail2ban/filter.d/freeswitch-dos.conf
ADD conf/jail.local /etc/fail2ban/jail.local

# Download FreeSWITCH.
WORKDIR /usr/src
ENV GIT_SSL_NO_VERIFY=1
RUN git clone https://freeswitch.org/stash/scm/fs/freeswitch.git -b v1.6.5

# Bootstrap the build.
WORKDIR freeswitch
RUN ./bootstrap.sh

# Enable the desired modules.
ADD build/modules.conf /usr/src/freeswitch/modules.conf

# Build FreeSWITCH.
RUN ./configure --enable-core-pgsql-support
RUN make
RUN make install
RUN make uhd-sounds-install
RUN make uhd-moh-install
RUN make samples

# Post install configuration.
ADD sysv/init /etc/init.d/freeswitch
RUN chmod +x /etc/init.d/freeswitch
RUN update-rc.d -f freeswitch defaults
ADD sysv/default /etc/default/freeswitch

# Add the freeswitch user.
RUN adduser --gecos "FreeSWITCH Voice Platform" --no-create-home --disabled-login --disabled-password --system --ingroup daemon --home /usr/local/freeswitch freeswitch
RUN chown -R freeswitch:daemon /usr/local/freeswitch

# Create the log file.
RUN touch /usr/local/freeswitch/log/freeswitch.log
RUN chown freeswitch:daemon /usr/local/freeswitch/log/freeswitch.log

# Install Skype client dependencies.
RUN apt-get install -y fontconfig fontconfig-config gcc-4.7-base:i386 libasound2:i386 libasound2-plugins:i386 libasyncns0:i386 libattr1:i386 libaudio2:i386 libavahi-client3:i386 libavahi-common-data:i386 libavahi-common3:i386 libavcodec54:i386 libavutil52:i386 libc6:i386 libc6-i686:i386 libcap2:i386 libcomerr2:i386 libcups2:i386 libdbus-1-3:i386 libdirac-encoder0:i386 libexpat1:i386 libffi6:i386 libflac8:i386 libfontconfig1 libfontconfig1:i386 libfreetype6:i386 libgcc1:i386 libgcrypt11:i386 libglib2.0-0:i386 libgnutls26:i386 libgpg-error0:i386 libgsm1:i386 libgssapi-krb5-2:i386 libgstreamer-plugins-base0.10-0:i386 libgstreamer0.10-0:i386 libice6:i386 libjack-jackd2-0:i386 libjbig0:i386 libjpeg8:i386 libjson0:i386 libk5crypto3:i386 libkeyutils1:i386 libkrb5-3:i386 libkrb5support0:i386 liblcms1:i386 liblzma5:i386 libmng2:i386 libmp3lame0:i386 libogg0:i386 libopenjpeg2:i386 liborc-0.4-0:i386 libp11-kit0:i386 libpcre3:i386 libpng12-0:i386 libpulse0:i386 libqt4-dbus:i386 libqt4-network:i386 libqt4-xml libqt4-xml:i386 libqtcore4 libqtcore4:i386 libqtdbus4 libqtdbus4:i386 libqtgui4:i386 libqtwebkit4:i386 libsamplerate0:i386 libschroedinger-1.0-0:i386 libselinux1:i386 libsm6:i386 libsndfile1:i386 libspeex1:i386 libspeexdsp1:i386 libsqlite3-0:i386 libssl1.0.0:i386 libstdc++6:i386 libtasn1-6-dev:i386 libtheora0:i386 libuuid1:i386 libva1:i386 libvorbis0a:i386 libvorbisenc2:i386 libvpx1:i386 libwrap0:i386 libx11-6:i386 libx11-xcb1:i386 libx264-142:i386 libxau6:i386 libxcb1:i386 libxdmcp6:i386 libxext6:i386 libxi6:i386 libxml2:i386 libxrender1:i386 libxss1:i386 libxt6:i386 libxtst6:i386 libxv1:i386 libxvidcore4:i386 qdbus ttf-dejavu-core uuid-runtime zlib1g:i386

# Pulse audio configuration.
ADD conf/pulseaudio.conf /etc/init/pulseaudio.conf
ADD conf/system.pa /etc/pulse/system.pa
ADD conf/daemon.conf /etc/pulse/daemon.conf
ADD sysv/pulseaudio /etc/init.d/pulseaudio
RUN adduser root pulse-access

# Open the container up to the world.
EXPOSE 5060/tcp 5060/udp 5080/tcp 5080/udp
EXPOSE 5066/tcp 7443/tcp
EXPOSE 8021/tcp
EXPOSE 64535-65535/udp

# Start the container.
CMD service snmpd start && service freeswitch start && tail -f /usr/local/freeswitch/log/freeswitch.log
