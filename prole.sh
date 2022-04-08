#! /bin/bash
########################################
#. conf/prole.conf
########################################
source ${SCRPT_INCLDS_BLDVER}
########################################

function prole_main ()
{
  version_up && current_version && test_dirs

  CMD_LIST=( "$PROLE_LIB" )
  CMD_LIST+=( "$(echo_currvers)" )
  CMD_LIST+=( "${PROLE_CONF}" )
  CMD_LIST+=( "${PROLE_ARGS}" )
  perl ${CMD_LIST[@]}

  #SCRIPT_CALL=($(echo "${RESP}" | jq -r '.script'))
  # bash $SCRIPT_CALL $PROLE_TMP $RESP
  # echo "$RESP">"$PROLE_TMP_CONF"
  ################################
  #sess_end "End of Script"
}
#
##################
#----------------
prole_main "${@}"
##########################
# End
##################################
# prole.sh
########################################
