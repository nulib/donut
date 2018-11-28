directory '/home/app/current'
threads 8, 32
workers `grep -c processor /proc/cpuinfo`
port ENV.fetch('PORT') { 3000 }
pidfile '/var/run/puma/puma.pid'
daemonize false
