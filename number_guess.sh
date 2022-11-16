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
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE name='$USERNAME';")
  # count items of users as u join games as g on u.user_id=g.user_id where ... 
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE name='$USERNAME';")
  # find minimum of tries users as u join games as g on u.user_id=g.user_id where ... 
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# create random number
R=$(($RANDOM%1000+1))

echo -e "\nGuess the secret number between 1 and 1000:"
read NUMBER
COUNT=1
# echo $R, $COUNT, $NUMBER

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

# get user_id from users where name
# insert into games(user_id, tries) values($USER_ID, $COUNT)

if [[ ( $COUNT < $BEST_GAME ) ]]
then
  UPDATE_BEST=$($PSQL "UPDATE users SET best_game=$COUNT WHERE name='$USERNAME';")
fi

GAMES_PLAYED=$(($GAMES_PLAYED+1))
UPDATE_PLAYED=$($PSQL "UPDATE users SET games_played=$GAMES_PLAYED WHERE name='$USERNAME';")

echo "You guessed it in $COUNT tries. The secret number was $R. Nice job!"
