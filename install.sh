# Install script for r2va-node-lwaftr-xenial

#install scapy for health check

easy_install pip
pip install exabgp
pip install ipaddr
pip install scapy


# Adding netconf user ####################################################
adduser --group --system netconf
mkdir -p /home/netconf/.ssh
echo "netconf:netconf" | chpasswd && adduser netconf sudo
# Clearing and setting authorized ssh keys ##############################
echo '' > /home/netconf/.ssh/authorized_keys
ssh-keygen -A
ssh-keygen -t dsa -P '' -f /home/netconf/.ssh/id_dsa
cat /home/netconf/.ssh/id_dsa.pub >> /home/netconf/.ssh/authorized_keys

# Updating shell to bash ##################################################
sed -i s#/home/netconf:/bin/false#/home/netconf:/bin/bash# /etc/passwd
mkdir /opt/dev && sudo chown -R netconf /opt/dev
# set root password to root#################################################
echo "root:root" | chpasswd

# create /opt/dev directory
mkdir /opt/dev -p

echo "version 170404"

##### libyang #################### 1
cp -R /var/lib/vmfactory/files/libyang /opt/dev
cd /opt/dev/libyang
mkdir build && cd build
git fetch origin
git rebase origin/devel
git checkout b01625f9d373006e3f7877ff352ac87c04ec8612
cmake -DCMAKE_BUILD_TYPE:String="Release" -DENABLE_BUILD_TESTS=OFF ..
make -j2
make install
ldconfig


# sysrepo ######################################## 2
cp -R /var/lib/vmfactory/files/sysrepo /opt/dev
cd /opt/dev/sysrepo
git fetch origin
git rebase origin/devel
git checkout fada08288e64589ab73cc82a545967d38af61136
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE:String="Release" -DENABLE_TESTS=OFF -DREPOSITORY_LOC:PATH=/etc/sysrepo -DGEN_LUA_VERSION=5.1 -DGEN_PYTHON_BINDINGS=false -DENABLE_NACM=OFF ..
make -j2
make install
ldconfig


# libssh-dev #################################### 3
cp -R /var/lib/vmfactory/files/red.libssh.org/attachments/download/195/libssh-0.7.3.tar.xz /opt/dev
cd /opt/dev
tar xvfJ libssh-0.7.3.tar.xz
cd libssh-0.7.3
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ..
make -j2
make install


# libnetconf2

cp -R /var/lib/vmfactory/files/libnetconf2 /opt/dev
cd /opt/dev/libnetconf2
mkdir build && cd build
git fetch origin
git rebase origin/devel
git checkout 0af521379821e0387beaef144dd0a491acc1c400
cmake -DCMAKE_BUILD_TYPE:String="Release" -DENABLE_BUILD_TESTS=OFF ..
make -j2
make install
ldconfig

# keystore ###############################
cp -R /var/lib/vmfactory/files/Netopeer2 /opt/dev
cd /opt/dev/Netopeer2
git fetch origin
git rebase origin/devel-server
git checkout 87325fe97996ddc2019724d9f22fc50947eb63be
cd keystored
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE:String="Release" ..
make -j2
make install

# netopeer2 server
cd /opt/dev/Netopeer2/server
git fetch origin
git rebase origin/devel-server
git checkout 87325fe97996ddc2019724d9f22fc50947eb63be
sed -i '/\<address\>/ s/0.0.0.0/\:\:/' ./stock_config.xml
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE:String="Release" ..
make -j2
make install
ldconfig

####################################### compile Igalia AFTR
cd /var/lib/vmfactory/files/snabb
git checkout v3.1.8
make -j

cd /var/lib/vmfactory/files/snabb
git remote add sartura https://github.com/sartura/snabb.git
git fetch sartura
git checkout version_4

mkdir -p /opt/snabb
cp -r /var/lib/vmfactory/files/snabb/* /opt/snabb

###########################################

## copying/installing yang model from snabb to sysrepo
cp /opt/snabb/src/lib/yang/snabb-softwire-v1.yang /etc/sysrepo/yang/
sysrepoctl --init --search-dir=/etc/sysrepo/yang/ -m snabb-softwire-v1



#update-rc.d lwaftr defaults 80
#update-rc.d netconf defaults 10
#update-rc.d netconflua defaults 99
#update-rc.d exabgp defaults 99
#update-rc.d lwaftrcontrol defaults 80

echo "export PATH=\$PATH:/opt/scripts" >> /root/.bashrc

touch /var/log/exabgp.log
chown dtadmin:dtadmin /var/log/exabgp.log
touch /var/log/exabgphealthcheck.log
chown dtadmin:dtadmin /var/log/exabgphealthcheck.log

systemctl enable sysrepod.service
systemctl enable netopeer2-server.service
systemctl enable lwaftr.service
systemctl enable sysrepolua.service
systemctl enable exabgp.service
