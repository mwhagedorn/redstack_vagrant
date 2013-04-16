#!/usr/bin/env bash

apt-get update
apt-get install git-core -y
su -c "git clone https://github.com/openstack-dev/devstack.git" vagrant
su -c "git clone https://github.com/stackforge/reddwarf-integration.git" vagrant
cp /home/vagrant/reddwarf-integration/scripts/local.sh /home/vagrant/devstack/
printf 'ADMIN_PASSWORD=password\nMYSQL_PASSWORD=password\nRABBIT_PASSWORD=password\nSERVICE_PASSWORD=password\nSERVICE_TOKEN=tokentoken\nFLAT_INTERFACE=br101' > /home/vagrant/devstack/localrc
su -c "/home/vagrant/devstack/stack.sh" vagrant
su -c "cp /vagrant/root.d /opt/stack/diskimage-builder/elements/ubuntu" vagrant
su -c "cd /home/vagrant/reddwarf-integration/scripts;/home/vagrant/reddwarf-integration/scripts/redstack post-devstack mysql" vagrant
