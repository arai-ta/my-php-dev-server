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

    # tools
    yum install -y git telnet wget patch

    # anyenv + phpenv
    git clone https://github.com/riywo/anyenv /anyenv
    ln -sv /vagrant/asset/anyenv.profile.sh /etc/profile.d/
    ## phpenv
    . /etc/profile.d/anyenv.profile.sh
    anyenv install phpenv
    ## php-build patch
    ## see: http://tkuchiki.hatenablog.com/entry/2014/04/08/210022
    patch /anyenv/envs/phpenv/plugins/php-build/bin/php-build \
      < /vagrant/asset/php-build.patch
    ## pecl plugin + patch
    ## see: https://github.com/crocos/pecl-build/pull/4
    git clone https://github.com/crocos/pecl-build.git \
      /anyenv/envs/phpenv/plugins/pecl-build
    sed -i -e 's/Content-disposition/-i Content-Disposition/i' \
      /anyenv/envs/phpenv/plugins/pecl-build/bin/pecl-build
    ## set configure option
    rm /anyenv/envs/phpenv/plugins/php-build/share/php-build/default_configure_options
    ln -sv /vagrant/asset/php-configure-option.txt \
      /anyenv/envs/phpenv/plugins/php-build/share/php-build/default_configure_options
    chmod a+w -R /anyenv

    # php
    yum install -y gcc re2c libxml2 libxml2-devel libcurl libcurl-devel \
        libjpeg-devel openssl-devel libpng-devel libmcrypt libmcrypt-devel \
        readline-devel libtidy libtidy-devel libxslt libxslt-devel \
        libtool-ltdl libtool-ltdl-devel freetype freetype-devel \
        ImageMagick ImageMagick-devel httpd-devel
    . /etc/profile.d/anyenv.profile.sh
    phpenv install 5.3.29
    #phpenv install 5.4.45
    #phpenv install 5.5.38
    #phpenv install 5.6.28
    # pecl extension
    TEST_PHP_ARGS=-q phpenv pecl imagick -a
    chmod a+w -R /anyenv

    # install php.ini
    sh /vagrant/bin/install_php_ini.sh

    # httpd
    ln -sv /vagrant/asset/user.httpd.conf /etc/httpd/conf.d

    # mysql
    yum -y install mysql-server
    sed -i -e '6a character-set-server = utf8' \
           -e 's|^log-error.*$|log-error=/vagrant/log/mysqld.log|' \
           /etc/my.cnf

    # daemons
    chkconfig iptables  off
    chkconfig ip6tables off
    chkconfig httpd  on
    chkconfig mysqld on
    service httpd  start
    service mysqld start
  SCRIPT
end


