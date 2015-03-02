#!/bin/bash

function init {
	yum -y update
	echo "System Updated"
	install_basics
	add_user
	change_ssh


	install_psql

}


function install_basics {
    yum -y install wget curl rsync git sudo vim make which mlocate man vixie-cron readline-devel
    yum -y install gcc gcc-c++ gettext-devel expat-devel curl-devel zlib-devel openssl-devel perl cpio 
    yum -y install pinfo
    echo "Installed Basics"
}

function add_user {
	echo "User name:"
	read username
	adduser $username
	passwd $username
	passwd
	usermod -aG wheel $username

	echo "%wheel        ALL=(ALL)       ALL" >> /etc/sudoers
    echo "created wheel group"
}

function change_ssh {
	echo "ClientAliveInterval 30\n" >> /etc/ssh/sshd_config
	echo "TCPKeepAlive yes \n" >> /etc/ssh/sshd_config
	echo "ClientAliveCountMax 99999\n" >> /etc/ssh/sshd_config
	echo "Port 4500" >> /etc/ssh/sshd_config
	service sshd restart
}

function install_psql {
	yum install postgresql-libs -y
	yum install postgresql-devel -y
}