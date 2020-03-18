#!/bin/bash

gitDataDir="/var/opt/gitlab/data"
externalUrl=${EXTERNAL_URL:-}

smtpServer=${SMTP_SERVER:-}
smtpPort=${SMTP_PORT:-25}
smtpUser=${SMTP_USER:-}
smtpPassword=${SMTP_PASSWORD:-}
smtpDomain=${SMTP_DOMAIN:-}

redisEnable=${REDIS_ENABLE:-true}
redisServer=${REDIS_SERVER:-redis}
redisPort=${REDIS_PORT:-6379}
redisPassword=${REDIS_PASSWORD:-redisPwd}
redisDatabase=${REDIS_DATABASE:-0}

postgresqlEnable=${POSTGRESQL_ENABLE:-true}
postgresqlServer=${POSTGRESQL_SERVER:-postgresql}
postgresqlPort=${POSTGRESQL_PORT:-5432}
postgresqlUser=${POSTGRESQL_USER:-postgresqlUser}
postgresqlPassword=${POSTGRESQL_PASSWORD:-postgresqlPwd}


rm -f /etc/gitlab/gitlab.rb
cat > /etc/gitlab/gitlab.rb << EOF
git_data_dirs({
  "default" => {
    "path" => '$gitDataDir'
  }
})
gitlab_rails['time_zone'] = 'Asia/Shanghai'

external_url '$externalUrl'
nginx['listen_port'] = 80
nginx['listen_https'] = false

gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = '$smtpServer'
gitlab_rails['smtp_port'] = $smtpPort
gitlab_rails['smtp_user_name'] = '$smtpUser'
gitlab_rails['smtp_password'] = '$smtpPassword'
gitlab_rails['smtp_domain'] = '$smtpDomain'
gitlab_rails['smtp_authentication'] = :login
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['gitlab_email_from'] = "$smtpUser"
user["git_user_email"] = "$smtpUser"
EOF

if [ $redisEnable = false ]; then
    echo "" >> /etc/gitlab/gitlab.rb
    echo "redis['enable'] = $redisEnable" >> /etc/gitlab/gitlab.rb
    echo "gitlab_rails['redis_host'] = '$redisServer'" >> /etc/gitlab/gitlab.rb
    echo "gitlab_rails['redis_port'] = $redisPort" >> /etc/gitlab/gitlab.rb
    echo "redis['password'] = '$redisPassword'" >> /etc/gitlab/gitlab.rb
    echo "gitlab_rails['redis_password'] = '$redisPassword'" >> /etc/gitlab/gitlab.rb
    echo "gitlab_rails['redis_database'] = $redisDatabase" >> /etc/gitlab/gitlab.rb
else
    echo "" >> /etc/gitlab/gitlab.rb
    echo "redis['enable'] = $redisEnable" >> /etc/gitlab/gitlab.rb
fi

if [ $postgresqlEnable = false ]; then
    echo "" >> /etc/gitlab/gitlab.rb
    echo "postgresql['enable'] = $postgresqlEnable" >> /etc/gitlab/gitlab.rb
    echo "gitlab_rails['db_adapter'] = 'postgresql'" >> /etc/gitlab/gitlab.rb
    echo "gitlab_rails['db_encoding'] = 'utf8'" >> /etc/gitlab/gitlab.rb
    echo "gitlab_rails['db_host'] = '$postgresqlServer'" >> /etc/gitlab/gitlab.rb
    echo "gitlab_rails['db_port'] = $postgresqlPort" >> /etc/gitlab/gitlab.rb
    echo "gitlab_rails['db_username'] = '$postgresqlUser'" >> /etc/gitlab/gitlab.rb
    echo "gitlab_rails['db_password'] = '$postgresqlPassword'" >> /etc/gitlab/gitlab.rb
else
    echo "" >> /etc/gitlab/gitlab.rb
    echo "postgresql['enable'] = $postgresqlEnable" >> /etc/gitlab/gitlab.rb
    echo "gitlab_rails['db_adapter'] = 'postgresql'" >> /etc/gitlab/gitlab.rb
    echo "gitlab_rails['db_encoding'] = 'utf8'" >> /etc/gitlab/gitlab.rb
fi
