#!/bin/bash
# Script to install Metasploit
#
# Originally created by Dr. Phil Polstra
# for the book
# Hacking and Penetration Testing With Low Power Devices
# list of packages needed to install
pkg_list="build-essential zlib1g zlib1g-dev libxml2 libxml2-dev\
libxslt-dev locate libreadline6-dev libcurl4-openssl-dev git-core\
libssl-dev libyaml-dev openssl autoconf libtool ncurses-dev bison\
curl wget postgresql postgresql-contrib libpq-dev libapr1\
libaprutil1 libsvn1 libpcap-dev"
install_dpkg () {
	# Is it already installed?
	if (dpkg --list | awk '{print $2}' | egrep "^${pkg}\
	(:armhf)?$" 2>/dev/null) ;
	then
		echo "${pkg} already installed"
	else
		# try to install
		echo -n "Trying to install ${pkg} ..."
		if (apt-get -y install ${pkg} 2>/dev/null) ; then
			echo "succeeded"
		else
			echo "failed"
		fi
	fi
}
# first install support packages
for pkg in $pkg_list
do
	install_dpkg
done

# Get the signing key for the RVM distribution:
curl -sSL https://rvm.io/mpapis.asc | gpg --import - | bash -s stable --autolibs=enabled --ruby=1.9.3
# Get RVM itself
curl -L https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
# Install it
rvm --install .ruby-version

# install gems
gem install bundler
bundle install
