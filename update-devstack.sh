#!/bin/bash

function update() {
    branch=$1
    set -x
    git checkout $branch
    git pull origin $branch
    if $(git branch|grep ryudev > /dev/null); then
        git checkout ryudev
        git rebase $branch
    fi
}

set -e

REL=$1
VERSIONS="folsom|grizzly-gre|grizzly-vlan"
if [[ ! "$REL" =~ ($VERSIONS) ]]; then
    echo "unsupported version: $REL"
    echo "$0 $VERSIONS"
    exit 1
fi

TOP=$(readlink -f $(dirname "$0"))
cd $TOP

if [ ! -e $TOP/devstack ]; then
    tar zxf devstack.tar.gz
fi
if [ ! -e $TOP/devstack/$REL/devstack ]; then
    echo "could not found $TOP/devstack/$REL/devstack"
    exit 1
fi
cd $TOP/devstack/$REL/devstack
case $REL in
folsom)
    update "stable/folsom"
    ;;
grizzly-gre|grizzly-vlan)
    update "master"
    ;;
esac
