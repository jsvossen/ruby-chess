require "./lib/ChessBoard"
require "./lib/ChessPiece"
require "./lib/ChessPlayer"
require "./lib/FileManager"
include FileManager
require "./lib/Help"
include Help

class ChessGame

	attr_writer :active
	attr_reader :board, :players, :white_set, :black_set

	def initialize(player1="Player 1",player2="Player 2")

		@players = [ChessPlayer.new(player1,:white), ChessPlayer.new(player2,:black)]
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

		@players[0].set = @white_set
		@players[1].set = @black_set

		reset_board
		#board.draw

		@gameover = false
		@winner = nil
		@active = @players[0]

		# until @gameover do
		# 	input = Readline.readline("#{@active.name}: ")
		# 	handle_input(input)
		# end
	end

	def reset_board

		#sort sets alphabecially
		@white_set.sort_by! { |piece| piece.class.to_s }
		@black_set.sort_by! { |piece| piece.class.to_s }

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

		@white_set.each { |piece| piece.captured = false; get_moves(piece); }
		@black_set.each { |piece| piece.captured = false; get_moves(piece); }

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
				resign(@active)
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

	def resign(player)
		@winner = @players.select { |p| p != player }.shift
		@gameover = true
		puts "#{player.name} has resigned!"
		puts "#{@winner.name} wins!"
	end

	def get_moves(piece)
		piece.moves = []

		if (piece.name == "P")
			case piece.color
				when :white
					next_sq = [piece.coord.x, piece.coord.y+2]
					piece.moves << next_sq if piece.coord.y == 2 && !@board.square(next_sq[0],next_sq[1]).occupant && !@board.square(next_sq[0],next_sq[1]-1).occupant
					next_sq = [piece.coord.x, piece.coord.y+1]
					piece.moves << next_sq if next_sq[1] <= 8 && !@board.square(next_sq[0],next_sq[1]).occupant
					diags = [[piece.coord.x+1, piece.coord.y+1], [piece.coord.x-1, piece.coord.y+1]]
					diags.each do |d|
						piece.moves << d if d[0].between?(1,8) && d[1].between?(1,8) && @board.square(d[0],d[1]).occupant && @board.square(d[0],d[1]).occupant.color != piece.color
					end
				when :black
					next_sq = [piece.coord.x, piece.coord.y-2]
					piece.moves << next_sq if piece.coord.y == 7 && !@board.square(next_sq[0],next_sq[1]).occupant
					next_sq = [piece.coord.x, piece.coord.y-1]
					piece.moves << next_sq if next_sq[1] > 0 && !@board.square(next_sq[0],next_sq[1]).occupant
					diags = [[piece.coord.x-1, piece.coord.y-1], [piece.coord.x+1, piece.coord.y-1]]
					diags.each { |d| piece.moves << d if d[0].between?(1,8) && d[1].between?(1,8) && @board.square(d[0],d[1]).occupant && @board.square(d[0],d[1]).occupant.color != piece.color }
			end
						
		elsif (piece.name == "N")
			next_sq = [
				[piece.coord.x-2, piece.coord.y+1],
				[piece.coord.x-1, piece.coord.y+2],
				[piece.coord.x+1, piece.coord.y+2],
				[piece.coord.x+2, piece.coord.y+1],
				[piece.coord.x+2, piece.coord.y-1],
				[piece.coord.x+1, piece.coord.y-2],
				[piece.coord.x-2, piece.coord.y-1],
				[piece.coord.x-1, piece.coord.y-2]
			]
			next_sq.each do |sq| 
				if sq[0].between?(1,8) && sq[1].between?(1,8)
					piece.moves << sq if !(@board.square(sq[0],sq[1]).occupant && @board.square(sq[0],sq[1]).occupant.color == piece.color)
				end	
			end			

		elsif (piece.name == "K")
			next_sq = [
				[piece.coord.x+1, piece.coord.y],
				[piece.coord.x-1, piece.coord.y],
				[piece.coord.x, piece.coord.y+1],
				[piece.coord.x, piece.coord.y-1],
				[piece.coord.x+1, piece.coord.y+1],
				[piece.coord.x-1, piece.coord.y-1],
				[piece.coord.x+1, piece.coord.y-1],
				[piece.coord.x-1, piece.coord.y+1]
			]

		end
	end

	def decode_move(input)
		input = input.tr("x","").split(//)
		move = {}
		move[:piece] = input.shift
		move[:x1] = nil
		move[:y1] = nil
		if ( input.length == 4 )
			move[:x1] = ChessBoard::CHAR_RANGE.index(input.shift)+1
			move[:y1] = input.shift.to_i
		elsif ( input.length == 3 )
			if input[0].to_i > 0
				move[:y1] = input.shift.to_i
			else
				move[:x1] = ChessBoard::CHAR_RANGE.index(input.shift)+1
			end
		end
		move[:x2] = ChessBoard::CHAR_RANGE.index(input.shift)+1
		move[:y2] = input.shift.to_i
		move
	end

	def move(piece,x2,y2,x1=nil,y1=nil)
		movable = @active.set.select { |p| p.name == piece }
		movable.each { |p| get_moves(p) }
		movable.select! { |p| p.moves.include?([x2,y2]) }
		movable.select! { |p| p.coord.x == x1 } if x1
		movable.select! { |p| p.coord.y == y1 } if y1
		if ( movable.size > 1 )
			puts "Ambiguous command! Multiple pieces can move to #{ChessBoard::CHAR_RANGE[x2-1]}#{y2}."
			return false
		elsif (movable.size == 0 )
			puts "Illegal move!"
			return false
		else
			movable[0].coord = nil
			if (@board.square(x2,y2).occupant)
				@board.square(x2,y2).occupant.captured = true
				@board.square(x2,y2).occupant = nil
			end
			movable[0].coord = @board.square(x2,y2)
		end
	end

end