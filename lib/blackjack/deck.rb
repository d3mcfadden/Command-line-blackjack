#!/usr/bin/ruby

class EmptyDeckError < StandardError; end

module Blackjack
	class Card

		attr_reader :value, :suite

		CARDS  = ['A','2','3','4','5','6','7','8','9','10','J','Q','K']
		VALUES = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]
		SUITES = ['DIAMONDS','CLUBS','SPADES','HEARTS']
		SYM_VALUE_MAP = {
			:ace => 1,:two => 2,:three => 3,:four => 4,
			:five => 5,:six => 6,:seven => 7,
			:eight => 8,:nine => 9,:ten => 10,
			:jack => 10,:queen => 10,:king => 10,
		}

		class << self
			SYM_VALUE_MAP.each do |k,v|
				define_method k do |suite|
					self.new(k,suite)
				end
			end
		end

		def initialize(value, suite)
			case value
			when Symbol
				@value = SYM_VALUE_MAP[value]
			else
				@value = value
			end
			@suite = suite
		end

		def ace?
			@value == 1
		end

		def to_i
			@value
		end

		def to_s
			"#{@value} of #{@suite}"
		end
	end

	class Deck

		def initialize
			@cards = []
			Card::SUITES.each do |suite|
				Card::VALUES.each do |value|
					@cards << Card.new(value, suite)
				end
			end
		end

		def cards_remaining
			@cards.count
		end

		def shuffle
			@cards.shuffle!
		end

		def get_next
			if @cards.empty?
				raise EmptyDeckError
			end
			@cards.shift
		end
	end
end
