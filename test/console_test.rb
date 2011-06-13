#!/usr/bin/ruby

require File.join(File.dirname(__FILE__), 'helper')

class ConsoleTest < Test::Unit::TestCase

	def setup
		@input = mock()
		@output = mock()
		@runner = Console::Runner.new(@input, @output)
	end

	def test_add_one_player_to_game
		@output.expects(:puts).at_least_once
		@input.expects(:gets).twice.returns('ADD dan', '')
		@runner.run
	end

end
