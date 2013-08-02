#!/bin/bash
killall rsync-2host.sh
rsync -vrt --inplace --delete --chmod=o+rw --owner=vagrant /vagrant/projects/ /home/vagrant/projects