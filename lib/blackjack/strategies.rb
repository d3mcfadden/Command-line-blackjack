#!/usr/bin/ruby

module Blackjack
	module Strategies

		class HitStrategy
			def initialize(handler)
				@handler = handler
			end

			# defer to the user, unless they have blackjack
			def hit?(hand, dealer_hand = nil)
				if hand.blackjack?
					return false
				end
				ask_user
			end

			protected
			def ask_user
				@handler.puts 'Would you like to stay or hit [y or n]?'
				while true
					choice = @handler.gets.chomp.upcase
					if ['Y','N'].include?(choice)
						return choice == 'Y'
					end
					@handler.puts "Unknown choice, try again"
				end
			end
		end

		# dealer must stand on soft 17
		class DealerHitStrategy
			def hit?(hand, best_hand)
				if hand.has_ace?
					if hand.to_i == 17
						# soft 17, stand
						return false
					end
				elsif hand.beats?(best_hand)
					# dealer is winning, stay
					return false
				elsif not hand.beats?(best_hand)
					# dealer is loosing, hit
					return true
				else
					return true
				end
			end
		end

	end
end
