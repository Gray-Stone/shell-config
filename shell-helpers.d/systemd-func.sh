#! /bin/bash

########### Function to help call systemctl and journalctl
function sysc (){

python_arg_process(){
python3 <<EOF
import argparse
import pathlib

parser = argparse.ArgumentParser()
parser.add_argument("action" , type=str , help="executable file")
parser.add_argument("unit" , type=str , help="unit name")
parser.add_argument("-u" , "--user" ,action='store_true' , default = False , help="use user unit")
args = parser.parse_known_args("$*".split(" "))[0]

if args.user :
  sys_cmd = f"systemctl --user {args.action} {args.unit} --no-pager"
else:
  sys_cmd = f"sudo systemctl {args.action} {args.unit} --no-pager"

journal_cmd=""
if args.action in ["start" , "restart" , "status"]:
  if args.user :
    journal_cmd = f"journalctl --user -n 25 -fu {args.unit} -o cat"
  else:
    journal_cmd = f"sudo journalctl -n 25 -fu {args.unit} -o cat"

print(f"""
SYS_CTL_CMD="{sys_cmd}"
JOUR_CTL_CMD="{journal_cmd}"
""")
EOF
}

  (
    PYTHON_OUTPUT=$(python_arg_process "$@")
    echo "$PYTHON_OUTPUT"
    if [[ "$1" == "-h" ]]  ; then
      exit 1
    fi
    if [ $# -eq 0 ] ; then
      echo "No arguments supplied!, use -h for more info"
    fi

    eval "${PYTHON_OUTPUT}"

    set -vx
    eval "${SYS_CTL_CMD}"

    if [[ -n "${JOUR_CTL_CMD}" ]]; then
      echo "
      ###########################
      # Shwoing unit journal log
      ###########################
      "
      eval "${JOUR_CTL_CMD}"
    fi

  )
}

function journal_u () {
  journalctl --user -efu "$@"
}

function journal_s () {
  sudo journalctl -efu "$@"
}

function s-u.start () {
  sysc -u start "$@"
}
function s-u.restart () {
  sysc -u restart "$@"
}

function s-u.stop () {
  sysc -u stop "$@"
}

function s-u.status () {
  sysc -u status "$@"
}

function s-u.cat () {
  sysc -u cat "$@"
}

function sys-run () {
  set -xv
  echo "$RED running $GREEN $1 $RED with $GREEN ${@:2} $NC"
  UNIT_NAME="$1_$(date +%b%d_%H:%M:%S)"
  systemd-run --user --unit "${UNIT_NAME}" --property=KillSignal=SIGINT --remain-after-exit    /bin/zsh -c " source ~/.zshrc ; sleep 1 ; ${*} "
  if tty -s ; then 
    journalctl --user -fu ${UNIT_NAME} -o cat
  else 
    sleep 2
    journalctl --user -u ${UNIT_NAME} -o cat -n 100
  fi 
}
