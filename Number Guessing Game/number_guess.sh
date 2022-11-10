#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

NUMBER=$[ $RANDOM % 1000 + 1 ]
GUESS_NUMBER=0

echo "Enter your username:"
read USERNAME

if [[ $USERNAME != $($PSQL "SELECT username FROM users WHERE username = '$USERNAME'") ]]
  then
    echo "$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")" > /dev/null;
    BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username = '$USERNAME'")
    echo "Welcome, $USERNAME! It looks like this is your first time here."
  else
    GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username = '$USERNAME'")
    BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username = '$USERNAME'")
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

echo "Guess the secret number between 1 and 1000:"

while [ true ]
  do
    read GUESS
    GUESS_NUMBER=$(($GUESS_NUMBER + 1))

    if ! [[ $GUESS =~ ^[0-9]+$ ]]
      then
        echo "That is not an integer, guess again:"
    elif [[ $GUESS -lt $NUMBER ]]
      then
        echo "It's higher than that, guess again:"
    elif [[ $GUESS -gt $NUMBER ]]
      then
        echo "It's lower than that, guess again:"
      else
        echo "$($PSQL "UPDATE users SET games_played = $GAMES_PLAYED + 1 WHERE username = '$USERNAME'")" > /dev/null;
        if [[ $BEST_GAME -gt $GUESS_NUMBER ]]
          then
            echo "$($PSQL "UPDATE users SET best_game = $GUESS_NUMBER WHERE username = '$USERNAME'")" > /dev/null;
        fi
        echo "You guessed it in $GUESS_NUMBER tries. The secret number was $NUMBER. Nice job!"
        exit 0
    fi
done