#!/bin/bash

# This script installs the latest version of xmrig for Debian/Ubuntu availabe at xmrig's github repo.
#
# Author: Pietro Sammarco - 25.04.2020 

workdir="/tmp"

curl -s https://github.com/xmrig/xmrig/releases/latest |cut -c 81-86 > $workdir/version.git

local="/opt/local/xmrig"

if [ ! -d $local ]; then
	mkdir -p $local/backup-bin       
fi       

gitversion=$(cat $workdir/version.git)
installed=$(cat $local/bin/version)

if [ $gitversion = $installed ]; then
	echo "No new release found."
else
	cd $workdir
curl -s https://github.com/xmrig/xmrig/releases/latest \
	|cut -d '"' -f 2  |xargs curl -s \
	| grep "xenial-x64.tar.gz"  | cut -d '"'  -f 2 |tail -2 |head -1 > url.txt
                  echo -n "https://github.com" |cat - url.txt > tmp && mv tmp url.txt 
		  cat url.txt |xargs wget
fi

if ls |grep -q xenial-x64.tar.gz; then
      mv $local/bin $local/backup-bin/bin-$(date "+%d.%m.%Y-%H.%M");
      tar -C $local -zxvf $workdir/*xenial-x64.tar.gz;
      mv $local/xmrig-* $local/bin;
      mv version.git $local/bin/version;
      rm url.txt *xenial-x64.tar.gz* ;
      echo "Latest release has been installed!"
else 
	exit 0
fi
