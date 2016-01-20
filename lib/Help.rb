module Help

	def help
		puts "\n*** Help Menu ***"
		puts "[1] How to Play"
		puts "[2] Misc Commands"
		puts "[close] return to game"
		input = Readline.readline("help: ").downcase
		until input == "1" || input == "2" || input == "close" do
			puts "Invalid input. Enter [1], [2], or [close] to return to game."
			input = Readline.readline("help: ").downcase
		end
		case input.downcase
			when "1"
				play_menu
			when "2"
				misc_menu
		end
	end

	def play_menu
		puts "\n*** How to Play ***"
		puts "[1] Moving Pieces"
		puts "[2] Special Commands"
		puts "*** End ***"
		puts "[back] previous menu"
		puts "[close] return to game"
		input = Readline.readline("help: ").downcase
		until input == "1" || input == "2" || input == "back" do
			puts "Invalid input. Enter [1], [2], [close], or [back]."
			input = Readline.readline("help: ").downcase
		end
		case input
			when "1"
				movement
			when "2"
				special
			when "back"
				help
		end
	end

	def movement
		puts "\n*** Movement Commands ***"
		puts "Enter moves in standard chess notation; ie piece-rank-file. E.g:"
		puts "[Qg5] = queen moves to the g-file and 5th rank (square g5)"
		puts "If more than one piece can move to the destination square, disambiguate \nby including the origin's rank, file, or both. E.g:"
		puts "[Ngf3] = knight from the g-file moves to the square f3"
		puts "*** Piece Abbreviations ***"
		puts "[P] pawn"
		puts "[R] rook"
		puts "[N] knight"
		puts "[B] bishop"
		puts "[Q] queen"
		puts "[K] king"
		puts "*** End ***"
		puts "[back] previous menu"
		puts "[close] return to game"
		input = Readline.readline("help: ").downcase
		until input == "back" || input == "close" do
			puts "Invalid input. Enter [close] or [back]."
			input = Readline.readline("help: ").downcase
		end
		play_menu if (input == "back")
	end

	def special
		puts "\n*** Special Commands ***"
		puts "[draw] request a draw; the player who proposes the draw makes one more move, \nthen the opponent may either agree to the draw or reject it to continue play."
		puts "[resign] concede the game"
		puts "Castling is not available at this time."
		puts "*** End ***"
		puts "[back] previous menu"
		puts "[close] return to game"
		input = Readline.readline("help: ").downcase
		until input == "back" || input == "close" do
			puts "Invalid input. Enter [close] or [back]."
			input = Readline.readline("help: ").downcase
		end
		play_menu if (input == "back")
	end

	def misc_menu
		puts "\n*** Misc Commands ***"
		puts "[1] out-of-game commands"
		puts "[2] in-game commands"
		puts "*** End ***"
		puts "[back] previous menu"
		puts "[close] return to game"
		input = Readline.readline("help: ").downcase
		until input == "1" || input == "2" || input == "back" || input == "close" do
			puts "Invalid input. Enter [1], [2], [close], or [back]."
			input = Readline.readline("help: ").downcase
		end
		case input.downcase
			when "1"
				misc_oo_game
			when "2"
				misc_in_game
			when "back"
				help
		end
	end

	def misc_oo_game
		puts "\n*** Out-of-Game Commands ***"
		puts "[new] start a new game"
		puts "[load] show save list to select a game to load"
		puts "[load <name>] load game file <name>"
		puts "[help] show help menu"
		puts "[quit] or [exit] exit program"
		puts "*** End ***"
		puts "[back] previous menu"
		puts "[close] return to game"
		input = Readline.readline("help: ").downcase
		until input == "back" || input == "close" do
			puts "Invalid input. Enter [close] or [back]."
			input = Readline.readline("help: ").downcase
		end
		misc_menu if (input == "back")
	end

	def misc_in_game
		puts "\n*** In-Game Commands ***"
		puts "[save] save over game that was most recently saved or loaded"
		puts "[save <name>] create new save or overwrites <name> if it exists; save names may not include spaces"
		puts "[show saves] list existing save files"
		puts "[help] show help menu"
		puts "[exit] exit game and return to main menu; abandon unsaved progress"
		puts "[quit] quit program; abandon unsaved progress"
		puts "*** End ***"
		puts "[back] previous menu"
		puts "[close] return to game"
		input = Readline.readline("help: ").downcase
		until input == "back" || input == "close" do
			puts "Invalid input. Enter [close] or [back]."
			input = Readline.readline("help: ").downcase
		end
		misc_menu if (input == "back")
	end
end