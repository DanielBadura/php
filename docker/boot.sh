#!/bin/sh

until /sbin/setuser www-data php /srv/share/bin/console -n doctrine:database:create --if-not-exists; do
  >&2 echo "MySQL is unavailable - sleeping"
  sleep 3
done

/sbin/setuser www-data php /srv/share/bin/console -n doctrine:migration:migrate
/sbin/setuser www-data php /srv/share/bin/console -n h:f:l
