#!/bin/bash
#@author Fred Brooker <git@gscloud.cz>

# push if mxdpeep is a local user
if [ "mxdpeep" == `whoami` ]; then
    git commit -am "data rebuild"
    git push origin master
fi
