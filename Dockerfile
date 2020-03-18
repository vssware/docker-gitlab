FROM vssware/centos:8

LABEL author="Jimmy Shine <Jimmy.Shine@Gmail.com>"

ENV datadir /var/opt/gitlab
ENV PORT 80

# COPY data/gitlab-ce-12.8.6-ce.0.el8.x86_64.rpm /tmp/
COPY data/docker-entrypoint-gitlab.sh /usr/local/bin/docker-entrypoint-gitlab.sh
COPY data/update-permissions.sh /usr/local/bin/update-permissions.sh
COPY data/gitlab-conf.sh /usr/local/bin/gitlab-conf.sh

RUN dnf -y upgrade \
    && dnf -y install curl policycoreutils python3-policycoreutils policycoreutils-python-utils openssh-server \
    && curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | bash \
    && dnf -y install gitlab-ce \

    # 目前仓库中没有 gitlab-ce-12.8.6-ce.0.el8.x86_64,手动下载
#    && cd /tmp \
#    && rpm -i gitlab-ce-12.8.6-ce.0.el8.x86_64.rpm \

    && chmod +x /usr/local/bin/*.sh \
    && rm -rf /tmp/* \
    && echo 'kernel.sysrq = 16'  >>  /etc/sysctl.conf \
    && echo 'kernel.core_uses_pid = 1'  >>  /etc/sysctl.conf \
    && echo 'net.ipv4.conf.default.rp_filter = 1'  >>  /etc/sysctl.conf \
    && echo 'net.ipv4.conf.all.rp_filter = 1'  >>  /etc/sysctl.conf \
    && echo 'net.ipv4.conf.default.accept_source_route = 0'  >>  /etc/sysctl.conf \
    && echo 'net.ipv4.conf.all.accept_source_route = 0'  >>  /etc/sysctl.conf \
    && echo 'net.ipv4.conf.default.promote_secondaries = 1'  >>  /etc/sysctl.conf \
    && echo 'net.ipv4.conf.all.promote_secondaries = 1'  >>  /etc/sysctl.conf \
    && echo 'fs.protected_hardlinks = 1'  >>  /etc/sysctl.conf \
    && echo 'fs.protected_symlinks = 1'  >>  /etc/sysctl.conf \
    && dnf clean packages

VOLUME ["$datadir"]
VOLUME ["/var/log/gitlab"]

USER root
WORKDIR $datadir
ENTRYPOINT ["sh","-c"]
CMD ["/usr/local/bin/docker-entrypoint-gitlab.sh"]
EXPOSE $PORT
