#! /bin/bash
numprocesses=$(ps aux | grep -c '[r]sync-2host.sh')
# 1 for this script + 1 already running = 2 == 1 external process is running
if [[ $numprocesses -gt 2 ]] ; then
  echo "process is running, quitting this one"
else
  echo "process is not running, starting an infinite loop"
  while [ 0 == 0 ]
  do
    sudo nice -n 19 ionice -c 3 rsync -vurt --inplace --delete /home/vagrant/projects/ /vagrant/projects/
    sleep 30
  done
fi
