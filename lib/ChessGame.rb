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
			@white_set << Pawn.new(:white)
			@black_set << Pawn.new(:black)
		end
		2.times do
			@white_set << Rook.new(:white)
			@white_set << Knight.new(:white)
			@white_set << Bishop.new(:white)
			@black_set << Rook.new(:black)
			@black_set << Knight.new(:black)
			@black_set << Bishop.new(:black)
		end
		@white_set << Queen.new(:white)
		@white_set << King.new(:white)
		@black_set << Queen.new(:black)
		@black_set << King.new(:black)

		@players[0].set = @white_set
		@players[1].set = @black_set

		reset_board

		@gameover = false
		@winner = nil
		@active = @players[0]

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


	def play
		until @gameover do
			board.draw
			input = Readline.readline("#{@active.name}: ")
			until handle_input(input) do
				input = Readline.readline("#{@active.name}: ")
			end
			@active = @players[@players.index(@active)-1]
		end
	end


	def handle_input(input)
		case input.downcase
			when "save", /^save\s\w+$/
				file = input.split[1]
				FileManager.save_game(self,file)
				return false

			when "show saves"
				puts "***Saved Games***"
				FileManager.list_saves
				puts "***End***"
				return false

			when /^[pkqrnb][a-h]?[1-8]?x?[a-h][1-8]/
				m = decode_move(input)
				move(m[:piece],m[:x2],m[:y2],m[:x1],m[:y1])

			when "resign"
				resign(@active)

			when "help"
				Help.help
				@board.draw
				return false

			when "quit", "exit"
				puts "Goodbye!"
				exit

			else
				puts "Invalid input. Enter [help] for commands."
				return false
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
					diags.each { |d| piece.moves << d if d[0].between?(1,8) && d[1].between?(1,8) && @board.square(d[0],d[1]).alignment == :black }
				when :black
					next_sq = [piece.coord.x, piece.coord.y-2]
					piece.moves << next_sq if piece.coord.y == 7 && !@board.square(next_sq[0],next_sq[1]).occupant
					next_sq = [piece.coord.x, piece.coord.y-1]
					piece.moves << next_sq if next_sq[1] > 0 && !@board.square(next_sq[0],next_sq[1]).occupant
					diags = [[piece.coord.x-1, piece.coord.y-1], [piece.coord.x+1, piece.coord.y-1]]
					diags.each { |d| piece.moves << d if d[0].between?(1,8) && d[1].between?(1,8) && @board.square(d[0],d[1]).alignment == :white }
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
			next_sq.each { |sq|  piece.moves << sq if sq[0].between?(1,8) && sq[1].between?(1,8) && @board.square(sq[0],sq[1]).alignment != piece.color }		

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
			next_sq.each { |sq|  piece.moves << sq if sq[0].between?(1,8) && sq[1].between?(1,8) && @board.square(sq[0],sq[1]).alignment != piece.color }

		elsif (piece.name == "R")
			x, y = piece.coord.x, piece.coord.y
			(x+1).upto(8) do |nx|
				piece.moves << [nx,y] if @board.square(nx,y).alignment != piece.color
				break if @board.square(nx,y).occupant
			end
			(x-1).downto(1) do |nx|
				piece.moves << [nx,y] if @board.square(nx,y).alignment != piece.color
				break if @board.square(nx,y).occupant
			end
			(y+1).upto(8) do |ny|
				piece.moves << [x,ny] if @board.square(x,ny).alignment != piece.color
				break if @board.square(x,ny).occupant
			end
			(y-1).downto(1) do |ny|
				piece.moves << [x,ny] if @board.square(x,ny).alignment != piece.color
				break if @board.square(x,ny).occupant
			end

		elsif (piece.name == "B")
			nx, ny = piece.coord.x, piece.coord.y
			while nx < 8 && ny < 8 do
				nx += 1
				ny += 1
				piece.moves << [nx, ny] if @board.square(nx,ny).alignment != piece.color
				break if @board.square(nx,ny).occupant
			end
			nx, ny = piece.coord.x, piece.coord.y
			while nx > 1 && ny > 1 do
				nx -= 1
				ny -= 1
				piece.moves << [nx, ny] if @board.square(nx,ny).alignment != piece.color
				break if @board.square(nx,ny).occupant
			end
			nx, ny = piece.coord.x, piece.coord.y
			while nx > 1 && ny < 8 do
				nx -= 1
				ny += 1
				piece.moves << [nx, ny] if @board.square(nx,ny).alignment != piece.color
				break if @board.square(nx,ny).occupant
			end
			nx, ny = piece.coord.x, piece.coord.y
			while nx < 8 && ny > 1 do
				nx += 1
				ny -= 1
				piece.moves << [nx, ny] if @board.square(nx,ny).alignment != piece.color
				break if @board.square(nx,ny).occupant
			end

		elsif (piece.name == "Q")
			#vertical and horizontal
			x, y = piece.coord.x, piece.coord.y
			(x+1).upto(8) do |nx|
				piece.moves << [nx,y] if @board.square(nx,y).alignment != piece.color
				break if @board.square(nx,y).occupant
			end
			(x-1).downto(1) do |nx|
				piece.moves << [nx,y] if @board.square(nx,y).alignment != piece.color
				break if @board.square(nx,y).occupant
			end
			(y+1).upto(8) do |ny|
				piece.moves << [x,ny] if @board.square(x,ny).alignment != piece.color
				break if @board.square(x,ny).occupant
			end
			(y-1).downto(1) do |ny|
				piece.moves << [x,ny] if @board.square(x,ny).alignment != piece.color
				break if @board.square(x,ny).occupant
			end
			#diagonals
			nx, ny = x, y
			while nx < 8 && ny < 8 do
				nx += 1
				ny += 1
				piece.moves << [nx, ny] if @board.square(nx,ny).alignment != piece.color
				break if @board.square(nx,ny).occupant
			end
			nx, ny = x, y
			while nx > 1 && ny > 1 do
				nx -= 1
				ny -= 1
				piece.moves << [nx, ny] if @board.square(nx,ny).alignment != piece.color
				break if @board.square(nx,ny).occupant
			end
			nx, ny = x, y
			while nx > 1 && ny < 8 do
				nx -= 1
				ny += 1
				piece.moves << [nx, ny] if @board.square(nx,ny).alignment != piece.color
				break if @board.square(nx,ny).occupant
			end
			nx, ny = x, y
			while nx < 8 && ny > 1 do
				nx += 1
				ny -= 1
				piece.moves << [nx, ny] if @board.square(nx,ny).alignment != piece.color
				break if @board.square(nx,ny).occupant
			end
		end
	end


	def decode_move(input)
		input = input.tr("x","").split(//)
		move = {}
		move[:piece] = input.shift.upcase
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
		movable = @active.set.select { |p| p.name == piece && !p.captured }
		movable.each { |p| get_moves(p) }
		movable.select! { |p| p.moves.include?([x2,y2]) }
		movable.select! { |p| p.coord.x == x1 } if x1
		movable.select! { |p| p.coord.y == y1 } if y1
		if ( movable.size > 1 )
			puts "Ambiguous command! Multiple #{ChessPiece::CODEX[piece.upcase]}s can move to #{ChessBoard::CHAR_RANGE[x2-1]}#{y2}."
			return false
		elsif (movable.size == 0 )
			puts "Illegal move!"
			return false
		else
			if (@board.square(x2,y2).occupant)
				@board.square(x2,y2).occupant.captured = true
				@board.square(x2,y2).occupant = nil
			end
			movable[0].coord = @board.square(x2,y2)
			if (movable[0].is_a?(Pawn) && movable[0].name == "P" && ( (movable[0].color == :white && y2 == 8) || (movable[0].color == :black && y2 == 1) ) )
				puts "#{@active.name}..."
				movable[0].promote
			end
			return true
		end
	end


end