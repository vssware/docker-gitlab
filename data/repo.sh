#!/bin/bash

cat > /etc/yum.repos.d/gitlab-ce.repo << EOF
[gitlab-ce]
name=gitlab-ce
baseurl=https://packages.gitlab.com/gitlab/gitlab-ce/el/8/\$basearch
repo_gpgcheck=0
gpgcheck=0
enabled=0
gpgkey=https://packages.gitlab.com/gitlab/gitlab-ce/gpgkey
       https://packages.gitlab.com/gitlab/gitlab-ce/gpgkey/gitlab-gitlab-ce-3D645A26AB9FBD22.pub.gpg
metadata_expire=300
EOF