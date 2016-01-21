require "./lib/ChessBoard"
require "./lib/ChessPiece"
require "./lib/ChessPlayer"
require "./lib/FileManager"
include FileManager
require "./lib/Help"
include Help

class ChessGame

	attr_accessor :active
	attr_reader :board, :players, :white_set, :black_set

	def initialize(player1="White",player2="Black")

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
		@white_set[5..12].each_with_index { |pawn,i| pawn.coord = @board.square(i-4,2); pawn.demote; }
		@black_set[5..12].each_with_index { |pawn,i| pawn.coord = @board.square(i-4,7); pawn.demote; }

		#queen
		@white_set[13].coord = @board.square(4,1)
		@black_set[13].coord = @board.square(4,8)

		#rooks
		@white_set[14].coord = @board.square(1,1)
		@white_set[15].coord = @board.square(8,1)
		@black_set[14].coord = @board.square(1,8)
		@black_set[15].coord = @board.square(8,8)

		@white_set.each { |piece| piece.captured = false; }
		@black_set.each { |piece| piece.captured = false; }

	end


	def opponent(player=@active)
		@players[@players.index(player)-1]
	end

	#main gameplay loop
	def play
		board.draw
		until gameover? do
			input = Readline.readline("#{@active.name}: ")
			until handle_input(input) do
				input = Readline.readline("#{@active.name}: ")
			end

			break if input.downcase == "exit"
			board.draw if input.downcase != "resign"

			@active = opponent
			puts "#{@active.name} is in check!" if check? && !checkmate?
			request_draw if opponent.draw
		end
		print_results
	end


	def print_results
		if checkmate?
			puts "Checkmate!"
			@winner = opponent
		else
			puts "Stalemate! #{@active.name} has no moves." if stalemate?
			puts "The game is a draw!" if draw? || stalemate?
		end
		puts "#{@winner.name} wins!" if @winner
	end


	#process possible user input
	def handle_input(input)
		case input.downcase
			when "save", /^save\s\w+$/
				file = input.split[1]
				FileManager.save_game(self,file)
				return false

			when "show saves"
				puts "\n***Saved Games***"
				FileManager.list_saves
				puts "***End***"
				return false

			when /^[pkqrnb][a-h]?[1-8]?x?[a-h][1-8]/
				m = decode_move(input)
				move(m[:piece],m[:x2],m[:y2],m[:x1],m[:y1])

			when "o-o", "0-0"
				castle_ks

			when "o-o-o", "0-0-0"
				castle_qs

			when "resign"
				resign(@active)
				return true

			when "draw"
				@active.draw = true
				puts "You have requested a draw. Make one last move: "
				return false

			when "help"
				Help.help
				@board.draw
				return false

			when "exit"
				puts "Exiting game..."
				return true

			when "quit"
				puts "Goodbye!"
				exit

			when "get ye flask"
				puts "You cannot get ye flask."
				return false

			else
				puts "Invalid input. Enter [help] for commands."
				return false
		end
	end


	def resign(player)
		@winner = @players.select { |p| p != player }.shift
		puts "#{player.name} has resigned!"
	end


	def gameover?
		checkmate? || stalemate? || draw? || @winner
	end

	#player is in check and all active pieces have no moves
	def checkmate?(player=@active)
		in_play = player.set.select { |p| p.in_play? }
		check?(player) && in_play.all? { |p| get_moves(p).empty?  }
	end

	#player is not in check but all active pieces have no moves
	def stalemate?(player=@active)
		in_play = player.set.select { |p| p.in_play? }
		in_play.all? { |p| get_moves(p).empty? } && !check?(player)
	end


	def draw?
		@players.all? { |p| p.draw }
	end

	def request_draw
		puts "#{opponent.name} has request a draw."
		input = Readline.readline("#{@active.name}, agree to a draw? ").downcase
		until input=="y" || input=="yes" || input=="n" || input=="no" do
			input = Readline.readline("#{@active.name}, agree to a draw? Yes or no: ").downcase
		end
		if (input == "y" || input == "yes")
			@active.draw = true
		else
			puts "Draw rejected."
			opponent.draw = false
		end
	end


	def get_moves(piece,ox=nil, oy=nil)
		moves = [] 

		return moves if !piece.coord && !ox && !oy
		ox = piece.coord.x if !ox
		oy = piece.coord.y if !oy

		#pawn
		if (piece.name == "P")
			case piece.color
				when :white
					moves << [ox,oy+2] if piece.coord.y == 2 && !@board.square(ox,oy+2).occupant && !@board.square(ox,oy+1).occupant
					moves << [ox,oy+1] if oy+1 <= 8 && !@board.square(ox,oy+1).occupant
					diags = [[ox+1, oy+1], [ox-1, oy+1]]
					diags.each { |d| moves << d if d[0].between?(1,8) && d[1].between?(1,8) && @board.square(d[0],d[1]).alignment == :black }
				when :black
					moves << [ox,oy-2] if piece.coord.y == 7 && !@board.square(ox,oy-2).occupant && !@board.square(ox,oy-1).occupant
					moves << [ox,oy-1] if oy-1 > 0 && !@board.square(ox,oy-1).occupant
					diags = [[ox-1, oy-1], [ox+1, oy-1]]
					diags.each { |d| moves << d if d[0].between?(1,8) && d[1].between?(1,8) && @board.square(d[0],d[1]).alignment == :white }
			end
		
		#knight				
		elsif (piece.name == "N")
			next_sq = [
				[ox-2, oy+1],
				[ox-1, oy+2],
				[ox+1, oy+2],
				[ox+2, oy+1],
				[ox+2, oy-1],
				[ox+1, oy-2],
				[ox-2, oy-1],
				[ox-1, oy-2]
			]
			next_sq.each { |sq|  moves << sq if sq[0].between?(1,8) && sq[1].between?(1,8) && @board.square(sq[0],sq[1]).alignment != piece.color }		

		#king
		elsif (piece.name == "K")
			next_sq = [
				[ox+1, oy],
				[ox-1, oy],
				[ox, oy+1],
				[ox, oy-1],
				[ox+1, oy+1],
				[ox-1, oy-1],
				[ox+1, oy-1],
				[ox-1, oy+1]
			]
			next_sq.each { |sq|  moves << sq if sq[0].between?(1,8) && sq[1].between?(1,8) && @board.square(sq[0],sq[1]).alignment != piece.color }

		else

			#orthagonal moves (rook or queen)
			if (piece.name == "R" || piece.name == "Q")
				(ox+1).upto(8) do |nx|
					moves << [nx,oy] if @board.square(nx,oy).alignment != piece.color
					break if @board.square(nx,oy).occupant
				end
				(ox-1).downto(1) do |nx|
					moves << [nx,oy] if @board.square(nx,oy).alignment != piece.color
					break if @board.square(nx,oy).occupant
				end
				(oy+1).upto(8) do |ny|
					moves << [ox,ny] if @board.square(ox,ny).alignment != piece.color
					break if @board.square(ox,ny).occupant
				end
				(oy-1).downto(1) do |ny|
					moves << [ox,ny] if @board.square(ox,ny).alignment != piece.color
					break if @board.square(ox,ny).occupant
				end
			end

			#diagonal moves (bishop or queen)
			if (piece.name == "B" || piece.name == "Q")
				nx, ny = ox, oy
				while nx < 8 && ny < 8 do
					nx += 1
					ny += 1
					moves << [nx, ny] if @board.square(nx,ny).alignment != piece.color
					break if @board.square(nx,ny).occupant
				end
				nx, ny = ox, oy
				while nx > 1 && ny > 1 do
					nx -= 1
					ny -= 1
					moves << [nx, ny] if @board.square(nx,ny).alignment != piece.color
					break if @board.square(nx,ny).occupant
				end
				nx, ny = ox, oy
				while nx > 1 && ny < 8 do
					nx -= 1
					ny += 1
					moves << [nx, ny] if @board.square(nx,ny).alignment != piece.color
					break if @board.square(nx,ny).occupant
				end
				nx, ny = ox, oy
				while nx < 8 && ny > 1 do
					nx += 1
					ny -= 1
					moves << [nx, ny] if @board.square(nx,ny).alignment != piece.color
					break if @board.square(nx,ny).occupant
				end
			end
		end

		#prevent active player from moving into check
		moves.select! { |m| !vulnerable_move?(piece,m[0],m[1]) } if piece.color == @active.color

		if (ox == piece.coord.x && oy == piece.coord.y)
			piece.moves = moves
		else
			moves
		end

	end


	#process chess notation
	def decode_move(input)
		input = input.tr("x","").split(//) #capture notation "x" is optional
		move = {}
		move[:piece] = input.shift.upcase
		move[:x1] = nil
		move[:y1] = nil
		if ( input.length == 4 ) #e.g. g1f3
			move[:x1] = ChessBoard::CHAR_RANGE.index(input.shift.downcase)+1
			move[:y1] = input.shift.to_i
		elsif ( input.length == 3 )  #e.g. gf3
			if input[0].to_i > 0
				move[:y1] = input.shift.to_i
			else
				move[:x1] = ChessBoard::CHAR_RANGE.index(input.shift.downcase)+1
			end
		end
		move[:x2] = ChessBoard::CHAR_RANGE.index(input.shift.downcase)+1
		move[:y2] = input.shift.to_i
		move
	end


	def move(piece,x2,y2,x1=nil,y1=nil)
		movable = @active.set.select { |p| p.name == piece && !p.captured } #get pieces that haven't been captured
		movable.each { |p| get_moves(p) } #see what moves each piece has
		movable.select! { |p| p.moves.include?([x2,y2]) } #select pieces that include designated coordinates
		movable.select! { |p| p.coord.x == x1 } if x1 #disambiguate if file given
		movable.select! { |p| p.coord.y == y1 } if y1 #disambiguate if rank given
		if ( movable.size > 1 )
			puts "Ambiguous command! Multiple #{ChessPiece::CODEX[piece.upcase]}s can move to #{ChessBoard::CHAR_RANGE[x2-1]}#{y2}."
			return false
		elsif (movable.size == 0 )
			puts "Illegal move!"
			return false
		else
			@board.square(x2,y2).occupant.captured = true if @board.square(x2,y2).occupant #capture piece if destination is occupied
			movable[0].coord = @board.square(x2,y2) #move the piece
			#promote pawn as appropriate
			if (movable[0].name == "P" && ( (movable[0].color == :white && y2 == 8) || (movable[0].color == :black && y2 == 1) ) )
				puts "#{@active.name}..."
				movable[0].promote
			end
			movable[0].castle = false if movable[0].class.to_s == "King" || movable[0].class.to_s == "Rook"
			return true
		end
	end

	#player is in check if any opponent piece can move to the king's coordinates
	def check?(player=@active)
		king = player.set.select { |p| p.name == "K"}.first
		opponent(player).set.each do |piece|
			if ( piece.in_play? )
				get_moves(piece)
				if (piece.moves.include? [king.coord.x, king.coord.y])
					return true
				end
			end
		end
		return false
	end


	#will hypothetical move of piece to (x,y) leave king vulnerable?
	def vulnerable_move?(piece,x,y)
		ox, oy = piece.coord.x, piece.coord.y
		dest = @board.square(x,y)
		captive = dest.occupant
		player = @players.select { |p| p.color == piece.color }

		piece.coord = dest
		vulnerable = check?(player[0])

		#reset hypothetical move
		piece.coord = @board.square(ox,oy)
		captive.coord = dest if captive

		vulnerable
	end

	#castle kingside
	def castle_ks(player=@active)
		king = player.set.select { |p| p.name == "K" && p.castle }.first
		rook = player.set.select { |p| p.name == "R" && p.castle && p.in_play? && p.coord.x == 8 }.first
		if (check?(player) || !king || !rook)
			puts "Illegal move!"
			return false
		end
		y = king.coord.y
		path = [[7,y], [6,y]]
		if (path.any? { |sq| vulnerable_move?(king,sq[0],sq[1]) || @board.square(sq[0],sq[1]).occupant })
			puts "Illegal move!"
			return false
		else
			king.coord = @board.square(7,y)
			rook.coord = @board.square(6,y)
			king.castle = false
			rook.castle = false
			return true
		end
	end

	#castle queenside
	def castle_qs(player=@active)
		king = player.set.select { |p| p.name == "K" && p.castle }.first
		rook = player.set.select { |p| p.name == "R" && p.castle && p.in_play? && p.coord.x == 1 }.first
		if (check?(player) || !king || !rook)
			puts "Illegal move!"
			return false
		end
		y = king.coord.y
		path = [[2,y], [3,y], [4,y]]
		if (path.any? { |sq| @board.square(sq[0],sq[1]).occupant } || path[1..-1].any? { |sq| vulnerable_move?(king,sq[0],sq[1]) })
			puts "Illegal move!"
			return false
		else
			king.coord = @board.square(3,y)
			rook.coord = @board.square(4,y)
			king.castle = false
			rook.castle = false
			return true
		end
	end


end