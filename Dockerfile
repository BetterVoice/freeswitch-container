# Jenkins.

FROM ubuntu:14.04
MAINTAINER Thomas Quintana <thomas@bettervoice.com>

# Enable the Ubuntu multiverse repository.
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/source.list
RUN echo "deb-src http://us.archive.ubuntu.com/ubuntu/ trusty multiverse">> /etc/apt/source.list
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/source.list
RUN echo "deb-src http://us.archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/source.list

# Install Dependencies.
RUN apt-get update && apt-get install -y autoconf automake bison build-essential gawk git-core groff groff-base erlang-dev libasound2-dev libdb-dev libexpat1-dev libcurl4-openssl-dev libgdbm-dev libgnutls-dev libjpeg-dev libmp3lame-dev libncurses5 libncurses5-dev libperl-dev libogg-dev libsnmp-dev libssl-dev libtiff4-dev libtool libvorbis-dev libx11-dev libzrtpcpp-dev make portaudio19-dev python-dev snmp snmpd subversion unixodbc-dev uuid-dev zlib1g-dev libsqlite3-dev libpcre3-dev libspeex-dev libspeexdsp-dev libldns-dev libedit-dev libladspa-ocaml-dev libmemcached-dev libmp4v2-dev libmyodbc libpq-dev libvlc-dev libv8-dev liblua5.2-dev libyaml-dev libpython-dev odbc-postgresql unixodbc wget yasm

# Use Gawk.
RUN update-alternatives --set awk /usr/bin/gawk

# Update the ldconfig configuration file.
RUN touch /etc/ld.so.conf.d/x86_64-linux-freeswitch.conf
RUN echo "/usr/local/lib" >> /etc/ld.so.conf.d/x86_64-linux-freeswitch.conf

# Install libyuv-dev
WORKDIR /usr/src
RUN wget http://files.freeswitch.org/downloads/libs/libyuv-0.0.1280.tar.gz
RUN tar -xzvf libyuv-0.0.1280.tar.gz
WORKDIR libyuv-0.0.1280
RUN make && make install
RUN ldconfig

# Install libvpx-dev
WORKDIR /usr/src
RUN wget http://files.freeswitch.org/downloads/libs/libvpx-1.4.0.tar.gz
RUN tar -xzvf libvpx-1.4.0.tar.gz
WORKDIR libvpx-1.4.0
RUN ./configure --enable-shared --prefix=/usr/local
RUN make && make install
RUN ldconfig

# Install libbroadvoice-dev
WORKDIR /usr/src
RUN wget http://files.freeswitch.org/downloads/libs/broadvoice-0.1.0.tar.gz
RUN tar -xzvf broadvoice-0.1.0.tar.gz
WORKDIR broadvoice-0.1.0
RUN ./autogen.sh
RUN ./configure --enable-shared --prefix=/usr/local
RUN make && make install
RUN ldconfig

# Install libcodec2-dev
WORKDIR /usr/src
RUN wget http://files.freeswitch.org/downloads/libs/libcodec2-2.59.tar.gz
RUN tar -xzvf libcodec2-2.59.tar.gz
WORKDIR libcodec2-2.59
RUN ./bootstrap.sh
RUN ./configure --enable-shared --prefix=/usr/local
RUN make && make install
RUN ldconfig

# Install libflite-dev
WORKDIR /usr/src
RUN wget http://files.freeswitch.org/downloads/libs/flite-2.0.0.tar.gz
RUN tar -xzvf flite-2.0.0.tar.gz
WORKDIR flite-2.0.0
RUN ./configure --enable-shared --prefix=/usr/local
RUN make && make install
RUN ldconfig

# Install libilbc-dev
WORKDIR /usr/src
RUN wget http://files.freeswitch.org/downloads/libs/ilbc-0.0.1.tar.gz
RUN tar -xzvf ilbc-0.0.1.tar.gz
WORKDIR ilbc-0.0.1
RUN ./bootstrap.sh
RUN ./configure --enable-shared --prefix=/usr/local
RUN make && make install
RUN ldconfig

