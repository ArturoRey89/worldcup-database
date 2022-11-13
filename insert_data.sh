#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    #get winner id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")

    #add team if not added
    if [[ -z $WINNER_ID ]]
    then
      echo -e "\nAdding winner to teams table:"
      INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      echo "Inserted $WINNER into teams, msg: $INSERT_WINNER"
    fi
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")

    #get opponent id 
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

    #add team if not added
    if [[ -z $OPPONENT_ID ]]
    then
      echo -e "\nAdding opponent to teams table:"
      INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      echo "Inserted $OPPONENT into teams, msg: $INSERT_OPPONENT"
    fi
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

    #add game (year, round, winner_id, opponent_id, w_goals, o_goals)
    echo -e "\nAdding game to games table:"
    INSERT_GAME_TEXT="INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)" 
    INSERT_GAME=$($PSQL "$INSERT_GAME_TEXT VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $W_GOALS, $O_GOALS)")
    echo "Inserted game $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $W_GOALS, $O_GOALS. msg: $INSERT_GAME"
  fi
done