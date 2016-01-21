require_relative "spec_helper"

describe ChessGame do
	
	let(:game) { ChessGame.new }
	wpawn = "\u2659".encode('utf-8')
	bpawn = "\u265F".encode('utf-8')
	wrook = "\u2656".encode('utf-8')
	brook = "\u265C".encode('utf-8')
	wknight = "\u2658".encode('utf-8')
	bknight = "\u265E".encode('utf-8')
	wbish = "\u2657".encode('utf-8')
	bbish = "\u265D".encode('utf-8')
	wqueen = "\u2655".encode('utf-8')
	bqueen = "\u265B".encode('utf-8')
	wking = "\u2654".encode('utf-8')
	bking = "\u265A".encode('utf-8')


	describe "#new" do
		
		it "creates a chess board with pieces" do
			expect(game.board).to receive(:puts).with("    a   b   c   d   e   f   g   h").ordered
			expect(game.board).to receive(:puts).with("  |-------------------------------|").ordered
			expect(game.board).to receive(:puts).with("8 | #{brook} | #{bknight} | #{bbish} | #{bqueen} | #{bking} | #{bbish} | #{bknight} | #{brook} | 8").ordered
			expect(game.board).to receive(:puts).with("  |-------------------------------|").ordered
			expect(game.board).to receive(:puts).with("7 | #{bpawn} | #{bpawn} | #{bpawn} | #{bpawn} | #{bpawn} | #{bpawn} | #{bpawn} | #{bpawn} | 7").ordered
			expect(game.board).to receive(:puts).with("  |-------------------------------|").ordered
			expect(game.board).to receive(:puts).with("6 |   |   |   |   |   |   |   |   | 6").ordered
			expect(game.board).to receive(:puts).with("  |-------------------------------|").ordered
			expect(game.board).to receive(:puts).with("5 |   |   |   |   |   |   |   |   | 5").ordered
			expect(game.board).to receive(:puts).with("  |-------------------------------|").ordered
			expect(game.board).to receive(:puts).with("4 |   |   |   |   |   |   |   |   | 4").ordered
			expect(game.board).to receive(:puts).with("  |-------------------------------|").ordered
			expect(game.board).to receive(:puts).with("3 |   |   |   |   |   |   |   |   | 3").ordered
			expect(game.board).to receive(:puts).with("  |-------------------------------|").ordered
			expect(game.board).to receive(:puts).with("2 | #{wpawn} | #{wpawn} | #{wpawn} | #{wpawn} | #{wpawn} | #{wpawn} | #{wpawn} | #{wpawn} | 2").ordered
			expect(game.board).to receive(:puts).with("  |-------------------------------|").ordered
			expect(game.board).to receive(:puts).with("1 | #{wrook} | #{wknight} | #{wbish} | #{wqueen} | #{wking} | #{wbish} | #{wknight} | #{wrook} | 1").ordered
			expect(game.board).to receive(:puts).with("  |-------------------------------|").ordered
			expect(game.board).to receive(:puts).with("    a   b   c   d   e   f   g   h").ordered
			game.board.line_draw
		end

	end


	describe "#move" do
		
		context "legal move" do
			before(:each) do
				@p1 = game.board.square(1,2).occupant
				game.move("P",1,4)
			end

			it "removes occupant from origin" do
				expect(game.board.square(1,2).occupant).to eq nil
			end

			it "adds occupant to destination" do
				expect(game.board.square(1,4).occupant).to eq @p1
			end

			it "updates piece coordinates" do
				expect(@p1.coord).to eq game.board.square(1,4)
			end

			it "captures opponent piece" do
				p2 = game.board.square(2,7).occupant
				game.active = game.players[1]
				game.move("P",2,5)
				game.active = game.players[0]
				game.move("P",2,5)
				expect(p2.captured).to eq true
				expect(p2.coord).to eq nil
			end
 
		end

		context "illegal move" do
			before(:each) { expect(game).to receive(:puts).with("Illegal move!") }
					
			it "returns false" do
				expect(game.move("P",1,5)).to be false
			end

			it "does not update board" do
				p1 = game.board.square(1,2).occupant
				game.move("P",1,5)
				expect(p1.coord).to eq game.board.square(1,2)
				expect(game.board.square(1,2).occupant).to eq p1
				expect(game.board.square(1,5).occupant).to eq nil
			end

		end

		context "ambiguous move" do
			before(:each) do
				game.move("P",2,4)
				game.move("P",4,4)
				game.active = game.players[1]
				game.move("P",3,5)
				game.active = game.players[0]
				expect(game).to receive(:puts).with("Ambiguous command! Multiple pawns can move to c5.")
			end

			it "returns false" do
				expect(game.move("P",3,5)).to be false
			end

			it "does not update board" do
				p1 = game.board.square(2,4).occupant
				p2 = game.board.square(3,5).occupant
				game.move("P",3,5)
				expect(p1.coord).to eq game.board.square(2,4)
				expect(game.board.square(2,4).occupant).to eq p1
				expect(game.board.square(3,5).occupant).to eq p2
			end
		end

	end


	describe "#get_moves" do
		
		context "pawn" do
			before(:each) do
				game.board.empty
				@p1 = Pawn.new(:white)
			end
			it "can move forward one or two spaces from home row" do
				@p1.coord = game.board.square(1,2)
				game.get_moves(@p1)
				expect(@p1.moves).to eq [[1,4],[1,3]]
			end
			it "can only move forward one space outside of home row" do
				@p1.coord = game.board.square(1,3)
				game.get_moves(@p1)
				expect(@p1.moves).to eq [[1,4]]
			end
			it "can capture opponent piece on forward diagonals" do
				@p1.coord = game.board.square(1,4)
				p2 = Pawn.new(:black)
				p2.coord = game.board.square(2,5)
				game.get_moves(@p1)
				expect(@p1.moves.include? [2,5]).to eq true					
			end
			it "cannot capture ally piece" do
				@p1.coord = game.board.square(1,4)
				p2 = Pawn.new(:white)
				p2.coord = game.board.square(2,5)
				game.get_moves(@p1)
				expect(@p1.moves.include? [2,5]).to eq false					
			end
			it "cannot jump pieces" do
				@p1.coord = game.board.square(1,2)
				n1 = Knight.new(:white)
				n1.coord = game.board.square(1,3)
				game.get_moves(@p1)
				expect(@p1.moves.include? [1,4]).to eq false
			end
			it "cannot move forward on top of another piece" do
				@p1.coord = game.board.square(1,2)
				n1 = Knight.new(:white)
				n1.coord = game.board.square(1,3)
				game.get_moves(@p1)
				expect(@p1.moves.include? [1,3]).to eq false
			end
			it "cannot move off of board" do
				@p1.coord = game.board.square(1,8)
				game.get_moves(@p1)
				expect(@p1.moves).to eq []
			end
		end

		context "knight" do
			before(:each) do
				game.board.empty
				@n1 = Knight.new(:white)
			end
			it "can move in an L pattern" do
				@n1.coord = game.board.square(4,4)
				game.get_moves(@n1)
				expect(@n1.moves.sort).to eq [ [2,5], [3,6], [5,6], [6,5], [6,3], [5,2], [2,3], [3,2] ].sort
			end
			it "can capture opponent piece" do
				@n1.coord = game.board.square(4,4)
				p = Pawn.new(:black)
				p.coord = game.board.square(3,6)
				game.get_moves(@n1)
				expect(@n1.moves.include? [3,6]).to eq true
			end
			it "cannot capture ally piece" do
				@n1.coord = game.board.square(4,4)
				p = Pawn.new(:white)
				p.coord = game.board.square(3,6)
				game.get_moves(@n1)
				expect(@n1.moves.include? [3,6]).to eq false
			end
			it "cannot move off of board" do
				@n1.coord = game.board.square(1,3)
				game.get_moves(@n1)
				expect(@n1.moves.sort).to eq [ [2,5], [2,1], [3,2], [3,4] ].sort
			end
		end

		context "king" do
			before(:each) do
				game.board.empty
				@k1 = King.new(:white)
			end
			it "can move one space in any direction" do
				@k1.coord = game.board.square(4,4)
				game.get_moves(@k1)
				expect(@k1.moves.sort).to eq [ [3,3], [5,5], [4,5], [5,4], [4,3], [3,4], [3,5], [5,3] ].sort
			end
			it "can capture opponent piece" do
				@k1.coord = game.board.square(4,4)
				p = Pawn.new(:black)
				p.coord = game.board.square(3,3)
				game.get_moves(@k1)
				expect(@k1.moves.include? [3,3]).to eq true
			end
			it "cannot capture ally piece" do
				@k1.coord = game.board.square(4,4)
				p = Pawn.new(:white)
				p.coord = game.board.square(3,3)
				game.get_moves(@k1)
				expect(@k1.moves.include? [3,3]).to eq false
			end
			it "cannot move off of board" do
				@k1.coord = game.board.square(1,1)
				game.get_moves(@k1)
				expect(@k1.moves.sort).to eq [ [1,2], [2,2], [2,1] ].sort
			end
		end

		context "rook" do
			before(:each) do
				game.board.empty
				@r1 = Rook.new(:white)
				@r1.coord = game.board.square(4,4)
			end
			it "can move any number of spaces vertically or horizontally" do
				game.get_moves(@r1)
				expect(@r1.moves.sort).to eq [ [4,1],[4,2],[4,3],[4,5],[4,6],[4,7],[4,8],[1,4],[2,4],[3,4],[5,4],[6,4],[7,4],[8,4] ].sort
			end
			it "can capture opponent piece" do
				p = Pawn.new(:black)
				p.coord = game.board.square(4,7)
				game.get_moves(@r1)
				expect(@r1.moves.include? [4,7]).to eq true
			end
			it "cannot capture ally piece" do
				p = Pawn.new(:white)
				p.coord = game.board.square(4,2)
				game.get_moves(@r1)
				expect(@r1.moves.include? [4,2]).to eq false
			end
			it "cannot jump pieces" do
				p = Pawn.new(:black)
				p.coord = game.board.square(5,4)
				game.get_moves(@r1)
				expect(@r1.moves.include? [6,4]).to eq false
				expect(@r1.moves.include? [7,4]).to eq false
				expect(@r1.moves.include? [8,4]).to eq false
			end
			it "cannot move off of board" do
				@r1.coord = game.board.square(1,1)
				game.get_moves(@r1)
				expect(@r1.moves.sort).to eq [ [1,2],[1,3],[1,4],[1,5],[1,6],[1,7],[1,8],[2,1],[3,1],[4,1],[5,1],[6,1],[7,1],[8,1] ].sort
			end
		end

		context "bishop" do
			before(:each) do
				game.board.empty
				@b1 = Bishop.new(:white)
				@b1.coord = game.board.square(4,4)
			end
			it "can move any number of spaces diagonally" do
				game.get_moves(@b1)
				expect(@b1.moves.sort).to eq [ [1,1], [2,2], [3,3], [5,5], [6,6],[7,7], [8,8], [1,7], [2,6], [3,5], [5,3], [6,2], [7,1] ].sort
			end
			it "can capture opponent piece" do
				p = Pawn.new(:black)
				p.coord = game.board.square(2,6)
				game.get_moves(@b1)
				expect(@b1.moves.include? [2,6]).to eq true
			end
			it "cannot capture ally piece" do
				p = Pawn.new(:white)
				p.coord = game.board.square(6,2)
				game.get_moves(@b1)
				expect(@b1.moves.include? [6,2]).to eq false
			end
			it "cannot jump pieces" do
				p = Pawn.new(:black)
				p.coord = game.board.square(5,5)
				game.get_moves(@b1)
				expect(@b1.moves.include? [6,6]).to eq false
				expect(@b1.moves.include? [7,7]).to eq false
				expect(@b1.moves.include? [8,8]).to eq false
			end
			it "cannot move off of board" do
				@b1.coord = game.board.square(1,1)
				game.get_moves(@b1)
				expect(@b1.moves.sort).to eq [ [2,2], [3,3], [4,4], [5,5], [6,6],[7,7], [8,8] ].sort
			end		
		end

		context "queen" do
			before(:each) do
				game.board.empty
				@q1 = Queen.new(:white)
				@q1.coord = game.board.square(4,4)
			end
			it "can move any number of spaces in any direction" do
				game.get_moves(@q1)
				expect(@q1.moves.sort).to eq [ [1,1], [2,2], [3,3], [5,5], [6,6],[7,7], [8,8], [1,7], [2,6], [3,5], [5,3], [6,2], [7,1], [4,1],[4,2],[4,3],[4,5],[4,6],[4,7],[4,8],[1,4],[2,4],[3,4],[5,4],[6,4],[7,4],[8,4] ].sort
			end
			it "can capture opponent piece" do
				p = Pawn.new(:black)
				p.coord = game.board.square(2,6)
				game.get_moves(@q1)
				expect(@q1.moves.include? [2,6]).to eq true
			end
			it "cannot capture ally piece" do
				p = Pawn.new(:white)
				p.coord = game.board.square(6,2)
				game.get_moves(@q1)
				expect(@q1.moves.include? [6,2]).to eq false
			end
			it "cannot jump pieces" do
				p = Pawn.new(:black)
				p.coord = game.board.square(5,5)
				game.get_moves(@q1)
				expect(@q1.moves.include? [6,6]).to eq false
				expect(@q1.moves.include? [7,7]).to eq false
				expect(@q1.moves.include? [8,8]).to eq false
			end
			it "cannot move off of board" do
				@q1.coord = game.board.square(1,1)
				game.get_moves(@q1)
				expect(@q1.moves.sort).to eq [ [2,2], [3,3], [4,4], [5,5], [6,6],[7,7], [8,8], [1,2],[1,3],[1,4],[1,5],[1,6],[1,7],[1,8],[2,1],[3,1],[4,1],[5,1],[6,1],[7,1],[8,1] ].sort
			end
		end

	end


	describe "#check?" do
		before(:each) do
			wking = game.players[0].set.select { |p| p.name == "K"}
			brook = game.players[1].set.select { |p| p.name == "R"}
			game.board.empty
			wking[0].coord = game.board.square(3,3)
			brook[0].coord = game.board.square(3,7)
		end
		it "puts player in check if king is in danger" do
			expect(game.check?(game.players[0])).to eq true
		end
		it "takes player out of check if king is safe" do
			game.check?(game.players[0])
			game.move("K",4,3)
			expect(game.check?(game.players[0])).to eq false
		end

	end

	describe "#vulnerable_move?" do
		before(:each) do
			wking = game.players[0].set.select { |p| p.name == "K"}
			wqueen = game.players[0].set.select { |p| p.name == "Q"}
			brook = game.players[1].set.select { |p| p.name == "R"}
			game.board.empty
			wking[0].coord = game.board.square(3,3)
			wqueen[0].coord = game.board.square(8,2)
			brook[0].coord = game.board.square(3,7)
		end
		it "returns true if a move leaves king in danger" do
			expect(game.vulnerable_move?(wking[0],3,2)).to eq true
		end
		it "returns false if a move keeps king safe" do
			expect(game.vulnerable_move?(wking[0],2,3)).to eq false
			expect(game.vulnerable_move?(wqueen[0],3,7)).to eq false
		end
		it "does not update board" do
			game.vulnerable_move?(wqueen[0],3,7)
			expect(wqueen[0].coord).to eq game.board.square(8,2)
			expect(brook[0].coord).to eq game.board.square(3,7)
		end
	end


	describe "#gameover" do

		context "#checkmate?" do
			before(:each) do
				wking = game.players[0].set.select { |p| p.name == "K"}
				bking = game.players[1].set.select { |p| p.name == "K"}
				bbish = game.players[1].set.select { |p| p.name == "B"}
				game.board.empty
				wking[0].coord = game.board.square(8,1)
				bking[0].coord = game.board.square(8,3)
				bbish[0].coord = game.board.square(6,3)
				bbish[1].coord = game.board.square(5,3)
			end
			it "returns true if player is in check and has no moves" do
				expect(game.check?(game.players[0])).to eq true
				expect(game.players[0].set.select { |p| p.in_play? && !game.get_moves(p).empty? }).to eq []
				expect(game.checkmate?).to eq true
			end
			it "returns false if player has moves" do
				bbish[1].coord = nil
				expect(game.check?(game.players[0])).to eq true
				expect(game.checkmate?).to eq false
			end
		end

		context "#stalemate?" do
			before(:each) do
				wking = game.players[0].set.select { |p| p.name == "K"}
				wqueen = game.players[0].set.select { |p| p.name == "Q"}
				bking = game.players[1].set.select { |p| p.name == "K"}
				game.board.empty
				wking[0].coord = game.board.square(3,4)
				wqueen[0].coord = game.board.square(3,6)
				bking[0].coord = game.board.square(1,5)
				game.active = game.players[1]
			end
			it "returns true if player is not in check and has no moves" do
				expect(game.check?(game.players[1])).to eq false
				expect(game.players[1].set.select { |p| p.in_play? && !game.get_moves(p).empty? }).to eq []
				expect(game.stalemate?).to eq true
			end
			it "returns false if player has moves" do
				wqueen[0].coord = game.board.square(3,5)
				expect(game.stalemate?).to eq false
		
			end
		end	

		context "#draw?" do
			it "returns true if both players agree to draw" do
				game.players.each { |p| p.draw = true }
				expect(game.draw?).to eq true
			end
		end		
	end

	describe "#castle_ks" do
		before(:each) do
			wking = game.players[0].set.select { |p| p.name == "K"}.first
			wrook = game.players[0].set.select { |p| p.name == "R"}
			bqueen = game.players[1].set.select { |p| p.name == "Q"}.first
			game.board.empty
			wking.coord = game.board.square(5,1)
			wrook[0].coord = game.board.square(8,1)
			wrook[1].coord = game.board.square(1,1)
			bqueen.coord = game.board.square(4,8)
		end
		it "moves king and rook if castling is allowed" do
			expect(game.castle_ks).to eq true
			expect(wking.coord).to eq game.board.square(7,1)
			expect(wrook[0].coord).to eq game.board.square(6,1)
			expect(wrook[1].coord).to eq game.board.square(1,1)
		end
		it "rejects castle if king is in check" do
			bqueen.coord = game.board.square(5,8)
			expect(game).to receive(:puts).with("Illegal move!")
			expect(game.castle_ks).to eq false
			expect(wking.coord).to eq game.board.square(5,1)
			expect(wrook[0].coord).to eq game.board.square(8,1)
		end
		it "rejects castle if king has moved previously" do
			game.move("K",5,2)
			game.move("K",5,1)
			expect(game).to receive(:puts).with("Illegal move!")
			expect(game.castle_ks).to eq false
			expect(wking.coord).to eq game.board.square(5,1)
			expect(wrook[0].coord).to eq game.board.square(8,1)
		end
		it "rejects castle if rook has moved previously" do
			game.move("R",8,2)
			game.move("R",8,1)
			expect(game).to receive(:puts).with("Illegal move!")
			expect(game.castle_ks).to eq false
			expect(wking.coord).to eq game.board.square(5,1)
			expect(wrook[0].coord).to eq game.board.square(8,1)
		end
		it "rejects castle if king would pass through vulnerable squares" do
			bqueen.coord = game.board.square(6,8)
			expect(game).to receive(:puts).with("Illegal move!")
			expect(game.castle_ks).to eq false
			expect(wking.coord).to eq game.board.square(5,1)
			expect(wrook[0].coord).to eq game.board.square(8,1)
		end
		it "rejects castle if squares between king and rook are occupied" do
			Pawn.new(:white).coord = game.board.square(7,1)
			expect(game).to receive(:puts).with("Illegal move!")
			expect(game.castle_ks).to eq false
			expect(wking.coord).to eq game.board.square(5,1)
			expect(wrook[0].coord).to eq game.board.square(8,1)
		end
	end

	describe "#castle_qs" do
		before(:each) do
			wking = game.players[0].set.select { |p| p.name == "K"}.first
			wrook = game.players[0].set.select { |p| p.name == "R"}
			bqueen = game.players[1].set.select { |p| p.name == "Q"}.first
			game.board.empty
			wking.coord = game.board.square(5,1)
			wrook[0].coord = game.board.square(8,1)
			wrook[1].coord = game.board.square(1,1)
			bqueen.coord = game.board.square(6,8)
		end
		it "moves king and rook if castling is allowed" do
			expect(game.castle_qs).to eq true
			expect(wking.coord).to eq game.board.square(3,1)
			expect(wrook[1].coord).to eq game.board.square(4,1)
			expect(wrook[0].coord).to eq game.board.square(8,1)
		end
		it "rejects castle if king is in check" do
			bqueen.coord = game.board.square(5,8)
			expect(game).to receive(:puts).with("Illegal move!")
			expect(game.castle_qs).to eq false
			expect(wking.coord).to eq game.board.square(5,1)
			expect(wrook[1].coord).to eq game.board.square(1,1)
		end
		it "rejects castle if king has moved previously" do
			game.move("K",5,2)
			game.move("K",5,1)
			expect(game).to receive(:puts).with("Illegal move!")
			expect(game.castle_qs).to eq false
			expect(wking.coord).to eq game.board.square(5,1)
			expect(wrook[1].coord).to eq game.board.square(1,1)
		end
		it "rejects castle if rook has moved previously" do
			game.move("R",1,2)
			game.move("R",1,1)
			expect(game).to receive(:puts).with("Illegal move!")
			expect(game.castle_qs).to eq false
			expect(wking.coord).to eq game.board.square(5,1)
			expect(wrook[1].coord).to eq game.board.square(1,1)
		end
		it "rejects castle if king would pass through vulnerable squares" do
			bqueen.coord = game.board.square(4,8)
			expect(game).to receive(:puts).with("Illegal move!")
			expect(game.castle_qs).to eq false
			expect(wking.coord).to eq game.board.square(5,1)
			expect(wrook[1].coord).to eq game.board.square(1,1)
		end
		it "rejects castle if squares between king and rook are occupied" do
			Pawn.new(:white).coord = game.board.square(2,1)
			expect(game).to receive(:puts).with("Illegal move!")
			expect(game.castle_qs).to eq false
			expect(wking.coord).to eq game.board.square(5,1)
			expect(wrook[1].coord).to eq game.board.square(1,1)
		end
	end


	describe "#en_passant" do
		before(:each) do
			wpawn = game.board.square(1,2).occupant
			bpawn = game.board.square(2,7).occupant
			bpawn.coord = game.board.square(2,4)
		end
		it "has en passant available if pawn is ajacent to enemy pawn that opened with double step" do
			game.move("P",1,4)
			game.active = game.players[1]
			game.get_moves(bpawn)
			expect(wpawn.passant_defensive).to eq true
			expect(bpawn.passant_offensive).to eq true
			expect(bpawn.moves.include? [1,3]).to eq true
		end
		it "captures ajacent enemy pawn with diagonal move" do
			game.move("P",1,4)
			game.active = game.players[1]
			game.move("P",1,3)
			expect(wpawn.captured).to eq true
			expect(bpawn.coord).to eq game.board.square(1,3)
		end
		it "cannot execute en passant if enemy pawn opens with single step" do
			game.move("P",1,3)
			game.move("P",1,4)
			game.active = game.players[1]
			game.get_moves(bpawn)
			expect(wpawn.passant_defensive).to eq false
			expect(bpawn.passant_offensive).to eq false
			expect(bpawn.moves.include? [1,3]).to eq false
		end

		it "forfeits en passant if not executed" do
			game.move("P",1,4)
			game.active = game.players[1]
			game.move("P",8,5)
			game.active = game.players[0]
			game.move("P",8,4)
			game.active = game.players[1]
			game.get_moves(bpawn)
			expect(wpawn.passant_defensive).to eq false
			expect(bpawn.passant_offensive).to eq false
			expect(bpawn.moves.include? [1,3]).to eq false
		end
		it "cannot execute en passant on piece other than pawn" do
			game.board.square(5,2).occupant.coord = nil
			game.move("B",3,4)
			game.active = game.players[1]
			game.get_moves(bpawn)
			expect(bpawn.passant_offensive).to eq false
			expect(bpawn.moves.include? [3,3]).to eq false
		end
	end

end