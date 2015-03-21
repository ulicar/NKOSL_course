#/bin/bash


function f_show_help {
  echo -e "Usage: "$0" req_value
           \t\t[-e|--extended opt_value]" 2>&1
}

function f_main {
  
  echo 'Main' 
}



if [[ "$0" = $BASH_SOURCE ]]
then
  while [[ $# -ge 1 ]]
  do
    key="$1"
  
    case $key in
      -h|--help)
      f_show_help
      exit 0; 
      ;;
      -e|--extended)
      EXTENDED="$2"
      shift
      ;;
      *)
      REQUIRED=$key  # unknown option or a positional argument!
      ;;
    esac
    shift
  done

  echo "EXTENDED VALUE = "$EXTENDED""
  echo "REQUIRED VALUE = "$REQUIRED""

  f_main
fi

exit 0
