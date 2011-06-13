#!/usr/bin/ruby

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'rubygems'
require 'test/unit'
require 'mocha'
require 'blackjack'

ACE = Blackjack::Card.ace('D')
TWO = Blackjack::Card.two('D')
THREE = Blackjack::Card.three('D')
FOUR = Blackjack::Card.four('D')
FIVE = Blackjack::Card.five('D')
SIX = Blackjack::Card.six('D')
SEVEN = Blackjack::Card.seven('D')
EIGHT = Blackjack::Card.eight('D')
NINE = Blackjack::Card.nine('D')
TEN = Blackjack::Card.ten('D')
JACK = Blackjack::Card.jack('D')
QUEEN = Blackjack::Card.queen('D')
KING = Blackjack::Card.king('D')

BLACKJACK = Blackjack::Hand.new(ACE, TEN)
SOFT_17 = Blackjack::Hand.new(ACE, SIX)
TWENTY = Blackjack::Hand.new(TEN, TEN)
LOW_HAND = Blackjack::Hand.new(TWO, THREE)

module TestHelper
	include Blackjack

	def seed_blackjack
		seed_deck_with([ ACE, TWO, TEN, THREE ])
	end

	def seed_deck_with(cards)
		@deck.expects(:get_next).at_least_once.returns(*cards)
	end
end

Test::Unit::TestCase.send(:include, TestHelper)
