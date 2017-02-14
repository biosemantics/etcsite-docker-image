#!/bin/bash
service mysql start
mysqladmin -u root password my_secret_password
mysql -uroot -pmy_secret_password -e "create database etcsite"
mysql -uroot -pmy_secret_password -e "create database etcsite_alignment"
mysql -uroot -pmy_secret_password -e "create database etcsite_charaparser"
mysql -uroot -pmy_secret_password -e "create database etcsite_oto"
mysql -uroot -pmy_secret_password etcsite < /root/git/etc-site/setupDB.sql
mysql -uroot -pmy_secret_password etcsite_alignment < /root/git/euler/alignment/setupDB.sql
mysql -uroot -pmy_secret_password etcsite_charaparser < /root/git/charaparser/setupDB.sql
mysql -uroot -pmy_secret_password etcsite_oto < /root/git/oto2/oto/setupDB.sql
mysql -uroot -pmy_secret_password -e "create user 'user'@'localhost' identified by 'password';"
mysql -uroot -pmy_secret_password -e "grant all privileges on etcsite.* to 'user'@'localhost';"
mysql -uroot -pmy_secret_password -e "grant all privileges on etcsite_alignment.* to 'user'@'localhost';"
mysql -uroot -pmy_secret_password -e "grant all privileges on etcsite_charaparser.* to 'user'@'localhost';"
mysql -uroot -pmy_secret_password -e "grant all privileges on etcsite_oto.* to 'user'@'localhost';"
service mysql stop
