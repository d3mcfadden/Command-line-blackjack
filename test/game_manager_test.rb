#!/usr/bin/ruby

require File.join(File.dirname(__FILE__), 'helper')

class GameManagerTest < Test::Unit::TestCase

	def setup
		@deck = Deck.new
		@input = mock()
		@output = mock()
		@evt_handler = PlayerEventHandler.new(@input, @output)
		@players = [Player.new('dan', @evt_handler)]
		@dealer = Dealer.new 'dealer'
		@manager = GameManager.new(@deck, @dealer, @players)
	end

	def test_game_with_one_player
		wager = 20
		@players.first.expects(:pay!).once.with(wager)
		seed_deck_with([ACE, TWO, NINE, TWO])
		@output.expects(:puts).twice
		@input.expects(:gets).twice.returns(wager, 'N') # wager 10
		@manager.run
	end

end
