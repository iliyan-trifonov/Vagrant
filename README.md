Vagrant
=======

A Vagrantfile config file and some Puppet manifests + shell scripts and server configurations

This package will create an Ubuntu 12.10 64bit box in Virtualbox for web development with php5, mysql5, nginx,
and phpmyadmin.

Installs nginx and replaces any existing apache2 package with it, installs php5 with php5-fpm, php5-cli, php5-memcache,
php5-xdebug and php5-mcrypt, mysql server and client, phpmyadmin and as an addition htop and rsync.

Php, mysql, nginx and phpmyadmin are configured with some base configurations.
One test database and table are created by an imported sql script which you can modify for your needs.

You have to modify the nginx vhosts file too and also edit your hosts file if you are going to use it on the localhost.
Port 80 of the guest is forwarded to port 80 of the host machine so a http://localhost should load the default nginx server config.

You have to install Vagrant, Puppet and Virtualbox before using this package.

I am going to change this configuration from time to time while I am learning Vagrant, Puppet, bash, etc.
