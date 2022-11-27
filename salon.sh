#! /bin/bash

# Salon Appointment Scheduler

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?\n"

MAIN_MENU() 
{
if [[ $1 ]]
then
  echo -e "\n$1"
fi 

#display main_menu
SERVICE_LIST=$($PSQL "select service_id, name from services")
echo "$SERVICE_LIST" | while read SERVICE_ID BAR SERVICE
do
  echo "$SERVICE_ID) $SERVICE"
done
read SERVICE_ID_SELECTED

#if no found
case $SERVICE_ID_SELECTED in
"1") BOOKING ;;
"2") BOOKING ;;
"3") BOOKING ;;
*) MAIN_MENU "I could not find that service. What would you like today?"
esac

}

BOOKING()
{
 # ask about phone number
 echo -e "\nWhat's your phone number?"
 read CUSTOMER_PHONE
 # check in database
 CUSTOMER_NAME=$($PSQL "SELECT name FROM customers where phone='$CUSTOMER_PHONE'")
 # if not found
 if [[ -z $CUSTOMER_NAME ]]
 then 
 # ask about name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
 # insert to database
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
 fi
 # ask about hour
 CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed 's/ //')
 SERVICE_NAME=$($PSQL "SELECT name FROM services where service_id=$SERVICE_ID_SELECTED")
 SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed 's/ //')
 echo -e "\nWhat time would you like your $SERVICE_NAME_FORMATTED, $CUSTOMER_NAME_FORMATTED?"
 read SERVICE_TIME
 # insert reservation
 CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers where phone='$CUSTOMER_PHONE'")
 INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, time, service_id) VALUES($CUSTOMER_ID, '$SERVICE_TIME', $SERVICE_ID_SELECTED)")
 # thank you
 echo -e "\nI have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME_FORMATTED."
}

MAIN_MENU