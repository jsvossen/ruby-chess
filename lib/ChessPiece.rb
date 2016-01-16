class ChessPiece

	CODEX = {
		"P" => "pawn",
		"N" => "knight",
		"B" => "bishop",
		"R" => "rook",
		"Q" => "queen",
		"K" => "king"
	}

	SYM = {
		:wpawn => "\u2659".encode('utf-8'),
		:bpawn => "\u265F".encode('utf-8'),
		:wrook => "\u2656".encode('utf-8'),
		:brook => "\u265C".encode('utf-8'),
		:wknight => "\u2658".encode('utf-8'),
		:bknight => "\u265E".encode('utf-8'),
		:wbish => "\u2657".encode('utf-8'),
		:bbish => "\u265D".encode('utf-8'),
		:wqueen => "\u2655".encode('utf-8'),
		:bqueen => "\u265B".encode('utf-8'),
		:wking => "\u2654".encode('utf-8'),
		:bking => "\u265A".encode('utf-8')
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

	attr_accessor :name

	def initialize(color)
		super(color)
		demote
	end

	def demote
		@name = "P"
		@color == :white ? @symbol = SYM[:wpawn] : @symbol = SYM[:bpawn]
	end

	def promote
		input = Readline.readline("Promote pawn to [Q]ueen, [B]ishop, [R]ook, or k[N]ight? ").upcase
		until input == "Q" || input == "R" || input == "B" || input == "N" do
			input = Readline.readline("Promote pawn to [Q]ueen, [B]ishop, [R]ook, or k[N]ight? ")
		end
		@name = input.upcase
		case @name
			when "Q"
				@color == :white ? @symbol = SYM[:wqueen] : @symbol = SYM[:bqueen]
			when "R"
				@color == :white ? @symbol = SYM[:wrook] : @symbol = SYM[:brook]
			when "B"
				@color == :white ? @symbol = SYM[:wbish] : @symbol = SYM[:bbish]
			when "N"
				@color == :white ? @symbol = SYM[:wknight] : @symbol = SYM[:bknight]
		end
	end

end

class Knight < ChessPiece

	def initialize(color)
		super(color)
		@name = "N"
		@color == :white ? @symbol = SYM[:wknight] : @symbol = SYM[:bknight]
	end

end

class Bishop < ChessPiece

	def initialize(color)
		super(color)
		@name = "B"
		@color == :white ? @symbol = SYM[:wbish] : @symbol = SYM[:bbish]
	end

end

class Rook < ChessPiece

	def initialize(color)
		super(color)
		@name = "R"
		@color == :white ? @symbol = SYM[:wrook] : @symbol = SYM[:brook]
	end

end

class Queen < ChessPiece

	def initialize(color)
		super(color)
		@name = "Q"
		@color == :white ? @symbol = SYM[:wqueen] : @symbol = SYM[:bqueen]
	end

end

class King < ChessPiece

	def initialize(color)
		super(color)
		@name = "K"
		@color == :white ? @symbol = SYM[:wking] : @symbol = SYM[:bking]
	end

end