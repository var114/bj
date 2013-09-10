require_relative "../lib/bj"


describe Card do

	it "should accept a suit and value" do
	card = Card.new(:clubs, "J")
	card.suit.should eq(:clubs)
	card.value.should eq(10)
    end

    it "should have a value of 10 for facecards" do
    	facecards = ["J", "Q", "K"]
    	facecards.each do |facecard|
    		card = Card.new(:clubs, facecard)
    		card.value.should eq(10)
    	end
    end

    it "should have a value of 4 for 4-clubs" do
    	card = Card.new(:clubs, 4)
    	card.value.should eq(4)
	end

	it "should have a value of 11 for A-diamonds" do
		card = Card.new(:diamonds, "A")
		card.value.should eq(11)
	end

	it "should be formatted correctly" do
		card = Card.new(:diamonds, "A")
		card.to_s.should eq("A-diamonds")
	end
end

describe Deck do

	it "should have 52 cards" do
		Deck.build_cards.length.should eq(52) 
	end

	it "should have 52 cards when new deck" do
		Deck.new.cards.length.should eq(52)
	end
end

describe Hand do

	it "should calculate the value correctly" do
		deck = mock(:deck, :cards => [Card.new(:clubs, 5), Card.new(:diamonds, 10)])
		hand = Hand.new
		2.times { hand.hit!(deck) }   
		hand.value.should eq(15)
	end

	describe "#play_as_dealer" do
		it "should hit below 16" do
			deck = mock(:deck, :cards => [Card.new(:clubs, 4), Card.new(:diamonds, 10), Card.new(:clubs, 2)])
			hand = Hand.new
			hand.play_as_dealer(deck)
			hand.value.should eq(16)
		end
		it "should not hit above " do
			deck = mock(:deck, :cards => [Card.new(:clubs, 8), Card.new(:diamonds, 9)])
			hand = Hand.new
			hand.play_as_dealer(deck)
			hand.value.should eq(17)
		end

		it "should stop on 21" do
				deck = mock(:deck, :cards => [Card.new(:clubs, 4),
											  Card.new(:diamonds, 7),
											  Card.new(:clubs, "K")])
			hand = Hand.new
			hand.play_as_dealer(deck)
			hand.value.should eq(21)
		end 


	end  
end 


describe Game do

	it "should have a player hand" do
		Game.new.player_hand.cards.length.should eq(2)
	end
	it "should have a dealer hand"  do
		Game.new.dealer_hand.cards.length.should eq(2)
	end
	it "should have a status" do
		Game.new.status.should_not be_nil
	end 

	it "should only hit when player hand is not bust"

	it "should hit when I tell it to" do
		game = Game.new
		game.hit
		game.player_hand.cards.length.should eq(3)
	end

	it "should play the dealer hand when I stand" do
		game = Game.new
		game.stand
		game.status[:winner].should_not be_nil
	end

	describe "#determine_winner" do
		it "should have dealer win when player busts" do
		    Game.new.determine_winner(22,17).should eq(:dealer)
		end
		it "should have player win if dealer busts" do
			Game.new.determine_winner(17,22).should eq(:player)
		end
		it "should have player win if player > dealer" do
			Game.new.determine_winner(17,16).should eq(:player)
	    end
		it "should have push if tie" do
			Game.new.determine_winner(10,10).should eq(:push)
		end
	end

end


