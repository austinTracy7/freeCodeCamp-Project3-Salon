#!/bin/bash

PSQL='psql --csv --tuples-only --username=freecodecamp --dbname=salon -c'

# declare -a Data

ServicesData=$($PSQL "SELECT * FROM services;")

# echo ${Data[0]}
DISPLAY_SERVICES(){
while IFS="," read -r ServiceId Name
do
    echo "${ServiceId}) ${Name}"
done << EOD
$1
EOD
}
DISPLAY_SERVICES "${ServicesData}"
SELECTED_SERVICE=''
TEST_FOR_SERVICE(){
while IFS="," read -r ServiceId Name
do
    if [ $ServiceId = $2 ]
    then
      return 0
    else
      return 1
    fi
done << EOD
$1
EOD
}
TEST_FOR_SERVICE "${ServicesData}" 1
SERVICE_ID_FOUND=$(echo $?)
# # echo $Data
echo $SERVICE_ID_FOUND

# function myfunc()
# {
#     local  myresult='some value'
#     echo "$myresult"
# }

# result=$(myfunc)   # or result=`myfunc`
# echo $result
