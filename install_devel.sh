# use /opt/dev as working directory

# libssh
#RUN \
      cd /opt/dev && \
      git clone http://git.libssh.org/projects/libssh.git && cd libssh && \
      mkdir build && cd build && \
      cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr .. && \
      make -j2 && \
      make install && \
      ldconfig

# protobuf
#RUN \
      cd /opt/dev && \
      git clone https://github.com/google/protobuf.git && cd protobuf && \
      ./autogen.sh && \
      ./configure && \
      make && \
      make install && \
      ldconfig

# protobuf-c
#RUN \
      cd /opt/dev && \
      git clone https://github.com/protobuf-c/protobuf-c.git && cd protobuf-c && \
	  cd build-cmake && \
	  mkdir build && cd build && \
      cmake -DCMAKE_BUILD_TYPE:String="Release" .. -DBUILD_SHARED_LIBS=ON && \
      make -j9 && \
      make package && \
      make install && \
      ldconfig

# libyang
#RUN \
      cd /opt/dev && \
      git clone https://github.com/CESNET/libyang.git && \
      cd libyang && mkdir build && cd build && \
	  git checkout devel && \
      cmake -DCMAKE_BUILD_TYPE:String="Release" -DENABLE_BUILD_TESTS=OFF .. && \
      make -j2 && \
      make install && \
      ldconfig

# sysrepo
#RUN \
      cd /opt/dev && \
      git clone https://github.com/sysrepo/sysrepo.git && \
      cd sysrepo && \
	  git checkout devel && \
	  mkdir build && cd build && \
      cmake \
       -DCMAKE_BUILD_TYPE:String="Release" \
      -DENABLE_TESTS=OFF \
      -DREPOSITORY_LOC:PATH=/etc/sysrepo \
      -DGEN_LUA_VERSION=5.2 \
      -DGEN_PYTHON_BINDINGS=false \
      .. && \
      make -j2 && \
      make install && \
      ldconfig

# libnetconf2
#RUN \
      cd /opt/dev && \
      git clone https://github.com/CESNET/libnetconf2.git && \
      cd libnetconf2 && mkdir build && cd build && \
	  git checkout devel && \
      cmake -DCMAKE_BUILD_TYPE:String="Release" -DENABLE_BUILD_TESTS=OFF .. && \
      make -j2 && \
      make install && \
      ldconfig

# netopeer2
#RUN \
      cd /opt/dev && \
      git clone https://github.com/CESNET/Netopeer2.git && \
      cd Netopeer2/server && mkdir build && cd build && \
	  git checkout devel-server && \
      cmake -DCMAKE_BUILD_TYPE:String="Release" .. && \
      make -j2 && \
      make install && \
      cd ../../cli && mkdir build && cd build && \
	  git checkout devel-cli && \
      cmake -DCMAKE_BUILD_TYPE:String="Release" .. && \
      make -j2 && \
      make install && \
      ldconfig

