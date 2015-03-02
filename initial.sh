#!/bin/bash

#wget https://raw.githubusercontent.com/dawidof/centos/master/initial.sh
#source initial.sh
#init_root
function init_root {
	yum -y update
	echo "System Updated"
	install_basics
	add_user
	change_ssh

	make_swap
	
	install_psql

}

function init_user {
	install_ruby
}

function install_basics {
    yum -y install wget curl rsync git sudo vim make which mlocate man vixie-cron readline-devel bzip2 nano mc
    yum -y install gcc gcc-c++ gettext-devel expat-devel curl-devel zlib-devel openssl-devel perl cpio 
    yum -y install pinfo
    yum -y groupinstall 'Development Tools' >/dev/null
    echo "Installed Basics"
}

function add_user {
	echo "User name:"
	read username
	adduser $username
	passwd $username
	passwd
	usermod -aG wheel $username
	gpasswd -a dawidof wheel

	echo "gem: --no-ri --no-rdoc" >> /home/$username/.gemrc

	echo "%wheel        ALL=(ALL)       ALL" >> /etc/sudoers
    echo "created wheel group"

    echo "COPY FROM YOUR LOCAL MACHINE: cat ~/.ssh/id_rsa.pub"
    read idrsa
    mkdir /home/$username/.ssh
	chmod 700 /home/$username/.ssh
	touch /home/$username/.ssh/authorized_keys
	echo "$idrsa" >> /home/$username/.ssh/authorized_keys
	chmod 600 /home/$username/.ssh/authorized_keys
}

function change_ssh {
	echo "ClientAliveInterval 30" >> /etc/ssh/sshd_config
	echo "TCPKeepAlive yes" >> /etc/ssh/sshd_config
	echo "ClientAliveCountMax 99999" >> /etc/ssh/sshd_config
	echo "Port 4500" >> /etc/ssh/sshd_config
	echo "PermitRootLogin no" >> /etc/ssh/sshd_config
	echo "AllowUsers $username" >> /etc/ssh/sshd_config
	service sshd restart
	#$ip = ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'
	echo "-----  ssh $username@ip -p 4500"
}

function make_swap {
	dd if=/dev/zero of=/swap bs=1024 count=1048576
	mkswap /swap && chown root. /swap && chmod 0600 /swap && swapon /swap
	echo "/swap swap swap defaults 0 0" >> /etc/fstab
	echo "vm.swappiness = 0" >> /etc/sysctl.conf && sysctl -p

}

function install_psql {
	yum install postgresql-libs -y
	yum install postgresql-devel -y
}


function install_ruby {
	gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
	curl -L get.rvm.io | bash -s stable
	echo "\nsource ~/.profile" >> ~/.bash_profile
	rvm install 2.2.0
	rvm use 2.2.0

	gem install bundler
	gem install rake rails
	gem install pg
}
