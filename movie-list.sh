#Function
showMyGreetingPattern() {
	echo " ____                    _           ___"
	echo "|  _ \\                  | |         / _ \\"
	echo "| | \\ \\_______   ___ _ _| |___     | | | |__  __  ___"
	echo "| | | | '_|   | |  _| | | |   |    | | | |  \\|  \\|   |"
	echo "| |_/ | | | | |_| |_| | | | | |_   | |_| | | | | | | |_"
	echo "|____/|_| |_____|___|___|_|_____|   \\___/| _/| _/|_____|"
	echo "                                         |_| |_|"
}
#Function
showCheerio() {
	echo "  ___  _                            __"
	echo " / _ \\| |                _         / /"
	echo "| | \\_\\ |_______________(_)___    / /"
	echo "| |  _|   |  _ |  _ | '_| |   |  /_/"
	echo "| |_/ | | |  __|  __| | | | | |  _"
	echo " \___/|_|_|____|____|_| |_|___| |_|"
	echo "Bash is Exited!"
}

#Function
showOptions() {
	echo "You can search \"Movie Name\", \"Year\", \"Film Production\", \"Director\""
	echo "Please choose ANY <1> or the following."
	echo -e "\tPressing \"\e[41;5mENTER\e[0m\" will show all movies. (default=1)"
	echo "1. Show all movies in a list"
	echo "2. Learn About this."
	echo "3. Search Movies."
}

showSystemSuccess() {
	#arrow#\e[32;5m-->\e[0m
	echo -e "\e[40;38;5;82m Dracula \e[30;48;5;82m Oppa \e[0m"
}

showSystemFailure() {
	#arrow#\e[32;5m-->\e[0m
	echo -e "\e[5m\e[40;38;5;196m Dracula \e[30;48;5;196m Oppa \e[0m"
}

shootEchoUserPressed() {
	if ( test -z $1 )
	then
		echo -e "\t\e[32m-->\e[0m You pressed \"\e[32mEnter\e[0m!\""
	else
		echo -e "\t\e[32m-->\e[0m You pressed \"\e[32m${1^}\e[0m!\""
	fi
}

shootEchoUserPressedFailure() {
	echo -e "\t\e[91;5m-->\e[0m You pressed \"\e[91;5m$1\e[0m!\""
}

showTextFileFound() {
	echo -e "\t\e[32m-->\e[0m Required \"$1\" is \e[32mFOUND\e[0m!"
}

showTextFileNotFound() {
	echo -e "\t\e[91;5m-->\e[0m Required \"$1\" is \e[91;5mNOT FOUND\e[0m!"
}

#Function
searchFile() {
	if  (test -f $1)
	then
		return $true
	else
		return $false
	fi
}

#Function
readTextFile() {
	showSystemSuccess
	if [[ $modSearch == "3" ]]
	then
		read -p "Enter movie name you want to search : " search1
		shootEchoUserPressed $search1
		while read -r line
		do 
			#Modify the read line String
		modLine=${line//-/}
		modLine=${modLine// /}
		modLine=${modLine//./}
		modLine=${modLine^^}
		#Modify the user's search
		modSearch1=${search1//select * from/}
		modSearch1=${modSearch1//this where movie is in /}
		modSearch1=${modSearch1//this where year \=/}
		modSearch1=${modSearch1//-/}
		modSearch1=${modSearch1// /}
		modSearch1=${modSearch1//./}
		modSearch1=${modSearch1//;/}
		#modLine.contains(''modSearch")
		if [[ ${modLine} =~ ${modSearch1^^} ]]
		then
			((count++))
			#Show only once
			if ((count==1)) 
			then
				#is Empty()
				if ( test -z ${modSearch1^^} )
				then
					echo -e "\e[104mThis is all the available movies!\e[0m"
				else
					echo -e "\e[104mWe found the followings:\e[0m"
				fi
			fi
				found=true
				IFS='#' read -ra my_array <<< $line
				for i in "${my_array[@]}"
				do
					#Get first part from splitted data
					echo "($count)${my_array[0]}"
					#Don't output second part, just break the loop
					break
				done
			#Don't break here. One Movie can have many episodes. E.g., Spiderman 1, 2.
		fi
		done < $1
	else
		while read -r line
		do
			echo $line
		done < $1
	fi
	showCheerio
}

#Function
isEmpty() {
	if ( test -z $1 )
	then
		showSystemSuccess
		shootEchoUserPressed "Enter"
	elif (( $1 > 3 ))
	then
		showSystemFailure
		shootEchoUserPressedFailure $1
	else
		showSystemSuccess
		shootEchoUserPressed $1
	fi	
}

searchAndFetchAllData() {
	if $(searchFile $1)
	then
		showSystemSuccess
		showTextFileFound $1
		readTextFile $1
	else
		showSystemFailure
		showTextFileNotFound $1
		showCheerio
	fi
}

#Execution
	showMyGreetingPattern
	showOptions
	read search
	
	modSearch=${search//-/}
	modSearch=${modSearch// /}
	modSearch=${modSearch//./}
	
	isEmpty "$modSearch"
	
	file1="movie-list.txt"	
	file2="learn-this-bash.txt"
	
	case "$modSearch" in
	
	""|1)
		searchAndFetchAllData $file1
		;;
		
	2)
		searchAndFetchAllData $file2
		;;
		
	3)
		searchAndFetchAllData $file1
		;;
		
	*) 
		#Pressing neither of the above ones.
		echo "You pressed neither 3 of the above!"
		showCheerio
		;;
	esac
