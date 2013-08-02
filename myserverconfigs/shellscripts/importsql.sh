#! /bin/bash
SQLEXECUTED_FLAG_FILE="/home/vagrant/tmp/sqlexecuted"
if [[ ! -e $SQLEXECUTED_FLAG_FILE ]]; then
	find /vagrant/myserverconfigs/mysql/ -name '*.sql' | awk '{ print "source",$0 }' | mysql --batch -u root -proot
	touch $SQLEXECUTED_FLAG_FILE
else
	echo Sql already imported. Please delete the $SQLEXECUTED_FLAG_FILE file/clean the databases to import again.
fi
