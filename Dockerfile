# Jenkins.

FROM ubuntu:14.04
MAINTAINER Thomas Quintana <thomas@bettervoice.com>

# Enable the Ubuntu multiverse repository.
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/source.list
RUN echo "deb-src http://us.archive.ubuntu.com/ubuntu/ trusty multiverse">> /etc/apt/source.list
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/source.list
RUN echo "deb-src http://us.archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/source.list

# Install Dependencies.
RUN apt-get update && apt-get install -y autoconf automake bison build-essential gawk git-core groff groff-base erlang-dev libasound2-dev libdb-dev libexpat1-dev libcurl4-openssl-dev libgdbm-dev libgnutls-dev libjpeg-dev libncurses5 libncurses5-dev libperl-dev libogg-dev libsnmp-dev libssl-dev libtiff4-dev libtool libvorbis-dev libx11-dev libzrtpcpp-dev make portaudio19-dev python-dev snmp snmpd subversion unixodbc-dev uuid-dev zlib1g-dev libsqlite3-dev libpcre3-dev libspeex-dev libspeexdsp-dev libldns-dev libedit-dev libladspa-ocaml-dev libmemcached-dev libmp4v2-dev libmyodbc libpq-dev libvlc-dev libv8-dev liblua5.2-dev libyaml-dev libperl-dev libpython-dev odbc-postgresql wget unixodbc

# Install depot tools.
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git /usr/src/depot_tools
ENV PATH=/usr/src/depot_tools:"$PATH"

# Install libyuv
RUN gclient config https://chromium.googlesource.com/libyuv/libyuv 
RUN gclient sync
RUN mv libyuv /usr/src
WORKDIR /usr/src/libyuv
RUN tools/clang/scripts/update.sh
RUN GYP_DEFINES="target_arch=x64" ./gyp_libyuv -f ninja --depth=. libyuv_test.gyp 
RUN ninja -j7 -C out/Debug 
RUN ninja -j7 -C out/Release
RUN out/Release/libyuv_unittest --gtest_filter=*

# Use Gawk.
RUN update-alternatives --set awk /usr/bin/gawk

# Download FreeSWITCH.
RUN git clone https://stash.freeswitch.org/scm/fs/freeswitch.git /usr/src/freeswitch

# Bootstrap the build.
WORKDIR /usr/src/freeswitch
RUN git checkout -b v1.4.19
RUN ./bootstrap.sh

# Enable the desired modules.
ADD build/modules.conf /usr/src/freeswitch/modules.conf

# Build FreeSWITCH.
RUN ./configure --enable-core-pgsql-support --prefix=/usr/share/freeswitch
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
RUN adduser --gecos "FreeSWITCH Voice Platform" --no-create-home --disabled-login --disabled-password --system --ingroup daemon --home /usr/share/freeswitch freeswitch
RUN chown -R freeswitch:daemon /usr/share/freeswitch

# Create the log file.
RUN touch /usr/share/freeswitch/log/freeswitch.log
RUN chown freeswitch:daemon /usr/share/freeswitch/log/freeswitch.log

# Open the container up to the world.
EXPOSE 5060/tcp 5060/udp 5080/tcp 5080/udp
EXPOSE 5066/tcp 7443/tcp
EXPOSE 8021/tcp
EXPOSE 64535-65535/udp

# Start the container.
CMD service snmpd start && service freeswitch start && tail -f /usr/share/freeswitch/log/freeswitch.log
