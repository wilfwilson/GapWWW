#!/bin/bash

# Script to regenerate the information in the _Packages directory from the
# PackageInfo.g files of the packages contained in the directory specified
# by the first argument.
#
# The script first finds all the PackageInfo.g files with the `find` command.
# The script then calls a GAP file of the same name (ending .g rather than .sh)
# to process the PackageInfo.g files and output the new files into _Packages.

FILENAME=`basename ${0}`
SCRIPT=${FILENAME%.sh}

if [ "$#" != "3" ] ; then
  echo "Usage: ${SCRIPT}.sh: <pkg-dir> <gap-exe> <tmp-dir>"
  exit 1
fi;

PKG_DIR=${1} 
GAP_EXE=${2}
TMP_DIR=${3}

if [ ! -d ${1} ] ; then
  echo "<pkg-dir> is not a directory: ${PKG_DIR}"
  exit 2
elif [ ! -d ${3} ] ; then
  echo "<tmp-dir> is not a directory: ${TMP_DIR}"
  exit 2
fi

PACKAGEINFO_PATHS="${TMP_DIR}/_tmp_packageinfo_paths.tmp"

# We use '-maxdepth 2' since e.g. some packages contain others (e.g. hap)
find ${PKG_DIR} -maxdepth 2 -name 'PackageInfo.g' > ${PACKAGEINFO_PATHS}
${GAP_EXE} -A -r -q -x 163 <<GAPInput
path := "${PACKAGEINFO_PATHS}";;
Read("etc/${SCRIPT}.g");
GAPInput
rm ${PACKAGEINFO_PATHS}
