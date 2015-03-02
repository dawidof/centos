#!/bin/bash

function init {
	yum -y update
	echo "System Updated"

}


function install_basics {
    yum -y install wget curl rsync git sudo vim make which mlocate man vixie-cron readline-devel
    yum -y install gcc gcc-c++ gettext-devel expat-devel curl-devel zlib-devel openssl-devel perl cpio 
    yum -y install pinfo
    echo "Installed Basics"
}