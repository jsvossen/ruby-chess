class ChessPiece

	attr_accessor :coord
	attr_reader :name, :color, :symbol, :moves

	def initialize(name,color,coord)
		@name = name
		@color = color
		@coord = coord
		@symbol
		@coord
		@moves
	end

	def p
		print @symbol
	end

end

class Pawn < ChessPiece

	def initialize(name,color,coord)
		super(name, color, coord)
		@color == "white" ? @symbol = "\u2659".encode('utf-8') : @symbol = "\u265F".encode('utf-8')
		#calculate moves
	end

end

class Knight < ChessPiece

	def initialize(name,color,coord)
		super(name, color, coord)
		@color == "white" ? @symbol = "\u2658".encode('utf-8') : @symbol = "\u265E".encode('utf-8')
		#calculate moves
	end

end

class Bishop < ChessPiece

	def initialize(name,color,coord)
		super(name, color, coord)
		@color == "white" ? @symbol = "\u2657".encode('utf-8') : @symbol = "\u265D".encode('utf-8')
		#calculate moves
	end

end

class Rook < ChessPiece

	def initialize(name,color,coord)
		super(name, color, coord)
		@color == "white" ? @symbol = "\u2656".encode('utf-8') : @symbol = "\u265C".encode('utf-8')
		#calculate moves
	end

end

class Queen < ChessPiece

	def initialize(name,color,coord)
		super(name, color, coord)
		@color == "white" ? @symbol = "\u2655".encode('utf-8') : @symbol = "\u265B".encode('utf-8')
		#calculate moves
	end

end

class King < ChessPiece

	def initialize(name,color,coord)
		super(name, color, coord)
		@color == "white" ? @symbol = "\u2654".encode('utf-8') : @symbol = "\u265A".encode('utf-8')
		#calculate moves
	end

end