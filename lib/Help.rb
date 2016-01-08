module Help

	def help
		puts "***Help Menu***"
		puts "[1] Movement Commands"
		puts "[2] Misc Commands"
		puts "[back] return to game"
		input = Readline.readline("help: ")
		until input == "1" || input == "2" || input.downcase == "back" do
			puts "Invalid input. Enter [1], [2], or [back] to return to game."
			input = Readline.readline("help: ")
		end
		case input.downcase
			when "1"
				movement
			when "2"
				misc
		end
	end

	def movement
		puts "***Movement Commands***"
		puts "Enter moves in standard chess notation; ie piece-rank-file. E.g:"
		puts "[Qg5] = queen moves to the g-file and 5th rank (square g5)"
		puts "If more than one piece can move to the destination square, disambiguate by including the origin's rank, file, or both. E.g:"
		puts "[Ngf3] = knight from the g-file moves to the square f3"
		puts "***Piece Abbreviations***"
		puts "[P] pawn"
		puts "[R] rook"
		puts "[N] knight"
		puts "[B] bishop"
		puts "[Q] queen"
		puts "[K] king"
		puts "***End***"
		puts "[back] previous menu"
		input = Readline.readline("help: ")
		until input.downcase == "back" do
			puts "Invalid input. Enter [back] to return to previous menu."
			input = Readline.readline("help: ")
		end
		help
	end

	def misc
		puts "***Misc Commands***"
		puts "[save] save over most recent saved game"
		puts "[save <name>] create new save or overwrites <name> if it exists"
		puts "[resign] concede the game"
		puts "[help] show help menu"
		puts "[quit] or [exit] exit game; abandon unsaved progress"
		puts "***End***"
		puts "[back] previous menu"
		input = Readline.readline("help: ")
		until input.downcase == "back" do
			puts "Invalid input. Enter [back] to return to previous menu."
			input = Readline.readline("help: ")
		end
		help
	end
end