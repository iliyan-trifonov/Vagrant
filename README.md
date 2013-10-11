Vagrant with PHP, MySQL and Nginx
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

Mysql configuration is using innodb with some base values for buffer pool, log files, etc. so you will probaly want to change them too.
Put any number of *.sql files in myserverconfigs/mysql and they will be executed when the box is created for the first time.

Instead of using the shared folders feature from the VM which I find very slow for a normal project structure
I've decided to use rsync 2 times: when the box is started, one rsync syncs everything from host projects dir
to the guest and after that one rsync constrantly syncs everything from the guest projects dir to the host
projects dir through the shared folder which is used only by this command.
I've used 30sec sleep before the sync from guest to host to run again so you may tweak it and make sure
not to stop/destroy the box immediately after you saved a file there.<br />
Do not put new files on the host projects dir while the box is running.
Stop the box, put a new dir with files and run again to resync the new files.
Then use a sftp connection to get to the synced files inside the box. Connect with your IDE or use a program that maps
a local drive through sftp.<br />
Edit the files there and they will be synced every 30sec to the original host projects folder.<br />
After you stop the box you can git commit/push for others to have the latest modifications from your project.

Use "vagrant provision" if you make changes on the configuration files and they will be put in the running box and servers reloaded automatically.

You have to install Vagrant and Virtualbox before using this package.

I am going to change this configuration from time to time while I am learning Vagrant, Puppet, bash, etc.


One way to start using it under Windows:

Remove all '' from the lines to run before executing them.

1. Open Command Propmt (cmd) or powershell: (Win+R) + cmd + Enter .
2. Go to an empty directory where you want to download it
3. Execute: 'git clone git://github.com/Ljancho/Vagrant.git .' - dot at the end will put everything in the current dir.
4. Execute 'vagrant up' .
5. Wait for a while until the box is downloaded, converted to a virtualbox and ran, then wait for Puppet to install and
configure everything for you.
It should finish with success and then you can add this line to your hosts file (like: C:\Windows\System32\Drivers\etc\hosts)
using Notepad with admin privileges: '127.0.0.1 vagranttest.local' .
Save and go to: 'http://vagranttest.local/' to see the test php running.
Congratulations! :)

From here:

Stop the vagrant box: 'vagrant halt'.<br />
Put some new projects/files in the projects dir on the host.<br />
Edit the nginx config, put new configs in sites-available and edit your hosts file.<br />
Execute 'vagrant up' to resync the files from the host to the virtual box.<br />
While the box is running use http://vagranttest.local/phpmyadmin/ to manage your databases,
with user and pass: 'root' by default.<br />
If you want to change the default configuration that is created, edit the manifest/s and recreate/provision the box.
