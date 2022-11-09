#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ -z "$*" ]]
  then
   echo "Please provide an element as an argument."
   exit 0
fi

if [ $1 -ge 0 ] 2> /dev/null
  then
    NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
fi

SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1'")
NAME=$($PSQL "SELECT name FROM elements WHERE name = '$1'")

if [[ $1 == $NAME || $1 == $SYMBOL || $1 == $NUMBER ]]
  then
    if [[ $1 == $NUMBER ]]
      then
        ELEMENT_NUMBER=$1
    fi

    if [[ $1 == $NAME ]]
      then
        ELEMENT_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
    fi

    if [[ $1 == $SYMBOL ]]
      then
        ELEMENT_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
    fi

    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ELEMENT_NUMBER")
    ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ELEMENT_NUMBER")
    ELEMENT_TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties ON types.type_id=properties.type_id WHERE properties.atomic_number = $ELEMENT_NUMBER")
    ELEMENT_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ELEMENT_NUMBER")
    ELEMENT_MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ELEMENT_NUMBER")
    ELEMENT_BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ELEMENT_NUMBER")

    echo "The element with atomic number $ELEMENT_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELTING_POINT celsius and a boiling point of $ELEMENT_BOILING_POINT celsius."
else
  echo "I could not find that element in the database."
fi
