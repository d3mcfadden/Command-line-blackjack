#!/usr/bin/ruby

require File.dirname(__FILE__) + '/helper'

class HitStrategyTest < Test::Unit::TestCase
	include Blackjack::Strategies

	def test_not_asked_to_hit_on_blackjack
		@io = mock()
		@io.expects(:gets).never
		@strategy = HitStrategy.new @io, @io
		assert !@strategy.hit?(BLACKJACK)
	end

end

class DealerHitStrategyTest < Test::Unit::TestCase
	include Blackjack::Strategies

	def setup
		@strategy = DealerHitStrategy.new 'dealer'
	end

	def test_dealer_makes_sane_choice
		assert !@strategy.hit?(TWENTY, LOW_HAND)
	end

	def test_dealer_no_hit_on_blackjack_against_low_hand
		assert !@strategy.hit?(BLACKJACK, LOW_HAND)
	end

	def test_dealer_no_hit_on_blackjack_against_blackjack
		assert !@strategy.hit?(BLACKJACK, BLACKJACK)
	end

	def test_dealer_hits_aginst_high_hand
		assert @strategy.hit?(LOW_HAND, TWENTY)
	end

	def test_dealer_stays_on_soft_17
		assert !@strategy.hit?(SOFT_17, TWENTY)
	end

	def test_dealer_stays_when_winning
		assert !@strategy.hit?(Hand.new(Card.ten('S'), Card.three('S')),
							   Hand.new(Card.ten('S'), Card.two('S')))
	end

	def test_dealer_hits_while_loosing
		assert @strategy.hit?(Hand.new(Card.ten('S'), Card.ten('S')),
							  BLACKJACK)
	end

end
