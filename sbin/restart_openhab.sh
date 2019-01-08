#/bin/bash
set -e

rm -rf /var/lib/openhab2/etc/caldav/feiertage
rm -rf /var/lib/openhab2/etc/caldav/muell
/usr/sbin/service openhab2 restart
