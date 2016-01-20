module Help

	def help
		puts "\n*** Help Menu ***"
		puts "[1] Starting a Game"
		puts "[2] Basic Movement"
		puts "[3] Special Moves/Commands"
		puts "[4] Saving a Game"
		puts "[5] Misc Commands"
		puts "*** End ***"
		puts "[close] return to game"
		input = Readline.readline("help: ").downcase
		until input.to_i.between?(1,5) || input == "close" do
			puts "Invalid input. Enter a number or [close] to return to game."
			input = Readline.readline("help: ").downcase
		end
		case input.downcase
			when "1"
				start_game_commands
			when "2"
				movement_commands
			when "3"
				special_commands
			when "4"
				saving_commands
			when "5"
				misc_commands
		end
	end

	def movement_commands
		puts "\n*** Movement Commands ***"
		puts "Enter moves in standard chess notation; ie piece-rank-file. E.g:"
		puts "[Qg5] = queen moves to the g-file and 5th rank (square g5)"
		puts "If more than one piece can move to the destination square, disambiguate \nby including the origin's rank, file, or both. E.g:"
		puts "[Ngf3] or [N1f3] or [Ng1f3] = knight from the g-file/1-rank moves to square f3"
		puts "*** Piece Abbreviations ***"
		puts "[P] pawn"
		puts "[R] rook"
		puts "[N] knight"
		puts "[B] bishop"
		puts "[Q] queen"
		puts "[K] king"
		puts "*** End ***"
		puts "[back] back to menu"
		puts "[close] return to game"
		input = Readline.readline("help: ").downcase
		until input == "back" || input == "close" do
			puts "Invalid input. Enter [close] or [back]."
			input = Readline.readline("help: ").downcase
		end
		help if (input == "back")
	end

	def special_commands
		puts "\n*** Special Commands ***"
		puts "[draw] request a draw; the player who proposes the draw makes one more move, \nthen the opponent may either agree to the draw or reject it to continue play."
		puts "[resign] concede the game"
		puts "Castling is not available at this time."
		puts "*** End ***"
		puts "[back] back to menu"
		puts "[close] return to game"
		input = Readline.readline("help: ").downcase
		until input == "back" || input == "close" do
			puts "Invalid input. Enter [close] or [back]."
			input = Readline.readline("help: ").downcase
		end
		help if (input == "back")
	end

	def start_game_commands
		puts "\n*** Starting a Game ***"
		puts "[new] start a new game"
		puts "[load] show save list to select a game to load"
		puts "[load <name>] load game file <name>"
		puts "Games can only be started/loaded from the welcome screen."
		puts "*** End ***"
		puts "[back] back to menu"
		puts "[close] return to game"
		input = Readline.readline("help: ").downcase
		until input == "back" || input == "close" do
			puts "Invalid input. Enter [close] or [back]."
			input = Readline.readline("help: ").downcase
		end
		help if (input == "back")
	end

	def saving_commands
		puts "\n*** Saving a Game ***"
		puts "[save] save over game that was most recently saved or loaded"
		puts "[save <name>] create new save or overwrites <name> if it exists; save names may not include spaces"
		puts "[show saves] list existing save files"
		puts "Saving is only available in-game."
		puts "*** End ***"
		puts "[back] back to menu"
		puts "[close] return to game"
		input = Readline.readline("help: ").downcase
		until input == "back" || input == "close" do
			puts "Invalid input. Enter [close] or [back]."
			input = Readline.readline("help: ").downcase
		end
		help if (input == "back")
	end

	def misc_commands
		puts "\n*** Misc Commands ***"
		puts "[help] show help menu"
		puts "[exit] exit game and return to welcome screen; abandon unsaved progress"
		puts "[quit] quit program; abandon unsaved progress"
		puts "*** End ***"
		puts "[back] back to menu"
		puts "[close] return to game"
		input = Readline.readline("help: ").downcase
		until input == "back" || input == "close" do
			puts "Invalid input. Enter [close] or [back]."
			input = Readline.readline("help: ").downcase
		end
		help if (input == "back")
	end

end