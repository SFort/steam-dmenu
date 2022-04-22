#!/bin/sh
run="dmenu -i"
pkill=0
path="$HOME/.local/share/Steam/steamapps/"
while getopts "ohd:l:" arg; do
	case "$arg" in
		d)run=$OPTARG;;
		l)path=$OPTARG;;
		o)pkill=1;;
		*)echo "ARGS
	-h print this help message
	-o parse and print, don't run
	-d Custom dmenu command. Default: $run
	-l Steam appmanifest location. Default : $path

PIPE BEHAVIOUR
	Piping out will output "name" "id"...
	Piping into the program takes "name" "id"...
NOTE
	Don't use relative paths
	Paths must be folders and end with /
";exit;;
	esac
done
shift $(($OPTIND -1))

test $# -eq 0 && for arg in ${path}appmanifest_*.acf; do
line="`cat $arg`";
nam="`echo "$line"|tr '\n\t' ' '|sed 's/.*"name"[^"]*"\([^"]*\).*/\1/'|tr ' ' '_'`"
set -- "$@" "$nam" "`echo "$line"|tr '\n\t' ' '|sed 's/.*"appid"[^"]*"\([^"]*\).*/\1/'`" 
done
test $pkill -eq 1 && printf '%s\n' "$@" && exit
test -n "$run" && xdg-open "steam://run/$run"
run=`printf '%s  :%s\n' "$@" | sort | $run | sed 's/.*:\(.*\)/\1/'`
