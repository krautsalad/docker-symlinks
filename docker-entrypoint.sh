#!/bin/sh
set -e
mkdir -p /host /var/log/cron
ln -sf /proc/1/fd/1 /var/log/cron/cron.log
[ -n "$SCHEDULE" ] && sed -ri "s/^([^ ]+ [^ ]+ [^ ]+ [^ ]+ [^ ]+)/${SCHEDULE}/" /var/spool/cron/crontabs/root
[ -n "$TZ" ] && [ -f /usr/share/zoneinfo/"$TZ" ] && { cp /usr/share/zoneinfo/"$TZ" /etc/localtime; echo "$TZ" > /etc/timezone; }
exec "$@"
