#!/usr/bin/ruby

require File.dirname(__FILE__) + '/helper'

class GameTest < Test::Unit::TestCase

	include Blackjack::Strategies

	def setup
		@strategy = HitStrategy.new(PlayerEventHandler.new)
		@player = Player.new('dan', @strategy)
		@dealer = Dealer.new
		@players = [@dealer, @player]
		@deck = Deck.new
		@game = Game.new(@deck, @players)
		@players = @game.players
	end

	def test_logic_error_on_create_game_without_a_dealer_and_player
		assert_raise BlackjackError do
			Game.new @deck, [Player.new 'dan']
		end
	end

	def test_deal_one_player
		@strategy.expects(:hit?).returns(false)
		assert_equal 1, @players.count
		@game.play
		assert_valid_hands
	end

	def test_with_with_blackjack
		@strategy.expects(:hit?).returns(false)
		seed_blackjack
		@game.play
		assert_equal 2, @player.hand.count
		assert @player.hand.blackjack?
		assert @game.winners.include?(@player)
	end

	def test_mulitple_player_game_one_hit_each
		@players = [ 
			Dealer.new, 
			Player.new('dan',  hit_strategy_with(:twice, [true, false])),
			Player.new('linh', hit_strategy_with(:twice, [true, false]))
		]
		@game = Game.new(@deck, @players)
		seed_deck_with([
			TEN,    # dan 10
			TWO,    # linh 2
			THREE,  # dealer 3
			FOUR,   # dan 14
			FIVE,   # linh 7
			SIX,    # dealer 9
			SIX,    # dan 20
			TEN,    # linh 17
			TEN,    # dealer 19
		])

		@game.play
		assert_equal 20, @players[0].hand.to_i
		assert_equal 17, @players[1].hand.to_i
	end

	def test_multiple_player_game_multiple_hits_each
		@players = [ 
			Dealer.new, 
			Player.new('dan',  hit_strategy_with(:at_least_once, [true, true, true, false])),
			Player.new('linh', hit_strategy_with(:at_least_once, [true, true, false]))
		]

		seed_deck_with([
			TWO, # dan 2
			TWO, # linh 2
			TWO, # dealer
			THREE, # dan 5
			THREE, # linh 5
			THREE, # dealer
			FOUR, # dan first hit 9
			FIVE, # dan second hit 14
			SIX, #dan last hit 20
			FOUR, # linh first hit 9
			TEN, # linh last hit 19
		])

		@game = Game.new(@deck, @players)
		@game.play

		@dan = @game.players[0]
		@linh = @game.players[1]

		assert_equal 5, @dan.hand.count, 'dan did not have 5 cards'
		assert_equal 4, @linh.hand.count, 'linh did not have 4 cards'

		assert_equal 20, @game.players[0].hand.to_i
		assert_equal 19, @game.players[1].hand.to_i
	end

	def test_not_offered_hit_after_bust
		@strategy.expects(:hit?).returns(true)
		seed_deck_with([
			TEN, # player
			ACE,
			TEN, # player has 20
			TEN,
			TWO  # players busted (22)
		])

		@game.play
		assert @player.hand.busted?
		assert_equal 1, @game.winners.count
		assert_equal @dealer, @game.winners.first
	end

	def test_everybody_wins_on_dealer_bust
		@strategy.expects(:hit?).twice.returns(false)

		@players = [
			Dealer.new('dealer'),
			Player.new('dan', @strategy),
			Player.new('linh', @strategy),
		]
		seed_deck_with([
			TWO, # dan
			TEN, # linh
			TEN, # dealer 
			THREE, # dan 5
			TEN, # linh 20
			NINE, # dealer 19
		])

		@game = Game.new(@deck, @players)
		@game.play

		@dan = @game.players[0]
		@linh = @game.players[1]
		assert @game.winners.include?(@dan)
		assert @game.winners.include?(@linh)
		assert !@game.winners.include?(@game.dealer)
	end

	protected

	def assert_valid_hands
		@players.each do |p|
			assert_equal 2, p.hand.count
		end
	end

	def hit_strategy_with(times_expected, results)
		strategy = HitStrategy.new
		strategy.expects(:hit?).send(times_expected).returns(*results)
		return strategy
	end

end
