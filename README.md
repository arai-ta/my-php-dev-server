my-php-dev-server
=================

This is my php development server definition.


Feature
-----------------

* valiable php version
* modifiable configure option
* works as apache module


Usage
-----------------

install:

    $ git clone https://github.com/arai-ta/my-php-dev-server
    $ cd my-php-dev-server
    $ vagrant up

add php version:

    $ vagrant ssh
    [vagrant@my-php-dev-server ~]$ phpenv install 5.5.38
    [vagrant@my-php-dev-server ~]$ sh /vagrant/bin/install_php_ini.sh
    [vagrant@my-php-dev-server ~]$ sh /vagrant/bin/change_libphp5.sh


Requirement
-----------------

* [VirtualBox](https://www.virtualbox.org)
* [Vagrant](https://www.vagrantup.com)


Depends
-----------------

* [Remi's RPM repository](http://rpms.famillecollet.com)
* [Bento](https://atlas.hashicorp.com/bento)
* [anyenv](https://github.com/riywo/anyenv)
* [phpenv](https://github.com/madumlao/phpenv)
* [pecl-build](https://github.com/crocos/pecl-build)

