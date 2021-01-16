#!/bin/bash

# This script installs the latest version of xmrig for Debian/Ubuntu availabe at xmrig's github repo.
#
# Author: Pietro Sammarco 
#
# 01.16.2020
# - Fixed version output length  
# - Added pkill at the end of the update process in order for the "cronjbob" to execute the new installed version 
# Note: cronjob in question: https://gist.github.com/psammarco/0400f07cb5a8f697a8ae4195bcccf64f

workdir="/tmp"

curl -s https://github.com/xmrig/xmrig/releases/latest |cut -c 81-85 > $workdir/version.git

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
	| grep "focal-x64.tar.gz"  | cut -d '"'  -f 2 |tail -2 |head -1 > url.txt
                  echo -n "https://github.com" |cat - url.txt > tmp && mv tmp url.txt 
		  cat url.txt |xargs wget
fi

if ls |grep -q focal-x64.tar.gz; then
      mv $local/bin $local/backup-bin/bin-$(date "+%m.%d.%Y-%H.%M");
      tar -C $local -zxvf $workdir/*focal-x64.tar.gz;
      mv $local/xmrig-* $local/bin;
      mv version.git $local/bin/version;
      rm url.txt *focal-x64.tar.gz* ;
      pkill -f xmrig 
      echo "Latest release has been installed!"
else 
	exit 0
fi
