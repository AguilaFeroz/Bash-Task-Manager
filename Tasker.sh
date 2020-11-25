#!/bin/bash

#Script Description: This script allows a user to create tasks
#modify tasks, add tasks, show tasks, & mark tasks completed
# which are stored in .tsk files

clear
wait(){
#Wait for user to press enter to continue
tput cup 15 35; read -n1 -r -p "Press [Enter] to continue" key
trap " " 2 3 4
until [[ "$key" = "" ]]
do
echo
tput cup 15 35; read -n1 -r -p "Press [Enter] to continue" key;echo
if [[ "$key" = "" ]]; then
clear
tput cup 8 35;echo "Let's Go!"; tput cup 9 40; sleep 1
else
    # Anything else pressed, do whatever else.
echo
tput cup 14 35;tput setaf 011; echo "Invalid Key Press!"
tput setaf 111;
fi
done
trap 2 3 4

}
checkfile(){ #Function 1: Checks if file exists; if not it creates it
PATH=$PATH:.
if [ "$1" == "" ]
	then
tput cup 1 35; echo "Enter a file name: "; tput cup 2 45;
read FILE
echo "File name entered: $FILE"

	else
FILE=$1
echo "File name entered: $FILE "
fi

#mv $FILE $FILE.tsk
if [ -f "$FILE.tsk" ] #Check if the file exists
	then
chmod 666 $FILE.tsk
echo "$FILE exists"
#nano $FILE.tsk

else
echo "$FILE does not exist"
touch $FILE.tsk #creates file if it does not exist
chmod 666 $FILE.tsk
#nano $FILE.tsk #opens new file
fi
}


splash(){ #Function 2: Displays Splash Screen
suline=`tput smul`
ruline=`tput rmul`

tput clear
echo $suline;tput cup 2 35; echo "WELCOME TO TASKER!"; echo $ruline
echo
echo
echo

wait
}


add(){
clear
status="Open"
tput cup 1 35; echo "Enter a date: dd-mm"; tput cup 2 35; read date
tput cup 3 35; echo "Enter task name: task_name (NO spaces)"; tput cup 4 35; read task;
taskinfo=`echo $date ; echo $task ; echo $status`

#add to end of list (file)
echo $taskinfo >> $FILE.tsk

wait

menu
}

remove(){
clear
tput cup 1 35; echo "Enter the task number to remove: ";tput cup 2 35; read num
numd="'"$num"d'"
echo "sed -i "$numd" $FILE.tsk" > runsed
chmod +x runsed
tput cup 4 35; echo "Are you sure? y/n"

tput cup 5 35; read option

if [ "$option" = "y" ]
then
runsed

else
tput cup 6 35; echo "Whew! That was a close one!"
sleep .5

fi

wait
rm runsed
menu
}

modify(){
clear
tput cup 1 35; echo "Enter the task number to modify: ";tput cup 2 35; read num
numd="$num"
status="Open"

tput cup 3 35; echo "Enter a date: dd-mm"; tput cup 4 35; read date

tput cup 5 35; echo "Enter task name: task_name (No spaces)"; tput cup 6 35; read task

taskinfo=`echo $date ; echo $task ; echo $status`

echo "sed -i '"$numd"s/.*/"$taskinfo"/' $FILE.tsk" > runsed
chmod +x runsed
tput cup 7 35; . runsed

wait
rm runsed
menu
}

line(){
sed -n -e "$1p" "$2"
}

complete(){
clear
tput cup 1 35; echo "Enter the completed task's number: "; read num; tput cup 2 35
status="Closed"
echo "line $num $FILE.tsk" > temp1
chmod +x temp1
. temp1 > temp
ctask=`cut -d " " -f 1,2 temp`
#echo $ctask
echo "sed -i '"$num"s/.*/"$ctask"" $status"/' $FILE.tsk" > runsed
chmod +x runsed
tput cup 3 35; . runsed

wait
rm runsed; rm temp; rm temp1
menu

}

show(){

echo "nl $FILE.tsk" > show
chmod +x show
clear
echo "All tasks for $FILE.tsk:"
. show

wait
rm show
menu
}

terminate(){

clear
grep "Open" $FILE.tsk > temp
wc -l temp > temp1
cut -d " " -f 1 temp1 > temp
open=`cat temp`
tput cup 4 35; echo "$FILE.tsk saved with $open Open items"
wait
rm temp; rm temp1
exit 0
}

menu(){
clear; tput cup 1 35; echo "Main Menu"
tput cup 3 35; echo "Select an option: "

tput cup 6 35; echo "0: Exit"
tput cup 7 35; echo "1: Add New Task"
tput cup 8 35; echo "2: Remove Task"
tput cup 9 35; echo "3: Modify Task"
tput cup 10 35; echo "4: Complete Task"
tput cup 11 35; echo "5: Show Tasks"

tput cup 12 42; read input;

case $input in
0) tput cup 14 35; terminate  ;;
1) tput cup 14 35; add ;;
2) tput cup 14 35; remove ;;
3) tput cup 14 35; modify ;;
4) tput cup 14 35; complete ;;
5) tput cup 14 35; show ;;
*) tput cup 14 35; echo "Invalid Selection!" ;;
esac
sleep .5
clear

}

clear
checkfile
splash
sleep .5
clear
menu
sleep .3
clear
