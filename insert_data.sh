#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $"($PSQL "TUNCATE TABLE games, teams")"

# year,round,winner,opponent,winner_goals,opponent_goals

# read games data
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPO WINNGO OPPOGO
do
  if [[ $YEAR != "year" ]]
  then
# check if teams in teams table
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    echo $WINNER_ID
    if [[ -z $WINNER_ID ]]
    then
      
      INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[$INSERT_WINNER == "INSERT 0 1" ]]
      then
        echo Inserted into teams the winner, $WINNER
      fi

    fi
    OPPO_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPO'")
    if [[ -z $OPPO_ID ]]
    then
      INSERT_OPPO=$($PSQL "INSERT INTO teams(name) VALUES('$OPPO')")
      if [[$INSERT_OPPO == "INSERT 0 1" ]]
      then
        echo Inserted into teams the opponent, $OPPO
      fi
    fi  
    # add match details to games table
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPO_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPO'")
    echo $WINNER_ID
    echo $OPPO_ID
    INSERT_RESULTS=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPO_ID, $WINNGO, $OPPOGO)") 
    if [[ $INSERT_RESULTS == "INSERT 0 1" ]]
      then
        echo Inserted into games table
    fi
  fi

done