#!/bin/bash
clear

apt-get purge ldap-utils slapd 
rm -r /var/backups/*.ldapdb
apt-get update
apt-get install slapd ldap-utils
dpkg-reconfigure slapd

cat > temp.ldif << EOF
dn: dc=example, dc=com
changeType: modify
add: description
description: Example.Com, your trusted non-existent corporation
-
EOF
ldapmodify -x -D cn=admin,dc=example,dc=com -w admin -f temp.ldif

service slapd stop
slapadd -v -u -c -F /etc/ldap/slapd.d -l basics.ldif
slapadd -v       -F /etc/ldap/slapd.d -l basics.ldif
service slapd start

rm temp.ldif

