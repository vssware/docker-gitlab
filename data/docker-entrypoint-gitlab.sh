#!/bin/bash
set -e

init=${INIT:-}
baseDir="/var/opt/gitlab"

if [ ! -e "$baseDir/conf" ]; then
	mkdir -p $baseDir/conf
fi
if [ ! -e "$baseDir/data" ]; then
	mkdir -p $baseDir/data
fi

if [ ! -e "$baseDir/conf/gitlab.rb" ] && [  -n "${init}" ]; then
	echo "gitlab conf not found, create gitlab.rb"
	/usr/local/bin/gitlab-conf.sh
	cp -ar /etc/gitlab/* $baseDir/conf/
fi

rm -rf /etc/gitlab
ln -s $baseDir/conf /etc/gitlab
/usr/local/bin/update-permissions.sh

/opt/gitlab/embedded/bin/runsvdir-start &
gitlab-ctl reconfigure
gitlab-ctl start
gitlab-ctl tail
