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
			game.board.draw
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
				expect(game).to receive(:puts).with("Ambiguous command! Multiple pieces can move to c5.")
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
				@p1 = Pawn.new("P",:white)
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
				p2 = Pawn.new("P",:black)
				p2.coord = game.board.square(2,5)
				game.get_moves(@p1)
				expect(@p1.moves.include? [2,5]).to eq true					
			end
			it "cannot capture ally piece" do
				@p1.coord = game.board.square(1,4)
				p2 = Pawn.new("P",:white)
				p2.coord = game.board.square(2,5)
				game.get_moves(@p1)
				expect(@p1.moves.include? [2,5]).to eq false					
			end
			it "cannot jump pieces" do
				@p1.coord = game.board.square(1,2)
				n1 = Knight.new("N",:white)
				n1.coord = game.board.square(1,3)
				game.get_moves(@p1)
				expect(@p1.moves.include? [1,4]).to eq false
			end
			it "cannot move forward on top of another piece" do
				@p1.coord = game.board.square(1,2)
				n1 = Knight.new("N",:white)
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
				@n1 = Knight.new("N",:white)
			end
			it "can move in an L pattern" do
				@n1.coord = game.board.square(4,4)
				game.get_moves(@n1)
				expect(@n1.moves.sort).to eq [ [2,5], [3,6], [5,6], [6,5], [6,3], [5,2], [2,3], [3,2] ].sort
			end
			it "can capture opponent piece" do
				@n1.coord = game.board.square(4,4)
				p = Pawn.new("P",:black)
				p.coord = game.board.square(3,6)
				game.get_moves(@n1)
				expect(@n1.moves.include? [3,6]).to eq true
			end
			it "cannot capture ally piece" do
				@n1.coord = game.board.square(4,4)
				p = Pawn.new("P",:white)
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

	end

end