#!/bin/sh

set -u
set -e

USER_PHP_INI=/vagrant/asset/user.php.ini
PHPENV_ROOT=${PHPENV_ROOT:-/anyenv/envs/phpenv}

for dir in /etc/php.d `ls -d $PHPENV_ROOT/versions/*/etc/conf.d`
do
  if [ -e $dir/`basename $USER_PHP_INI` ]
  then
    continue
  fi

  ln -sv $USER_PHP_INI $dir
done

