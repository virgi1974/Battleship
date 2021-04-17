# 🚢 💥 Battleship 💥 🚢

Basic CLI app to play battleship.

### Dependencies 🕸️

The only dependency is the Ruby version itself when trying a local setup.

- Ruby version. 2.7.0

Few GEM's have been used but only for testing purposes.

### Setup

Clone the repo and `bundle install`.

### Interface - How to Play

There is a file `game_starter` to be run directly with  
**`ruby game_starter.rb`**.  
For the starting player is determined at random option an argument must be passed, so the program runs with  
**`ruby game_starter.rb RANDOM`**.

### Usage

The Game interface starts by asking the players names.  
After that players must decide the locations of the 3x1 & 4x1 ships.

![](https://user-images.githubusercontent.com/13310108/115128045-594ffa80-9fdb-11eb-9bea-dc234b3a0045.png)

Then both players choose their movements in the correct order.  
If the user fails once she-he will have a second try(Step3 requirement).

![](https://user-images.githubusercontent.com/13310108/115128052-610f9f00-9fdb-11eb-882b-6a4a3b291fb5.png)

Once the game is over and one of the players is the winner there is a choice to start the game again by pressing the letter **P**  
`######## Play again [P] ########`.

### Testing ⛑️

The test suite can be run by using the command **`rspec`**.  
Gem `Simplecov` was added to ensure full coverage.

![](https://user-images.githubusercontent.com/13310108/115128050-5e14ae80-9fdb-11eb-8d4e-23e20d46fffa.png)

#### How would you improve your solution? What would be the next steps? 💡

- I placed far too much logic in the main file. When I reached final steps I realized that moving parts of that logic was not so simple. Some parts of the main file could have been moved to lib folders for helper funcions (thinking for example of functions to render messages).
- I tried to test the main file but as it works on prompting players and waiting for their response, the execution got stucked. Didn't get the time to investigate how to test this kind of apps.
