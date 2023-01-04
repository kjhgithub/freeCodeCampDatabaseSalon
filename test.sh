#!/bin/bash
  # NUMBER_OF_SERVICES=$($PSQL "SELECT COUNT(*) FROM services")
  # if [[ !"$MAIN_MENU_SELECTION" =~ ^[0-9]+$ ]] || [[ $MAIN_MENU_SELECTION -gt $NUMBER_OF_SERVICES ]] || [[ $MAIN_MENU_SELECTION -lt 1 ]]
  # then
  #   echo -e "\nI could not find that service. What would you like today?"
  #   MAIN_MENU
  # else
  #   echo "Weiter gehts."
  # fi
PSQL="psql --username=freecodecamp --dbname=salon2 --no-align --tuples-only -c"

FUNC() {
  SERVICE_IDS=$($PSQL "SELECT service_id, name FROM services")
  echo  $SERVICE_IDS| while read ID BAR NAME
  do
    echo "$NAME $ID"
  done

}
FUNC