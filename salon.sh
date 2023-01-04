#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"
MAIN_MENU() {
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  if [[ -z $AVAILABLE_SERVICES ]]
  then
    echo "No services available."
  else
    # display available bikes
    echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
    do
      echo "$SERVICE_ID) $NAME"
    done
  fi
  read SERVICE_ID_SELECTED
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    echo -e "\nI could not find that service. What would you like today?"
    MAIN_MENU
  else
    CHECK_SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    if [[ -z $CHECK_SERVICE_ID ]]
    then
      echo -e "\nI could not find that service. What would you like today?"
      MAIN_MENU
    else
      SERVICE_NAMED=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
      IDENT
    fi
  fi
}

IDENT() {
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  GET_CUSTOMER=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $GET_CUSTOMER ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    GET_CUSTOMER=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    APPOINTMENT
  else
    APPOINTMENT
  fi
}

APPOINTMENT() {
  echo -e "\nWhat time would you like your cut,$GET_CUSTOMER?"
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  read SERVICE_TIME
  BOOK_AP=$($PSQL "INSERT INTO appointments(customer_id, time, service_id) VALUES($CUSTOMER_ID, '$SERVICE_TIME', $SERVICE_ID_SELECTED)")
  APP=$($PSQL "SELECT time FROM appointments ORDER BY appointment_id DESC LIMIT 1")
  echo -e "\nI have put you down for a$SERVICE_NAMED at$APP,$GET_CUSTOMER."
}

MAIN_MENU
