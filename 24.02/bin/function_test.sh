#!/bin/bash

echo "
--folder  Specify a single folder to run from a collection.
1.Query
2.Dataset
3.Database
4.Util
5.Troubleshooting
6.HOS
7.Knowledge Base File
"
BASE_DIR="$(dirname "$(pwd)")"
CONFIG_PATH="$BASE_DIR/config"

#COLLECTION_FILE=`find $BIN_PATH -name '*'function-test-collection.json|xargs| awk -F" " '{print $1}'`
#ENV_FILE=environment.json

FOLDER="--folder "

if [[ -n "$1" ]];then
 case $1 in
    1)
        FOLDER+="Query"
        ;;
    2)
        FOLDER+="Dataset"
        ;;
    3)
        FOLDER+="Database"
        ;;
    4)
        FOLDER+="Util"
        ;;
    5)
        FOLDER+="Troubleshooting"
        ;;
    6)
        FOLDER+="HOS"
        ;;
    7)
        FOLDER+="Knowledge Base File"
        ;;
    *)
        FOLDER=""
 esac
else
  FOLDER=""
fi

echo $FOLDER

newman run $CONFIG_PATH/tsg-olap-function-test-collection.json -n 1 -e $CONFIG_PATH/environment.json -g $CONFIG_PATH/globals.json --verbose  --delay-request 200 --timeout-script 10000  --timeout-request 300000 --timeout  3600000 --insecure \
$FOLDER
