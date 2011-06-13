#!/usr/bin/ruby

require File.dirname(__FILE__) + '/helper'

class HandTest < Test::Unit::TestCase

	def setup
		@hand = Hand.new
		@blackjack = Hand.new(ACE, TEN)
	end

	def test_blackjack
		assert @blackjack.blackjack?
		assert_equal 21, @blackjack.to_i
	end

	def test_no_blackjack_21
		@hand << TEN
		@hand << NINE
		@hand << TWO

		assert !(@hand.blackjack?)
		assert_equal 21, @hand.to_i
	end

	def test_to_i_non_blackjack
		@hand << TWO
		@hand << THREE
		assert_equal 5, @hand.to_i
	end

	# one handed hand does not make sense
	def test_hand_with_less_two_cards_is_zero
		@hand << ACE
		assert_equal 0, @hand.to_i
	end

	def test_hand_with_ace_does_not_bust
		@hand << ACE
		@hand << ACE

		assert !@hand.busted?
		assert_equal 11 + 1, @hand.to_i
	end

end
