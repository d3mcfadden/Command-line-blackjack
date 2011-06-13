#!/usr/bin/ruby

module Blackjack

	class BlackjackError < StandardError; end
	class Game

		CARDS_TO_DEAL = 2
		attr_reader :players, :dealer

		def initialize(deck, players)
			if players.count < 2
				raise BlackjackError.new 'There must be a dealer and one player to play'
			end

			@deck = deck
			@dealer = players.shift
			@players = players
		end

		def play
			@deck.shuffle
			deal
			ask_players
			resolve_dealer
			winners
		end

		def winners
			winners = []
			if @dealer.hand.busted?
				# everybody wins
				winners = @players
			else
				@players.each do |p|
					if p.beats?(@dealer)
						winners << p
					end
				end
				if winners.empty?
					winners << dealer
				end
			end
			winners
		end

		protected

		def winner
			winner = winning_player
			if @dealer.beats?(winner)
				winner = @dealer
			end
			winner
		end

		def deal
			CARDS_TO_DEAL.times.each do |i|
				players_with_dealer.each do |p|
					p.hit(@deck.get_next)
				end
			end
		end

		def ask_players
			begin
				@players.each do |p|
					begin
						if p.hit?(@dealer)
							p.hit(@deck.get_next)
						end
					end while p.playing?
				end
			end while open_hands?
		end

		def resolve_dealer
			begin
				if @dealer.hit?(winning_player)
					@dealer.hit(@deck.get_next)
				end
			end while @dealer.playing?
		end

		def open_hands?
			not @players.select { |p| p.playing? }.empty?
		end

		def players_with_dealer
			@all_players ||= Array.new(@players) << @dealer
		end

		def winning_player
			winner = @players.first
			@players.each do |p|
				if p.beats?(winner)
					winner = p
				end
			end
			winner
		end

	end

end
