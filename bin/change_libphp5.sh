#!/bin/sh

set -u
set -e

PHPENV_ROOT=${PHPENV_ROOT:-/anyenv/envs/phpenv}
LIBPHP_INSTALL=/etc/httpd/modules/libphp5.so
SYSTEM_BACKUP="${PHPENV_ROOT}/lib/libphp5.so.system"

if [ ! -e "$SYSTEM_BACKUP" -a -x "$LIBPHP_INSTALL" ]
then
  mkdir -p `dirname $SYSTEM_BACKUP`
  cp $LIBPHP_INSTALL $SYSTEM_BACKUP
fi

echo
if [ -L $LIBPHP_INSTALL ]
then
  echo "Now libphp5 is ---> `readlink $LIBPHP_INSTALL`"
else
  echo "Now libphp5 is regular file."
fi
echo

PS3="
Which libphp5 dou you want to use? (Ctrl-C to quit) :"

select lib in `find $SYSTEM_BACKUP $PHPENV_ROOT/versions -name "libphp5.so*" | sort`
do
  [ -z $lib ] && continue
  echo "$lib selected..."

  sudo rm $LIBPHP_INSTALL
  sudo ln -s $lib $LIBPHP_INSTALL

  ls -l $LIBPHP_INSTALL

  sudo service httpd restart
  break
done

