#!/bin/bash

ENV_FILE=${1-local.env}
cp Dockerfile Dockerfile.orig
while read line;do
   echo ${line}
   if ! grep "${line}" Dockerfile >/dev/null;then 
      sed -i "/^### ENV BELOW/a \\${line}" Dockerfile
   else
      echo "'${line}' already found"
   fi
done < ${ENV_FILE}
cur_md5=$(md5sum Dockerfile|awk '{print $1}')
orig_md5=$(md5sum Dockerfile.orig|awk '{print $1}')

if [ "X${cur_md5}" == "X${orig_md5}" ];then
   rm -f Dockerfile.orig
fi
