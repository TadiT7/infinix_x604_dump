#!/bin/bash
#
# To call this script, make sure make_f2fs is somewhere in PATH

function usage() {
cat<<EOT
Usage:
${0##*/} OUTPUT_FILE SIZE
EOT
}

echo "in mkf2fsuserimg.sh PATH=$PATH"

if [ $# -lt 2 ]; then
  usage
  exit 1
fi

OUTPUT_FILE=$1
SIZE=$2
shift; shift


if [ -z $SIZE ]; then
  echo "Need size of filesystem"
  exit 2
fi
#Infinix :add by caizhaohui for factory version separation 20180319 start
if [[ "$1" == "-f" ]]; then
  SRC_DIR=$2
  SLOAD_F2FS_CMD="sload_f2fs -S -f $SRC_DIR $OUTPUT_FILE"
  shift; shift
  if [ ! -d $SRC_DIR ]; then
    echo "Can not find directory $SRC_DIR!"
	exit 3
  fi
fi
#Infinix :add by caizhaohui for factory version separation 20180319 end
MAKE_F2FS_CMD="make_f2fs -S $SIZE $OUTPUT_FILE"
echo $MAKE_F2FS_CMD
$MAKE_F2FS_CMD
if [ $? -ne 0 ]; then
  exit 4
fi
#Infinix :add by caizhaohui for factory version separation 20180319 start
if [ ! -z "$SLOAD_F2FS_CMD" ]; then
  echo $SLOAD_F2FS_CMD
  $SLOAD_F2FS_CMD
  if [ $? -ne 0 ]; then
    exit 4
  fi
fi
#Infinix :add by caizhaohui for factory version separation 20180319 end