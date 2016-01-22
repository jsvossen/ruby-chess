#Ruby Chess

This is a simple two-player command-line chess game implemented in Ruby as part of [The Odin Project's Ruby chapter](http://www.theodinproject.com/ruby-programming)

To start the program run `$ ruby chess.rb` from the program's root directory.

##Requirements

While it is not required, the **win32console** gem is recommended for Windows users, as the board uses background color to shade the squares.  Install the gem by running `$ gem install win32console`.

If you wish to run the program without the gem, the game will automatically switch to "safe mode" and output a board that does not use background color.

##Starting a Game

The welcome screen offers four options: 
```
[new]  start a new game
[load] load a saved game
[help] command list
[quit] quit program
```

Commands are not case sensitive.

Enter `new` to begin a new game.

Enter `load` to bring up a list of available saved games.  You can also enter `load <name>` (where `<name>` is the save name) if you already know which game you want to load. Loading is only available from the welcome screen.

Enter `help` at any time to bring a list of commands.

Enter `quit` at any time to exit the program (if you're in-game, unsaved progress will be lost).

While in-game, `exit` will return you to the welcome screen (unsaved progress will be lost).

##Game Play

Play alternates between two players, with White going first. Only legal moves are allowed, and the active player does not change until a legal move has been made. The player is warned at the beginning of their turn if their opponent has put them in check.

See Wikipedia for an introduction to the [rules of chess](https://en.wikipedia.org/wiki/Chess#Rules).

###Basic Movement

Moves are entered in [standard chess notation](https://en.wikipedia.org/wiki/Algebraic_notation_(chess)). A move is indicated using the piece's initial, plus the coordinates of the destination square. For example, `Nf3` would move a knight to square f3.

The origin's coordinates may also be included to disambiguate if multiple pieces of the same type can move to the same square. 

For example, these commands would all perform the same move:  
`Ngf3` specifies moving the knight from the g-file to square f3.  
`N1f3` specifies moving the knight from the 1-rank to square f3.  
`N1gf3` specifies moving the knight from square g1 to f3.

Standard notation includes "x" if the piece makes a capture (e.g. Bxe5 = bishop captures the piece on e5), however it is not required in this program. `Bxe5` and `Be5` will be read the same way.  

As with other commands, movement is not case sensitive.

The piece initials are:  
P = pawn  
R = rook  
N = knight  
B = bishop  
Q = queen  
K = king

*Note: while the initial for pawns is usually optional in standard notation, it is required in this program.*

###Special Moves

[Castling](https://en.wikipedia.org/wiki/Castling) is performed with standard notation:  
Enter `0-0` or `O-O` to castle kingside.  
Enter `0-0-0` or `O-O-O` to castle queenside.

The pawn's opening double step, [en passant](https://en.wikipedia.org/wiki/En_passant), and promotion are all available. They are performed the same way as any other move.

###End Game

The game can end in four ways:
- Win
  - Checkmate
  - Resignation
- Draw
  - Stalemate
  - Draw by agreement

Checkmate and stalemate are determined automatically.

Enter `resign` to resign and concede the game to your opponent.

Enter `draw` to propose a draw.  You will get to make one more move, then on your opponent's turn they may either agree to or reject the draw. If they agree, the game ends with no winner. If they do not, play continues.

##Saving

In-progress games may be saved at any time by either player. Save files are stored in the "saves" directory (if this directory doesn't exist, it will be created on the first save).

Enter `save` to save over your most recent game (either the game you have just loaded or the game that was last saved). If no save files exist, one will be generated automatically.

Enter `save <name>` to save over a specific file of name `<name>`. If the file doesn't exist, a new file with that name will be created.

*Note: File names may not include spaces.*

Enter `show saves` to view a list of existing save files and the date they were last modified.


