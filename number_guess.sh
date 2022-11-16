#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"

# USERNAME=read "Enter your username here:"
# query database for $USERNAME
# if username used before
  # "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
# else if username not unused
  # insert $USERNAME into database
  # "Welcome, $USERNAME! It looks like this is your first time here."

# create random number R=$(($RANDOM%1000))
# initialize COUNT=0

# INPUT() "Guess the secret number between 1 and 1000:"
  # return NUMBER
# if not a number
  # INPUT() "That is not an integer, guess again:"
# else
  # increment $COUNT=$COUNT+1
  # if $RANDOM > $NUMBER
    # INPUT() "It's higher than that, guess again"
  # elif $NUMBER >  $RANDOM
    # INPUT() "It's lower than that, guess again"
  # elif $NUMBER == $RANDOM
    # echo "You guessed it in $COUNT tries. The secret number was $RANDOM. Nice job!"
    # exit