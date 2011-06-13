#!/usr/bin/ruby


module Blackjack
	class GameManager

		def initialize(deck, dealer, players)
			@deck = deck
			@dealer = dealer
			@players = players
			@game = Game.new(deck, players.unshift(dealer))
		end

		def run
			@deck.shuffle
			@players.each do |player|
				player.get_wager
			end
			@game.play
			pay_winners
		end

		protected

		def pay_winners
			@game.winners.each do |winner|
				winner.pay!(winner.wager)
			end
		end

	end
end
