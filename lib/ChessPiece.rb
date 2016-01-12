class ChessPiece

	attr_accessor :captured, :moves
	attr_reader :name, :color, :symbol, :coord

	def initialize(name,color)
		@name = name
		@color = color
		@symbol = nil
		@coord = nil
		@moves = []
		@captured = false
	end

	def coord= coord
		prev = @coord
		@coord = coord
		prev.occupant = nil if prev!=nil && !coord
		@coord.occupant = self if @coord && @coord.occupant != self
	end

end

class Pawn < ChessPiece

	def initialize(name,color)
		super(name, color)
		@color == :white ? @symbol = "\u2659".encode('utf-8') : @symbol = "\u265F".encode('utf-8')
	end

end

class Knight < ChessPiece

	def initialize(name,color)
		super(name, color)
		@color == :white ? @symbol = "\u2658".encode('utf-8') : @symbol = "\u265E".encode('utf-8')
	end

end

class Bishop < ChessPiece

	def initialize(name,color)
		super(name, color)
		@color == :white ? @symbol = "\u2657".encode('utf-8') : @symbol = "\u265D".encode('utf-8')
	end

end

class Rook < ChessPiece

	def initialize(name,color)
		super(name, color)
		@color == :white ? @symbol = "\u2656".encode('utf-8') : @symbol = "\u265C".encode('utf-8')
	end

end

class Queen < ChessPiece

	def initialize(name,color)
		super(name, color)
		@color == :white ? @symbol = "\u2655".encode('utf-8') : @symbol = "\u265B".encode('utf-8')
	end

end

class King < ChessPiece

	def initialize(name,color)
		super(name, color)
		@color == :white ? @symbol = "\u2654".encode('utf-8') : @symbol = "\u265A".encode('utf-8')
	end

end