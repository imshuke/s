#!/bin/bash
apt update -y
apt install -y git unzip cron
git clone https://github.com/azpanel/azpanel.git /azpanel
cd /azpanel
chmod 755 -R *
chown www-data -R *
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
composer install
cat <<-EOF > /azpanel/.env
APP_DEBUG = true

[APP]
DEFAULT_TIMEZONE = Asia/Shanghai
APP_NAME = Azure

[DATABASE]
TYPE = mysql
HOSTNAME = $HOSTNAME
DATABASE = $DATABASE
USERNAME = $USERNAME
PASSWORD = $PASSWORD
HOSTPORT = $HOSTPORT
CHARSET = utf8
DEBUG = true

[THEME]
CARD_WIDTH = 10
CARD_RIGHT_OFFSET = 1

[LANG]
default_lang = zh-cn
EOF

docker-php-ext-install pdo pdo_mysql
echo '0 0 * * * /usr/local/bin/php /azpanel/think tools --action statisticsTraffic > /tmp/1
0 * * * * /usr/local/bin/php /azpanel/think autoRefreshAccount > /tmp/2
0 * * * * /usr/local/bin/php /azpanel/think closeTimeoutTask > /tmp/3
0 * * * * /usr/local/bin/php /azpanel/think trafficControlStop > /tmp/4
*/5 * * * * /usr/local/bin/php /azpanel/think trafficControlStart > /tmp/5' > /var/spool/cron/crontabs/root
chown -R root:crontab /var/spool/cron/crontabs/root && chmod 600 /var/spool/cron/crontabs/root && touch /var/log/cron.log
service cron restart
php-fpm
