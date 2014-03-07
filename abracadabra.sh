#!/bin/sh -e

. wand.config
echo "ORC_BRANCH = $ORC_BRANCH"
echo "PUPPET_ENVIRONMENT = $PUPPET_ENVIRONMENT"
echo "SSRCLUSTER_BRANCH = $SSRCLUSTER_BRANCH"
echo "LEAF_BRANCH = $LEAF_BRANCH"

wand_dir=`pwd`

if [ ! -d "api" ]; then
    git clone git@github.com:Lulo/api.git
fi
cd $wand_dir/api
if [ $ORC_BRANCH != LOCAL ]; then
    git fetch
    git checkout $ORC_BRANCH
    git pull
	source ./install_orc.sh
	if vagrant status | grep ^orc | grep running; then
	    vagrant provision orc
    else
        vagrant up orc --provision
	fi
	if vagrant status | grep ^lb | grep running; then
        vagrant provision lb
    else
        vagrant up lb --provision
    fi
fi

cd $wand_dir
if [ ! -d "ssrcluster" ]; then
    git clone git@github.com:Lulo/ssrcluster.git
fi
cd $wand_dir/ssrcluster
if [ $SSRCLUSTER_BRANCH != LOCAL ]; then
    git fetch
    git checkout $SSRCLUSTER_BRANCH
    git pull
    if vagrant status | grep ^ssrcluster | grep running; then
        vagrant provision ssrcluster
    else
        vagrant up ssrcluster --provision
    fi
    if vagrant status | grep ^lb | grep running; then
        vagrant provision lb
    else
        vagrant up lb --provision
    fi
fi

cd $wand_dir
if [ ! -d "leaf-client" ]; then
    git clone git@github.com:Lulo/leaf-client.git
fi
cd $wand_dir/leaf-client
if [ $LEAF_BRANCH != LOCAL ]; then
    git fetch
    git checkout $LEAF_BRANCH
    git pull
    if vagrant status | grep ^proxy | grep running; then
        vagrant provision proxy
    else
        vagrant up proxy --provision
    fi
fi