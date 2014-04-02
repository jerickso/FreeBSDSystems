#!/bin/sh
#
# Compare the files located in this directory with files located at the root
#   of this system.  Also copies over the files if they do not exist
#

BASEDIR=$(dirname $0)
ABS_SCRIPT=$(readlink -f $0)

# Script working directory
SWD="$( cd "$( dirname "$0" )" && pwd )"

# Grab all the files, ignoring the .hg directory
for FILE in `find "${SWD}" -not -path "${SWD}/.hg/*" -type f`;
do
  # Ignore this script file
  [ ${FILE} = ${ABS_SCRIPT} ] && continue

  NEWFILE=${FILE#${SWD}}

  # Copy the file over if it does not exist
  if [ ! -f ${NEWFILE} ]
  then
    echo Copying ${FILE} to ${NEWFILE}
    cp ${FILE} ${NEWFILE}
    continue
  fi

#  RESULTS=`diff -rq $FILE ${NEWFILE} 2>&1`
  #
  for RESULT in `diff -rq ${FILE} ${NEWFILE} | grep "^Files.*differ$" | sed 's/^Files \(.*\) and .* differ$/\1/'` 
  do
    echo File differs ${RESULT}
  done
done
