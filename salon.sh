#!/bin/bash

PSQL='psql --csv --tuples-only --username=freecodecamp --dbname=salon -c'

ServicesData=$($PSQL "SELECT * FROM services;")

DISPLAY_SERVICES(){
while IFS="," read -r ServiceId Name
do
    echo "${ServiceId}) ${Name}"
done << EOD
$1
EOD
}

TEST_FOR_SERVICE(){
while IFS="," read -r ServiceId Name
do
    if [ $ServiceId = $2 ]
    then
      GLOBAL_SERVICE_ID_FOUND=0
      return 0
    else
      GLOBAL_SERVICE_ID_FOUND=1
    fi
done << EOD
$1
EOD
}

GLOBAL_SERVICE_ID_FOUND=0
SERVICE_ID_SELECTED=0

GET_DESIRED_SERVICE(){
  echo -e $1
  DISPLAY_SERVICES "${ServicesData}"
  read DESIRED_SERVICE
  SERVICE_ID_SELECTED=$DESIRED_SERVICE
  TEST_FOR_SERVICE "${ServicesData}" $DESIRED_SERVICE
  if [ $GLOBAL_SERVICE_ID_FOUND = 1 ]
  then
    GET_DESIRED_SERVICE "\nThat isn't something we offer. Here's the list of things we offer again. Please pick the number corresponding to the service you desire."
  fi

}

# SERVICE_ID_FOUND=$(echo $?)
# # echo $Data
echo $SERVICE_ID_FOUND

# running the main script
echo -e '\n~~~~~ Simply A Salon ~~~~~\n'

GET_DESIRED_SERVICE "How may we be of service for you today? Please type a service_id."

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;")

echo "Great, what is your phone number?"
read CUSTOMER_PHONE

CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")

if [ -z $CUSTOMER_NAME ]
then
  echo "What is your name?"
  read CUSTOMER_NAME
  INSERT_RESPONSE=$($PSQL "INSERT INTO customers(name,phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE');")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")
fi

echo "Okay. Just one more thing. When would you like to come by?"
read SERVICE_TIME

INSERT_RESPONSE=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME');")

echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

