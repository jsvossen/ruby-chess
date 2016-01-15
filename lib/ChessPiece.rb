class ChessPiece

	CODEX = {
		"P" => "pawn",
		"N" => "knight",
		"B" => "bishop",
		"R" => "rook",
		"Q" => "queen",
		"K" => "king"
	}

	attr_accessor :captured, :moves
	attr_reader :name, :color, :symbol, :coord

	def initialize(color)
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
		prev.occupant = nil if prev && prev.occupant == self
		@coord.occupant = self if @coord && @coord.occupant != self
	end

end

class Pawn < ChessPiece

	def initialize(color)
		super(color)
		@name = "P"
		@color == :white ? @symbol = "\u2659".encode('utf-8') : @symbol = "\u265F".encode('utf-8')
	end

end

class Knight < ChessPiece

	def initialize(color)
		super(color)
		@name = "N"
		@color == :white ? @symbol = "\u2658".encode('utf-8') : @symbol = "\u265E".encode('utf-8')
	end

end

class Bishop < ChessPiece

	def initialize(color)
		super(color)
		@name = "B"
		@color == :white ? @symbol = "\u2657".encode('utf-8') : @symbol = "\u265D".encode('utf-8')
	end

end

class Rook < ChessPiece

	def initialize(color)
		super(color)
		@name = "R"
		@color == :white ? @symbol = "\u2656".encode('utf-8') : @symbol = "\u265C".encode('utf-8')
	end

end

class Queen < ChessPiece

	def initialize(color)
		super(color)
		@name = "Q"
		@color == :white ? @symbol = "\u2655".encode('utf-8') : @symbol = "\u265B".encode('utf-8')
	end

end

class King < ChessPiece

	def initialize(color)
		super(color)
		@name = "K"
		@color == :white ? @symbol = "\u2654".encode('utf-8') : @symbol = "\u265A".encode('utf-8')
	end

end