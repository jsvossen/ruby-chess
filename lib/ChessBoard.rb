class ChessBoard

	attr_reader :squares

	CHAR_RANGE = ("a".."h").to_a
	BOARD_SIZE = 8

	def initialize
		@squares = {}
		BOARD_SIZE.times do |x|
			char = CHAR_RANGE[x]
			BOARD_SIZE.times do |y|
				label = "#{char}#{y+1}".to_sym
				@squares[label] = Square.new(x+1,y+1)
			end
		end
	end

	def square(x,y)
		char = CHAR_RANGE[x.to_i-1]
		@squares["#{char}#{y}".to_sym]
	end

	def draw
		puts "    a   b   c   d   e   f   g   h"
		puts "  |-------------------------------|"
		puts "8 | #{square(1,8).mark} | #{square(2,8).mark} | #{square(3,8).mark} | #{square(4,8).mark} | #{square(5,8).mark} | #{square(6,8).mark} | #{square(7,8).mark} | #{square(8,8).mark} | 8"
		puts "  |-------------------------------|"
		puts "7 | #{square(1,7).mark} | #{square(2,7).mark} | #{square(3,7).mark} | #{square(4,7).mark} | #{square(5,7).mark} | #{square(6,7).mark} | #{square(7,7).mark} | #{square(8,7).mark} | 7"
		puts "  |-------------------------------|"
		puts "6 | #{square(1,6).mark} | #{square(2,6).mark} | #{square(3,6).mark} | #{square(4,6).mark} | #{square(5,6).mark} | #{square(6,6).mark} | #{square(7,6).mark} | #{square(8,6).mark} | 6"
		puts "  |-------------------------------|"
		puts "5 | #{square(1,5).mark} | #{square(2,5).mark} | #{square(3,5).mark} | #{square(4,5).mark} | #{square(5,5).mark} | #{square(6,5).mark} | #{square(7,5).mark} | #{square(8,5).mark} | 5"
		puts "  |-------------------------------|"
		puts "4 | #{square(1,4).mark} | #{square(2,4).mark} | #{square(3,4).mark} | #{square(4,4).mark} | #{square(5,4).mark} | #{square(6,4).mark} | #{square(7,4).mark} | #{square(8,4).mark} | 4"
		puts "  |-------------------------------|"
		puts "3 | #{square(1,3).mark} | #{square(2,3).mark} | #{square(3,3).mark} | #{square(4,3).mark} | #{square(5,3).mark} | #{square(6,3).mark} | #{square(7,3).mark} | #{square(8,3).mark} | 3"
		puts "  |-------------------------------|"
		puts "2 | #{square(1,2).mark} | #{square(2,2).mark} | #{square(3,2).mark} | #{square(4,2).mark} | #{square(5,2).mark} | #{square(6,2).mark} | #{square(7,2).mark} | #{square(8,2).mark} | 2"
		puts "  |-------------------------------|"
		puts "1 | #{square(1,1).mark} | #{square(2,1).mark} | #{square(3,1).mark} | #{square(4,1).mark} | #{square(5,1).mark} | #{square(6,1).mark} | #{square(7,1).mark} | #{square(8,1).mark} | 1"
		puts "  |-------------------------------|"
		puts "    a   b   c   d   e   f   g   h"
	end

	def empty
		@squares.each do |label, sq|
			sq.occupant = nil
		end
	end

	class Square

		attr_reader :x, :y, :occupant

		def initialize(x,y)
			@x = x
			@y = y
			@occupant = nil
		end

		def occupant= piece
			prev = @occupant
			@occupant = piece
			prev.coord = nil if prev && prev.coord == self
			piece.coord = self if piece && piece.coord != self
		end

		#print empty space or occupant symbol
		def mark
			@occupant ? @occupant.symbol : " "
		end

		#return occupant color or nil if empty 
		def alignment
			@occupant ? @occupant.color : nil
		end

	end

end