# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # box
  config.vm.box = "bento/centos-6.7"

  # hostname
  config.vm.hostname = "my-php-dev-server.devel"

  # network
  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 1024
  end

  # OS
  config.vm.provision "OperatingSystem", type: "shell", inline: <<-SCRIPT
    # check repo connection
    curl -s 'http://mirrorlist.centos.org' || {
      echo "Could not connect to yum repository. Stop."
      exit 1
    } >&2

    # set timezone to JST
    rm -f /etc/localtime
    ln -s /usr/share/zoneinfo/Japan /etc/localtime
    {
      echo 'ZONE="Asia/Tokyo"'
      echo 'UTC=false'
    } > /etc/sysconfig/clock

    # yum
    echo 'include_only=.jp' >> /etc/yum/pluginconf.d/fastestmirror.conf
    yum install -y epel-release
    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
  SCRIPT

  # Middleware
  config.vm.provision "Middleware", type:"shell", inline: <<-SCRIPT
    # perm
    umask 0000

    # install system php
    yum install -y --enablerepo=remi,remi-php56 \
      php php-devel php-mbstring php-pdo php-gd php-xml php-pear php-mysql
    ln -sv /vagrant/asset/user.php.ini /etc/php.d/

  SCRIPT
end


