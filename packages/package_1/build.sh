#!/bin/bash

set -e
package="package_1"


function deployDevelop {
    echo -e "   THE ACTUAL DEVELOP DEPLOY FOR PACKAGE 1"
}

function deployProduction {
    echo -e "   THE ACTUAL PRODUCTION DEPLOY FOR PACKAGE 1"
}


echo -e "-- deploy script for package $package"
echo -e "   selected branch $1"

 case $1 in
    develop )
        deployDevelop
        ;;
   master )
        deployProduction
        ;;
   *)
        echo -e "   no build steps expected for branch $1"
        exit 0
        ;;
esac