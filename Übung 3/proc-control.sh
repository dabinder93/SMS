#!/bin/bash

isNumber(){
re='^[0-9]+$'
 if [[ $1 =~ $re ]]; then
    return 0 # true
  else
    return 1 # false
  fi
}

if [ -z "$1" ]; then
   echo >&2 "Parameter 1 has to be a name or the pid"
   exit;
fi

if [ -z "$2" ]; then
   echo >&2 "Second Parameter has to be an integer Time value"
   exit
else 
   if ! isNumber $2; then 
      echo >&2 "Second Parameter must be an integer"
      exit
   fi
fi

isParam3Set=false 

if [ ! -z "$3" -a "$3" = "-auto" ]; then
   isParam3Set=true 
else 
   if [ "$3" != "" ]; then 
      echo >&2 "Third paremeter 3 can only be -auto or unused"
      exit
   fi
fi

pid=$1
sec=$2

if ! isNumber $1; then 
   echo "Name entered"
   
   if  pgrep $1 >/dev/null; then 
      
      pid=( $(pgrep $1))

      if [ "${#pid[@]}" -gt "1" ]; then
	echo "There are more pid with the same name. Choose one:"
	echo
	echo "PID"
	for (( i=0; i<${#pid[@]}; i++ )); do 
   		echo ${pid[i]}"	" 
	done
	echo
         
         selec=nothig 
         invalid=true 
         while $invalid; do
            while ! isNumber $selec; do 
               echo "Select a PID:"
               read selec
            done
            for (( i=0; i<${#pid[@]}; i++ )); do 
               if [ "${pid[i]}" = "$selec" ]
               then
                  invalid=false;
	          pid=$selec;
                  break
               fi
            done
	    if $invalid 
	    then
	        selec=nothig
	    fi
         done
      fi  
   else 
	echo Process don\'t found!
	echo
	exit
   fi
else
   echo PID is entered.
   echo
fi

echo "Selected PID:	"$pid


cmd=$(ps -o args $pid |grep -v COMMAND)
echo $cmd


checkingProcess=true;
while $checkingProcess; do 

	sleep $sec

	if ps -p $pid >/dev/null; then
   		echo >&1 "Status: OK"; 
	else
   		echo >&2 "Status: CLOSED"; 
   		if $isParam3Set; then # Auto restart
	   		nohup $cmd & > /dev/null
	   		pid=$!
	   		if [[ $? != 0 ]]; then
				>&2 echo "Restarting"
	   		else
				echo "Restaring the program, PID: "$pid
	   		fi
      		else # User choose if restart or not

			option=nothing
			valid=false
			while ! $valid; do
   				echo "Restart process? [y/n]"
   				read option
   				case  $option  in
                			y|yes)   
					    valid=true    
     					    nohup $cmd & > /dev/null
	   				    pid=$!
	   				    if [[ $? != 0 ]]; then
						>&2 echo "Error restarting the process."
	   				    else
						echo "Program restarted, PID: "$pid
	   				    fi
                 		  	    ;;
              				n|no)
					    valid=true
     					    checkingProcess=false;
              				      ;;
              				*) 
					   echo "Pleas enter 'y' or 'n' or 'yes' or 'no'"             
          				esac 
			done
      		fi
	fi
done

echo "Done!"