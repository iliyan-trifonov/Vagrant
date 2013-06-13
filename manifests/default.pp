group { "puppet":
	ensure => present,
}

File {
  owner => 'root',
  group => 'root',
  mode  => '0644',
}

exec { "apt-get update":
	path => "/usr/bin";
}


class htop {
	package { "htop":
		ensure => present,
		require => Exec["apt-get update"]
	}
}

class remove_apache {
	service { "apache2":
		ensure => stopped,
		hasstatus => false
	}
	package { "apache2":
	    ensure => purged,
	}
	exec { 'autoremove':
	    command => '/usr/bin/apt-get autoremove --purge -y',
	    subscribe => Package['apache2'],
	    refreshonly => true,
	}	
}


class php {
	package { ["php5", "php5-fpm", "php5-cli", "php5-mysql", "php5-memcache", "php5-xdebug", "php5-mcrypt"]:
		ensure => present,
		require => Exec["apt-get update"]
	}	
	service { "php5-fpm":
		ensure => running,
		require => Package["php5-fpm"]
	}
	file { "/etc/php5/fpm/pool.d/www.conf":
		ensure => file,
		source => "/vagrant/myserverconfigs/php5-fpm/www.conf",
		require => Package["php5-fpm"],
		notify => Service["php5-fpm"]
	}
	file { "/etc/php5/fpm/php.ini":
		ensure => file,
		source => "/vagrant/myserverconfigs/php5-fpm/php.ini",
		require => Package["php5-fpm"],
		notify => Service["php5-fpm"]
	}
}

class nginx {
	package { "nginx":
		ensure => present,
		require => Exec["apt-get update"]
	}
	file { "/etc/nginx/sites-available/vagranttest-nginx.conf":
		ensure => file,
		source => "/vagrant/myserverconfigs/nginx/sites-available/vagranttest-nginx.conf",
		require => Package["nginx"],
		notify => Service["nginx"],
	}
	file { "/etc/nginx/sites-enabled/vagranttest-nginx.conf":
		ensure => link,
		target => "/etc/nginx/sites-available/vagranttest-nginx.conf",
		require => File["/etc/nginx/sites-available/vagranttest-nginx.conf"],
		notify => Service["nginx"]
	}	
	service { "nginx":
		ensure => "running",
		require => Package["nginx"]
	}
}

class mysql {
	package { ["mysql-server"]:
		ensure => present,
		require => Exec["apt-get update"]
	}
	service { "mysql":
		ensure => running,
		require => Package["mysql-server"]
	}
	file { "/etc/mysql/conf.d/myinnodbsettings.conf":
		ensure => file,
		path => "/etc/mysql/conf.d/myinnodbsettings.conf",
		source => "/vagrant/myserverconfigs/mysql/myinnodbsettings.conf",
		require => Package["mysql-server"],
		notify => Service["mysql"]
	}
	exec { "set-mysql-password":
		unless => 'mysqladmin -uroot -proot status',
		command => 'mysqladmin -uroot password root',
		path => ['/bin', '/usr/bin'],
		require => Service['mysql']
	}
	exec { "create-sql-structure-data":
		command => "mysql -u root -proot < /vagrant/myserverconfigs/mysql/db_struct.sql && touch /home/vagrant/sqlexecuted",
		path => ["/bin", "/usr/bin"],
		require => Exec["set-mysql-password"],
		onlyif => "test ! -e /home/vagrant/sqlexecuted"
	}	
}

class phpmyadmin {
	package { "phpmyadmin":
		ensure => present,
		require => [Package["php5"], Package["mysql-server"]]
	}
	file { "/usr/share/phpmyadmin/config.inc.php":
		ensure => file,
		source => "/vagrant/myserverconfigs/phpmyadmin/config.inc.php",
		require => Package["phpmyadmin"]
	}	
}

class rsync {
	package { "rsync":
		ensure => present
	}
	exec { "rsync-project-dirs":
		command => "rsync -vrt --inplace --delete --chmod=o+rw --owner=vagrant /vagrant/projects/ /home/vagrant/projects",
		path => ["/bin", "/usr/bin"],
		require => Package["rsync"]
	}
	$command = "/vagrant/myserverconfigs/shellscripts/rsync-2host.sh &"
	exec { "rsync-project-dirs-2host":
		command => $command,
		path => ["/bin", "/usr/bin"],
		require => [Package["rsync"], Exec["rsync-project-dirs"]],
		user => 'vagrant'
	}	
}

include remove_apache
include htop
include php
include nginx
include mysql
include phpmyadmin
include rsync