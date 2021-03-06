#!/usr/bin/env bash
#
# Usage: sh localize.sh
#
# This script should be executed after adding new resource strings and after
# udating the translated .po files.
#
# This script
# - converts all compiled .rst files to .po files,
# - updates all translated xx.po files
#

# enable for debugging
#set -x
set -e

if [ ! -x tools/updatepofiles ]; then
  cd tools
  make updatepofiles
  cd -
fi

if [ "@"$FPCTARGET == "@" ]; then
  FPCTARGET=`fpc -iTP`-`fpc -iTO`
  if [ $FPCTARGET == "-" ]; then
    FPCTARGET=""
  fi
fi

RSTFILES=(
  ". lazarusidestrconsts lazaruside"
  ". debuggerstrconst"
  "components/lazreport/samples/editor maincalleditor calleditorwithpkg"
  "doceditor lazdemsg lazde"
  "examples/lazresexplorer reconstsunit resexplorer"
  "tools/lazdatadesktop lazdatadeskstr lazdatadesktop"
)

set -x

for idx in ${!RSTFILES[@]}; do
  LINE=(${RSTFILES[idx]})
  RSTDIR=${LINE[0]}  
  RSTFILE=${LINE[1]}  
  POFILE=${LINE[2]:-$RSTFILE}
   
  RST=$(find $RSTDIR -name $RSTFILE.rst)
  if [ -n "$RST" ]; then
    RST=`find $RSTDIR -name $RSTFILE.rst | xargs ls -1t | head -1`;
  
    if [ -n "$RST" ]; then
      POFileFull=$RSTDIR/languages/$POFILE.po
      
      ./tools/updatepofiles $RST $POFileFull
      
    fi
  fi
done

exit 0

