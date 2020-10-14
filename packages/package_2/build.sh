#!/bin/bash

set -e
package="package_2"


function deployDevelop {
    echo -e "   MOCK DEPLOY FOR PACKAGE 2"
}

function deployProduction {
    echo -e "   MOCK PRODUCTION DEPLOY FOR PACKAGE 2"
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