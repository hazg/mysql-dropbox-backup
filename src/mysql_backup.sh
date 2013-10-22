#!/bin/bash
# Aleksander Aleksandrov hazg@mail.ru
# https://github.com/hazg/mysql-dropbox-backup

backup_path="backups"   # Dropbox path
user="root"             # Mysql user

mkdir -p /tmp/mysql_backup

for dbname in `echo show databases| mysql -u $user`; do
  if ( [[ "Database" != $dbname ]] && [[ "information_schema" != $dbname ]] );
  then
    mysqldump -u $user $dbname > "/tmp/mysql_backup/$dbname.sql"
  fi;
done;

day=$(date +'%u')
filename="mysql-$day"

tar -cf "/tmp/$filename.tar" /tmp/mysql_backup
gzip "/tmp/$filename.tar" -f
dropbox_uploader.sh -q upload "/tmp/$filename.tar.gz" "$backup_path/$filename.tar.gz" -q
rm "/tmp/$filename.tar.gz"
rm "/tmp/mysql_backup/" -R
