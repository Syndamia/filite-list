#!/bin/bash

# Made by Kamen Mladenov, aka Syndamia, under the GNU GPL-3.0 license
# Source: https://github.com/Syndamia/filite-list

help_info=$(cat <<HELP

filite-list.sh [OPTIONS] -- script to show you the IDs and their values of filite entries on a given server

Where:
	-v,   --version                Shows the version of the script
	-h,   --help, -?               Display this help message
	-d,   --dependencies           List required dependencies for the script

	-ho,  --host [LINK]            Use the given host. MUST be in the format of "https://example:port.com" (port is not required), without the trailing forward slash!
	-f,   --files                  Show only the file entries
	-l,   --links                  Show only the link entries
	-t,   --text                   Show only the text entries
	-oi,  --only-id                Show only IDs of entries (and NOT their values)
	-n,   --number-limit [AMOUNT]  Limit how many entries to show from each type
	-nid, --numerical-id           Show the numerical IDs, rather than the text IDs (the ones that are used in links)
HELP
)

filite_host="https://filite.raphaeltheriault.com"
types=(f l t)
type_name=(Files Links Texts)
info_name=(filepath forward contents)

# Process arguments
overwrite_shown=-1
only_link=false
show_limit=-1
show_numerical_id=false

while [ ! -z $1 ]; do
	case $1 in
		-v|--version)
			printf "filite-list.sh 1.2\n"
			exit
			;;
		-d|--dependencies)
			printf "\nDependencies:\n-------------\ncurl\njq\n\n"
			exit
			;;
		-ho|--host)
			shift
			filite_host=$1
			;;
		-f|--files)
			overwrite_shown=0
			;;
		-l|--types)
			overwrite_shown=1
			;;
		-t|--text)
			overwrite_shown=2
			;;
		-oi|--only-id)
			only_link=true
			;;
		-n|--number-limit)
			shift
			show_limit=$1
			;;
		-nid|--numerical-id)
			show_numerical_id=true
			;;
		-h|--help|-?)
			printf "$help_info\n\n"
			exit
			;;
		*) ;;
	esac

	shift
done

if ! [ -x "$(command -v curl)" ]; then
	printf "You need to install curl!\n"
	exit 
elif ! [ -x "$(command -v jq)" ]; then
	printf "You need to install jq!\n"
	exit
fi

# Automatically switch on show_numerical_id, when the server doesn't support getting string IDs from numeric ID
if [ -z "$(curl -sX GET $filite_host/id/0)" ] && [[ $show_numerical_id == false ]]; then
	printf "\nWARNING: The host's version of filite doesn't support get string IDs by giving numerical IDs!\n         Only numerical ID's will be shown!\n"
	show_numerical_id=true
fi

# Show entries from only one category
if (( overwrite_shown > -1 ))
then
	types=(${types[overwrite_shown]})
	type_name=(${type_name[overwrite_shown]})
	info_name=(${info_name[overwrite_shown]})
fi

# Main logic
l=0
while (( l < ${#types[@]} )); do
	printf '\n%s\n------\n' "${type_name[$l]}"

	# Check if you can even get the type entries
	if (( 399 < $(curl -s -o /dev/null -w "%{http_code}" $filite_host/${types[$l]}) )); then
		printf "Server returned an Error!\n"
		((l++))
		continue
	fi

	# Get all available info and ids
	data=$(curl -sX GET $filite_host/${types[$l]})
	ids=($(echo $data | jq -r .[].id | tr ' ' '\n'))

	if [[ $only_link == false ]]; then
		# Get all desired information (content or smth else) and from each one:
		# - take from beginning to first space or new line or tab or carriage return
		# - or take from beginning to end (if those characters don't exist)
		# - take only the first 50 characters
		info=($(echo $data | jq -r ".[].${info_name[$l]} | match(\"^.*?(?=[ \n\t\r])|^.*$\") | .string | .[0:50]"))
	fi

	# Print information for each file/link/text
	i=0
	while (( i < ${#ids[@]} && ( show_limit < 0 || i < show_limit ) )); do
		# Make the id, depending on script parameters
		if [[ $show_numerical_id == false ]]; then
			id=$(curl -sX GET $filite_host/id/${ids[$i]})
		else
			id=${ids[$i]}
		fi

		# Don't print info, if it isn't wanted
		if [[ $only_link == false ]]; then
			if [[ $show_numerical_id == false ]]; then
				printf '%-6s : %s \n' "$id" "${info[$i]}"
			else
				printf '%-10s : %s \n' "$id" "${info[$i]}"
			fi
		else
			printf "$id\n"
		fi
		((i++))
	done
	((l++))
done

printf '\n'

