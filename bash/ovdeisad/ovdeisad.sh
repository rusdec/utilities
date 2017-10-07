#!/bin/bash

#<НАСТРОЙКИ>

#частота проверки файла на изменение
SLEEP_TIME_SEC=2

#вывод времени в первой строке
SHOW_DATE=true

#использовать time при выполнении
USE_TIME=false

#</НАСТРОЙКИ>

if [ -z $1 ]; then
  echo "Формат: <PROGRAMM>:<FILE> <ARGS>"
  echo "Пример: go:../main.go \"1 2 3\""
  exit 1
fi

function get_state {
  local state=`stat -r "${1}" | cut -d' ' -f2`
  
  echo ${state}
}

mLANG=`echo "${1}" | cut -d ':' -f1`
mFILE=`echo "${1}" | cut -d ':' -f2`


if [ ! -z "${2}" ]; then
  mARGS="${2}"
else
  mARGS=""
fi

cstate=`get_state ${mFILE}`

case ${mLANG} in
  "go") mLANG=${mLANG}" run"
  ;;
  *)mLAng=${mLANG}
  ;;
esac

header=""
if ( ${SHOW_DATE} ); then
  header="date;echo"
fi

prepend=""
if ( ${USE_TIME} ); then
  prepend="time"
fi

while true; do
  nstate=`get_state ${mFILE}`
  if [[ ${nstate} != ${cstate} ]]; then
    clear
    eval "${header} ${prepend} ${mLANG} ${mFILE} ${mARGS}"
    cstate=`get_state ${mFILE}`
  fi
  sleep ${SLEEP_TIME_SEC}
done
