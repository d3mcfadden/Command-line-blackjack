#!/usr/bin/ruby

module Blackjack
	class Hand
		attr_reader :cards

		def initialize(*cards)
			@cards = []
			cards.each do |card|
				@cards << card
			end
		end

		def blackjack?
			if @cards.count != 2
				return false
			end
			if to_i == 21
				return true
			end
			false
		end

		def beats?(hand)
			if busted?
				return false
			elsif hand.busted?
				return true
			else
				return self.to_i > hand.to_i
			end
		end

		def busted?
			to_i > 21
		end

		def <<(card)
			@cards << card
		end

		def count
			@cards.count
		end

		def has_ace?
			not @cards.select { |c| c.value == 1 }.empty?
		end

		def to_i
			i = 0
			if @cards.count < 2
				return i
			end

			@cards.each do |c|
				if c.ace?
					if (i + 11) > 21
						i+= 1
					else
						i += 11
					end
				else
					i += c.to_i
				end
			end
			return i
		end

		def to_s
			"[#{to_i}] #{@cards.join(', ')}"
		end
	end

	module Gambler
		def get_wager
			@wager = @handler.get_wager.to_i
		end

		def pay!(amount)
		end
	end

	class PlayerEventHandler
		def initialize(input = STDIN, output = STDOUT)
			@input = input
			@output = output
		end

		def get_wager
			@output.puts "Enter you wager: "
			@wager = @input.gets.to_s.chomp
			if @wager.empty?
				@wager = last_wager
			end
			@last_wager = @wager
		end

		def puts(arg)
			@output.puts(arg)
		end

		def gets
			@input.gets
		end
	end

	class Player
		include Blackjack::Strategies
		include Gambler

		attr_accessor :hand, :handler, :wager

		def initialize(name, handler, hit_strategy = nil)
			@name = name
			@handler = handler
			@hand = Hand.new
			@standing = false
			@hit_strategy = hit_strategy || HitStrategy.new(handler)
		end

		def hit(card)
			@hand << card
		end

		def standing?
			@standing
		end

		def playing?
			not standing? and not @hand.busted?
		end

		def hit?(best)
			hit = @hit_strategy.hit?(self.hand, best.hand)
			if not hit
				@standing = true
			end
			hit
		end

		def beats?(player)
			@hand.beats?(player.hand)
		end

		def to_s
			@name
		end

		protected

		def dealer
			@players[0]
		end

	end

	class Dealer < Player
		include Blackjack::Strategies

		def initialize(name = 'dealer', hit_strategy = DealerHitStrategy.new)
			super(name, nil, hit_strategy)
		end
	end

end
