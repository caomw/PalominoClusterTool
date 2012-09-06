#!/bin/bash

# uncomment this section to turn your local host into an Ubuntu software repository.
# this is unlikely to actually work, though, so it's not recommended
## echo " - Configuring Ubuntu software repository"
## 
## echo " - Installing Apache2 Locally"
## sudo apt-get install apache2 || echo " E Failed to install apache2 locally."
## 
## thecwd=`pwd`
## cd /var/www
## [ -d ubuntu ] || sudo mkdir -p ubuntu
## cd ubuntu
## [ -s binary ] || sudo ln -s /var/cache/apt/archives ./binary
## [ -f binary/Packages.gz ] || sudo dpkg-scanpackages binary /dev/null | sudo gzip -9c > binary/Packages.gz
## cd $thecwd
## echo " o This machine is now an Ubuntu repository. If you'd rather use other sources,"
## echo "   edit BaseSaneSystem/templates/etc:apt:sources.list and add your sources there."
## echo ""

# check input is a clusterName
clusterName=$1
if [ "xxx$clusterName" == "xxx" ] ; then
	echo " - Usage: $0 <clusterName>"
	clusterName='PalominoTest'
	echo " - Using a default cluster name of $clusterName"
fi
ansibleHosts="/etc/ansible/$clusterName"


# setup the Ansible inventory
echo " - Configuring Ansible Inventory"
layoutFile='PalominoClusterToolLayout.ini'
if [ ! -e $layoutFile ] ; then
	echo ""
	echo "ERROR: Symlink a PalominoClusterToolTemplate file to $layoutFile, edit it, re-run this script."
	exit 255
fi
if [ ! -e $ansibleHosts ] ; then
	sudo cp $layoutFile $ansibleHosts || echo " E Failed to create $ansibleHosts."
else
	echo " - Not overwriting $ansibleHosts - if you need to make changes, remove the file first."
fi


# generate SSH keypair for MHA to use
if [ ! -e /etc/mha/id_dsa ] ; then
	echo " - Generating an SSH keypair - do not type a passphrase, just press ENTER twice if prompted"

	sudo mkdir -p /etc/mha \
	&& sudo chown -R $USER: /etc/mha \
	&& cd /etc/mha \
	&& ssh-keygen -t dsa -f id_dsa >/dev/null
fi


echo "Done."
echo ""
echo ' o You may also want to edit MySQLMasterSlaves/variables-[masters|slaves].yml'
echo '   to match your chosen hardware config.'
