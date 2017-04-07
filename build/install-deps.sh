#/bin/bash
# Update the ldconfig configuration file.
touch /etc/ld.so.conf.d/x86_64-linux-freeswitch.conf
echo "/usr/local/lib" >> /etc/ld.so.conf.d/x86_64-linux-freeswitch.conf
MAKE="make -j`nproc`"

# Install libyuv-dev
cd /usr/src
wget http://files.freeswitch.org/downloads/libs/libyuv-0.0.1280.tar.gz
tar -xzvf libyuv-0.0.1280.tar.gz
cd libyuv-0.0.1280
${MAKE} && make install

# Install libvpx-dev
cd /usr/src
wget http://files.freeswitch.org/downloads/libs/libvpx-1.4.0.tar.gz
tar -xzvf libvpx-1.4.0.tar.gz
cd libvpx-1.4.0
./configure --enable-shared --prefix=/usr/local
${MAKE} && make install

# Install libbroadvoice-dev
cd /usr/src
wget http://files.freeswitch.org/downloads/libs/broadvoice-0.1.0.tar.gz
tar -xzvf broadvoice-0.1.0.tar.gz
cd broadvoice-0.1.0
./autogen.sh
./configure --enable-shared --prefix=/usr/local
${MAKE} && make install

# Install libpng
cd /usr/src
wget http://files.freeswitch.org/downloads/libs/libpng-1.6.10.tar.gz
tar -xzvf libpng-1.6.10.tar.gz
cd libpng-1.6.10
./configure --enable-shared --prefix=/usr/local
${MAKE} && make install

# Install libcodec2-dev
cd /usr/src
wget http://files.freeswitch.org/downloads/libs/libcodec2-2.59.tar.gz
tar -xzvf libcodec2-2.59.tar.gz
cd libcodec2-2.59
./bootstrap.sh
./configure --enable-shared --prefix=/usr/local
${MAKE} && make install

# Install libflite-dev
cd /usr/src
wget http://files.freeswitch.org/downloads/libs/flite-2.0.0.tar.gz
tar -xzvf flite-2.0.0.tar.gz
cd flite-2.0.0
./configure --enable-shared --prefix=/usr/local
${MAKE} && make install

# Install libilbc-dev
cd /usr/src
wget http://files.freeswitch.org/downloads/libs/ilbc-0.0.1.tar.gz
tar -xzvf ilbc-0.0.1.tar.gz
cd ilbc-0.0.1
./bootstrap.sh
./configure --enable-shared --prefix=/usr/local
${MAKE} && make install

# Install libmongoc-dev
cd /usr/src
wget http://files.freeswitch.org/downloads/libs/mongo-c-driver-1.1.0.tar.gz
tar -xzvf mongo-c-driver-1.1.0.tar.gz
cd mongo-c-driver-1.1.0
./configure --enable-shared --prefix=/usr/local
${MAKE} && make install

# Install libopus-dev
cd /usr/src
wget http://files.freeswitch.org/downloads/libs/opus-1.1.tar.gz
tar -xzvf opus-1.1.tar.gz
cd opus-1.1
./autogen.sh
./configure --enable-shared --prefix=/usr/local
${MAKE} && make install

# Install libg722-dev
cd /usr/src
wget http://files.freeswitch.org/downloads/libs/g722_1-0.2.0.tar.gz
tar -xzvf g722_1-0.2.0.tar.gz
cd g722_1-0.2.0
./autogen.sh
./configure --enable-shared --prefix=/usr/local
${MAKE} && make install

# Install libshout3-dev
cd /usr/src
wget http://downloads.xiph.org/releases/libshout/libshout-2.3.1.tar.gz
tar -xzvf libshout-2.3.1.tar.gz
cd libshout-2.3.1
./configure --enable-shared --prefix=/usr/local
${MAKE} && make install

# Install libmpg123-dev
cd /usr/src
svn checkout svn://scm.orgis.org/mpg123/tags/1.22.2 mpg123-1.22.2
cd mpg123-1.22.2
autoreconf -iv
./configure --enable-shared --prefix=/usr/local
${MAKE} && make install

# Install libsilk-dev
cd /usr/src
wget http://files.freeswitch.org/downloads/libs/libsilk-1.0.8.tar.gz
tar -xzvf libsilk-1.0.8.tar.gz
cd libsilk-1.0.8
./bootstrap.sh
./configure --enable-shared --prefix=/usr/local
${MAKE} && make install

# Install libsndfile-dev
cd /usr/src
wget http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.25.tar.gz
tar -xzvf libsndfile-1.0.25.tar.gz
cd libsndfile-1.0.25
./configure --enable-shared --prefix=/usr/local
${MAKE} && make install

# Install libsoundtouch-dev
cd /usr/src
wget http://www.surina.net/soundtouch/soundtouch-1.9.0.tar.gz
tar -xzvf soundtouch-1.9.0.tar.gz
cd soundtouch
./bootstrap
./configure --enable-shared --prefix=/usr/local
${MAKE} && make install

# Install libsmpp34
# This package will fail with make -j
cd /usr/src
git clone git://git.osmocom.org/libsmpp34
cd libsmpp34
autoreconf -i
./configure && make && make install

# Install libopenssl
#cd /usr/src
#git clone https://github.com/openssl/openssl.git -b OpenSSL_1_0_1t
#./config && make && make install
#sudo ln -sf /usr/local/ssl/bin/openssl `which openssl`

# Configure the dynamic linker run-time bindings
ldconfig
