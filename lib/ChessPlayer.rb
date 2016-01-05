class ChessPlayer

	attr_accessor :name, :color, :set

	def initialize(name,color)
		@name = name
		@color = color
		@set = nil
	end

end