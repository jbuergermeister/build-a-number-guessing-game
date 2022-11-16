#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME
while [[ -z $USERNAME ]]
do
  echo "Enter your username:"
  read USERNAME
done

NAME_CHECK=$($PSQL "SELECT name FROM users WHERE name='$USERNAME';")

if [[ -z $NAME_CHECK ]]
then
  NAME_INSERT=$($PSQL "INSERT INTO users(name,games_played) VALUES('$USERNAME',0);")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  USERNAME=$($PSQL "SELECT name FROM users WHERE name='$USERNAME';")
  GAMES_PLAYED=$($PSQL "SELECT COUNT(tries) FROM users as u JOIN games as g ON u.user_id=g.user_id WHERE name='$USERNAME' AND tries IS NOT NULL;")
  BEST_GAME=$($PSQL "SELECT MIN(tries) FROM users as u JOIN games as g ON u.user_id=g.user_id WHERE name='$USERNAME' AND tries IS NOT NULL;")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

R=$(($RANDOM%1000+1))
# echo $R

echo -e "\nGuess the secret number between 1 and 1000:"
read NUMBER
COUNT=1

while [[ ! $NUMBER = $R ]]
do
  COUNT=$(($COUNT+1))
  if [[ ! $NUMBER =~ ^[0-9]+$ ]]
  then 
    echo "That is not an integer, guess again:"
    read NUMBER
  elif [[ $R > $NUMBER ]]
  then
    echo "It's higher than that, guess again:"
    read NUMBER
  elif [[ $NUMBER >  $R ]]
  then
    echo "It's lower than that, guess again:"
    read NUMBER
  fi
done 

USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USERNAME';")
INSERT_GAME=$($PSQL "INSERT INTO games(user_id, tries) VALUES($USER_ID, $COUNT);")

if [[ ( $COUNT < $BEST_GAME ) ]]
then
  UPDATE_BEST=$($PSQL "UPDATE users SET best_game=$COUNT WHERE name='$USERNAME';")
fi

GAMES_PLAYED=$(($GAMES_PLAYED+1))
UPDATE_PLAYED=$($PSQL "UPDATE users SET games_played=$GAMES_PLAYED WHERE name='$USERNAME';")

echo -e "\nYou guessed it in $COUNT tries. The secret number was $R. Nice job!"
