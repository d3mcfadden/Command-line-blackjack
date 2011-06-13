#!/usr/bin/ruby

require File.dirname(__FILE__) + '/helper'

class DeckTest < Test::Unit::TestCase
	
	def setup
		@deck = Deck.new
	end

	def test_shuffle_deck
		d2 = Deck.new
		@deck.shuffle
		d2.shuffle
		c1 = @deck.get_next
		c2 = d2.get_next

		assert_not_equal c1, c2
	end

	def test_exception_on_empty_deck
		52.times do |i|
			@deck.get_next
		end

		assert_raise EmptyDeckError do
			no_card = @deck.get_next
		end
	end

	def test_cards_remaining
		n = 52
		assert_equal n, @deck.cards_remaining
		n.times do |i|
			n -= 1
			@deck.get_next
			assert_equal n, @deck.cards_remaining
		end
	end

end
