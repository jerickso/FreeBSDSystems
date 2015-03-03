#!/bin/sh
#
# Compare the files located in this directory with files located at the root
#   of this system.  Also copies over the files if they do not exist
#



# Script working directory (Full path)
BASE="$( cd "$( dirname "$0" )" && pwd )"


# List of files to ignore
IGNORE_FILES="${BASE}/readme.md"
if [ -d Merging ]; then
  for FILE in Merging/*
  do
    IGNORE_FILES="${IGNORE_FILES} ${BASE}/${FILE}"
  done
fi

# The merge script file, aka this script
ABS_SCRIPT=$(readlink -f $0)
IGNORE_FILES="${IGNORE_FILES} ${ABS_SCRIPT}"


OVERWRITE_FILES=""
# List of file to overwrite
if [ -r Merging/overwrite ] ; then
  OVERWRITE_FILES=`cat Merging/overwrite`
fi

# Load Mergemaster
if [ -r Merging/functions.sh ]; then
  . Merging/functions.sh
fi

usage () {
  VERSION_NUMBER=`grep "[$]FBSDSystems:" $ 0 | cut -d '' -f 1`
  echo "version ${VERSION_NUMBER}"
}

# Grab all the files, ignoring the .hg directory
FILES=`find "${BASE}" -type f -not -path "${BASE}/.hg/*"`
for FILE in $FILES
do
  # Determine if we need to ignore the file
  SKIP_FILE=
  for IGNORE_FILE in ${IGNORE_FILES}
  do
    if [ ${FILE} = ${IGNORE_FILE} ]
    then
      SKIP_FILE=True
      continue
    fi
  done

  [ ${SKIP_FILE} ] && continue

  NEWFILE=${FILE#${BASE}}

  FORCE_FILE=
  for OVERWRITE_FILE in ${OVERWRITE_FILES}
  do
    if [ ${FILE} = ${OVERWRITE_FILE} ]
    then
      FORCE_FILE=True
      continue
    fi
  done

  # Copy the file over if it does not exist
  if [ ! -f ${NEWFILE} ]
  then
    echo New File: Copying ${FILE} to ${NEWFILE}
    cp ${FILE} ${NEWFILE}
    continue
  fi

#  RESULTS=`diff -rq $FILE ${NEWFILE} 2>&1`
  #
  for RESULT in `diff -rq ${FILE} ${NEWFILE} | grep "^Files.*differ$" | sed 's/^Files \(.*\) and .* differ$/\1/'` 
  do
    FORCE_FILE=
    for OVERWRITE_FILE in ${OVERWRITE_FILES}
    do
      if [ ${FILE} = ${BASE}/${OVERWRITE_FILE} ]
      then
        FORCE_FILE=True
        continue
      fi
    done

    if [ ${FORCE_FILE} ]
    then
      echo FORCE COPY: Files Differ ${FILE}
      cp ${FILE} ${NEWFILE}
    fi

    diff_loop ${FILE} ${NEWFILE}
  done
done
