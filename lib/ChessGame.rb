require "./lib/ChessBoard"
require "./lib/ChessPiece"
require "./lib/ChessPlayer"
require "./lib/FileManager"
include FileManager
require "./lib/Help"
include Help

class ChessGame

	attr_reader :board, :players, :white_set, :black_set

	def initialize(player1="Player 1",player2="Player 2")

		@player = [ChessPlayer.new(player1,:white), ChessPlayer.new(player2,:black)]
		@board = ChessBoard.new

		@white_set = []
		@black_set = []

		8.times do
			@white_set << Pawn.new("P",:white)
			@black_set << Pawn.new("P",:black)
		end
		2.times do
			@white_set << Rook.new("R",:white)
			@white_set << Knight.new("N",:white)
			@white_set << Bishop.new("B",:white)
			@black_set << Rook.new("R",:black)
			@black_set << Knight.new("N",:black)
			@black_set << Bishop.new("B",:black)
		end
		@white_set << Queen.new("Q",:white)
		@white_set << King.new("K",:white)
		@black_set << Queen.new("Q",:black)
		@black_set << King.new("K",:black)

		@player[0].set = @white_set
		@player[1].set = @black_set

		reset_board
		board.draw

		gameover = false
		@active = @player[0]

		until gameover do
			input = Readline.readline("#{@active.name}: ")
			handle_input(input)
		end
	end

	def reset_board

		#sort sets alphabecially
		@white_set.sort_by! { |piece| piece.name }
		@black_set.sort_by! { |piece| piece.name }

		#bishops
		@white_set[0].coord = @board.square(3,1)
		@white_set[1].coord = @board.square(6,1)
		@black_set[0].coord = @board.square(3,8)
		@black_set[1].coord = @board.square(6,8)

		#king
		@white_set[2].coord = @board.square(5,1)
		@black_set[2].coord = @board.square(5,8)

		#knights
		@white_set[3].coord = @board.square(2,1)
		@white_set[4].coord = @board.square(7,1)
		@black_set[3].coord = @board.square(2,8)
		@black_set[4].coord = @board.square(7,8)

		#pawns
		@white_set[5..12].each_with_index { |pawn,i| pawn.coord = @board.square(i-4,2) }
		@black_set[5..12].each_with_index { |pawn,i| pawn.coord = @board.square(i-4,7) }

		#queen
		@white_set[13].coord = @board.square(4,1)
		@black_set[13].coord = @board.square(4,8)

		#rooks
		@white_set[14].coord = @board.square(1,1)
		@white_set[15].coord = @board.square(8,1)
		@black_set[14].coord = @board.square(1,8)
		@black_set[15].coord = @board.square(8,8)

		@white_set.each { |piece| piece.captured = false }
		@black_set.each { |piece| piece.captured = false }

	end

	def handle_input(input)
		case input.downcase
			when "save", /^save\s\w+$/
				file = input.split[1]
				FileManager.save_game(self,file)
			when "show saves"
				puts "***Saved Games***"
				FileManager.list_saves
				puts "***End***"
			when /^[pkqrnb][a-h]?[1-8]?x?[a-h][1-8]/
				#process move
			when "resign"
				#player resigns
			when "help"
				Help.help
				@board.draw
			when "quit", "exit"
				puts "Goodbye!"
				exit
			else
				puts "Invalid input. Enter [help] for commands."
				input = Readline.readline("#{@active.name}: ")
				handle_input(input)
		end
	end
end