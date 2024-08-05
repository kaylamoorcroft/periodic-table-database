#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t -q --no-align -c"
ALL_ELEMENT_INFO_QUERY="SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id)"

# if no input
if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."
else
  # if input is atomic number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # get element info from atomic_number
    ELEMENT_INFO=$($PSQL "$ALL_ELEMENT_INFO_QUERY WHERE atomic_number=$1")
  else 
    LENGTH=${#1}
    # if input string length max 2 chars (is symbol)
    if [[ $LENGTH -le 2 ]]
    then
      # get element info from symbol
      ELEMENT_INFO=$($PSQL "$ALL_ELEMENT_INFO_QUERY WHERE symbol='$1'")
    else
      # get element info from name
      ELEMENT_INFO=$($PSQL "$ALL_ELEMENT_INFO_QUERY WHERE name='$1'")
    fi
  fi
  
  # if doesn't element exists
  if [[ -z $ELEMENT_INFO ]]
  then
    echo "I could not find that element in the database."
  else
    # display element info
    echo $ELEMENT_INFO | while IFS="|" read NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT
    do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi