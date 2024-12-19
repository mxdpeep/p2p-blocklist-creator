#!/bin/bash
#@author Fred Brooker <git@gscloud.cz>

if [ "mxdpeep" == `whoami` ]; then
    git commit -am "data rebuild"
    git push origin master
fi
