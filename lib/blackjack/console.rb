#!/usr/bin/ruby

module Blackjack
	module Console
		class AddPlayerCommandParser
			include Blackjack

			def initialize(input)
				@input = input
			end

			def execute
				_,name = @input.split(/ /)
				Player.new(name)
			end
		end

		class Runner
			def initialize(input = STDIN, output = STDOUT)
				@input = input
				@output = output
				@deck = Deck.new
				@dealer = Dealer.new 'dealer'
			end

			def run
				@output.puts 'Welcome to console Blackjack'
				@deck.shuffle
				@players = get_players
				@game = Game.new(@deck, players.unshift(@dealer))
				winners = @game.play
			end

			def get_players
				players = []
				player = get_player
				while player
					players << player
					player = get_player
				end
				players
			end

			protected

			def get_player
				@output.puts "Add players by issing the command ADD player_name"
				command = get_command
				if command.empty?
					return false
				end
				AddPlayerCommandParser.new(command).execute
			end

			def get_command
				@input.gets.chomp
			end
		end
	end
end
