class ChessPlayer

	attr_accessor :name, :color, :set, :check, :draw

	def initialize(name,color)
		@name = name
		@color = color
		@set = nil
		@draw = false
	end

end