# Install libmongoc-dev
WORKDIR /usr/src
RUN wget http://files.freeswitch.org/downloads/libs/mongo-c-driver-1.1.0.tar.gz
RUN tar -xzvf mongo-c-driver-1.1.0.tar.gz
WORKDIR mongo-c-driver-1.1.0
RUN ./configure --enable-shared --prefix=/usr/local
RUN make && make install
RUN ldconfig

# Install libopus-dev
WORKDIR /usr/src
RUN wget http://files.freeswitch.org/downloads/libs/opus-1.1.tar.gz
RUN tar -xzvf opus-1.1.tar.gz
WORKDIR opus-1.1
RUN ./autogen.sh
RUN ./configure --enable-shared --prefix=/usr/local
RUN make && make install
RUN ldconfig

# Install libg722-dev
WORKDIR /usr/src
RUN wget http://files.freeswitch.org/downloads/libs/g722_1-0.2.0.tar.gz
RUN tar -xzvf g722_1-0.2.0.tar.gz
WORKDIR g722_1-0.2.0
RUN ./autogen.sh
RUN ./configure --enable-shared --prefix=/usr/local
RUN make && make install
RUN ldconfig

# Install libshout3-dev
WORKDIR /usr/src
RUN wget http://downloads.xiph.org/releases/libshout/libshout-2.3.1.tar.gz
RUN tar -xzvf libshout-2.3.1.tar.gz
WORKDIR libshout-2.3.1
RUN ./configure --enable-shared --prefix=/usr/local
RUN make && make install
RUN ldconfig

# Install libmpg123-dev
WORKDIR /usr/src
RUN svn checkout svn://scm.orgis.org/mpg123/tags/1.22.2 mpg123-1.22.2
WORKDIR mpg123-1.22.2
RUN autoreconf -iv
RUN ./configure --enable-shared --prefix=/usr/local
RUN make && make install
RUN ldconfig

# Install libsilk-dev
WORKDIR /usr/src
RUN wget http://files.freeswitch.org/downloads/libs/libsilk-1.0.8.tar.gz
RUN tar -xzvf libsilk-1.0.8.tar.gz
WORKDIR libsilk-1.0.8
RUN ./bootstrap.sh
RUN ./configure --enable-shared --prefix=/usr/local
RUN make && make install
RUN ldconfig

# Install libsndfile-dev
WORKDIR /usr/src
RUN wget http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.25.tar.gz
RUN tar -xzvf libsndfile-1.0.25.tar.gz
WORKDIR libsndfile-1.0.25
RUN ./configure --enable-shared --prefix=/usr/local
RUN make && make install
RUN ldconfig

# Install libsoundtouch-dev
WORKDIR /usr/src
RUN wget http://www.surina.net/soundtouch/soundtouch-1.9.0.tar.gz
RUN tar -xzvf soundtouch-1.9.0.tar.gz
WORKDIR soundtouch
RUN ./bootstrap.sh
RUN ./configure --enable-shared --prefix=/usr/local
RUN make && make install
RUN ldconfig

# Download FreeSWITCH.
WORKDIR /usr/src
ENV GIT_SSL_NO_VERIFY=1
RUN git clone https://freeswitch.org/stash/scm/fs/freeswitch.git

# Bootstrap the build.
WORKDIR freeswitch
RUN git checkout -b v1.4.19
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
# ADD sysv/init /etc/init.d/freeswitch
# RUN chmod +x /etc/init.d/freeswitch
# RUN update-rc.d -f freeswitch defaults
# ADD sysv/default /etc/default/freeswitch

# Add the freeswitch user.
# RUN adduser --gecos "FreeSWITCH Voice Platform" --no-create-home --disabled-login --disabled-password --system --ingroup daemon --home /usr/local/freeswitch freeswitch
# RUN chown -R freeswitch:daemon /usr/local/freeswitch

# Create the log file.
#RUN touch /usr/local/freeswitch/log/freeswitch.log
#RUN chown freeswitch:daemon /usr/local/freeswitch/log/freeswitch.log

# Open the container up to the world.
EXPOSE 5060/tcp 5060/udp 5080/tcp 5080/udp
EXPOSE 5066/tcp 7443/tcp
EXPOSE 8021/tcp
EXPOSE 64535-65535/udp

# Start the container.
# CMD service snmpd start && service freeswitch start && tail -f /usr/local/freeswitch/log/freeswitch.log
