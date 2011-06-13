#!/usr/bin/ruby

require File.dirname(__FILE__) + '/helper'

class PlayerTest < Test::Unit::TestCase

	include Blackjack::Strategies

	def setup
		@input = mock()
		@output = mock()
		@output.expects(:puts).at_least_once
		@wager = "10\n"
		@input.expects(:gets).once.returns(@wager)
		@handler = PlayerEventHandler.new(@input, @output)
		@player = Player.new('dan', @handler)
	end

	def test_get_wager
		assert_equal @wager.chomp, @player.get_wager
	end

	def test_get_wager_returns_last_wager
		@input.expects(:gets).once.returns(@wager, '')
		wager = @player.get_wager
		assert_equal wager, @player.get_wager
	end

end
