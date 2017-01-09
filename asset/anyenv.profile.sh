# /etc/profile.d/anyenv.profile.sh

ANYENV_ROOT=/anyenv

if [ -r $ANYENV_ROOT -a -x $ANYENV_ROOT/bin/anyenv ] ;then
    PATH="/anyenv/bin:$PATH"
    export ANYENV_ROOT PATH
    eval "$(anyenv init -)"
fi

