require 'pry'

def hand_value(card_arr)
	arr = card_arr.map {|e| e[0]}
	total = 0
	arr.each do |value|
		if value == "A"
			total += 11
		elsif value.to_i == 0 #J,Q,K
			total += 10
		else
			total += value.to_i
		end
	end

	#correct for aces
	arr.select{|e| e[0] == "A"}.count.times do
		total -= 10 if total > 21
	end

	total
end

def card_shuffle(players_name, n)
	suit = %w(D H S C)
  card_value = %w(2 3 4 5 6 7 8 9 10 J Q K A)
	cards = card_value.product(suit) * n.to_i
	puts "Shuffling ..."
	cards.shuffle!
	puts "#{players_name}, would you like to cut the cards? (y/n)"
	cuts_answer = gets.chomp
	if cuts_answer == "y"
		puts"At what card to cut? (1-#{n.to_i*51})"
		cut_location = gets.chomp
		if cut_location.to_i > 1 && cut_location.to_i < (n.to_i*51)
			cards.rotate!(cut_location.to_i)
		else
			puts"Sorry, #{players_name} cut location out of range, not cut"
		end 
	end
	puts "Dealer burns first card..."
	cards.pop
	public
	cards
end

puts "Welcome to BlackJack Ruby Style!"
puts "What is your name?"
players_name = gets.chomp
if players_name == ""
	players_name = "Player"
end
puts "How many deck would you like to play with? (1-6)"
deck_number = gets.chomp

if deck_number.to_i > 6 || deck_number.to_i < 1 
	deck_number = 1
	puts "#{player_name}, invalid entry, you will be playing with one deck."
end

cards = card_shuffle(players_name, deck_number)

puts"-----------------------------------------------------------"
puts"                       Good Luck"
puts"Dealer stays on all 17s.  Dealer doesn't take cards after "
puts"you bust.  Dealer can tie your BlackJack with a BlackJack"
puts"The cards will be dealt until 15 left in the deck then it"
puts"will shuffle.  No splitting of cards. You can take a card"
puts "with any total below 22. After each hand you will be ask"
puts "if you want to play again."
puts"___________________________________________________________"


	#replay loop start here
play = true	
while play
	dealer_busted = false
	busted = false
	hits = true 
	players_blackjack = false
	dealer_hits = true
	cards_left = cards.length
	dealers_hand = []
  players_hand = []
	
	if cards_left < 15 
		puts "Time to shuffle" 
		cards = card_shuffle(players_name, deck_number) 
	end
	
	puts "Here come the cards..."
	puts "#{players_name} gets: \t#{cards.last}"
	players_hand << cards.pop
	puts "Dealer gets: \t#{cards.last}"
	dealers_up_card = cards.last
	dealers_hand << cards.pop
	puts "#{players_name} gets: \t#{cards.last}"
	players_hand << cards.pop
	puts "Dealer gets last card down"
	dealers_hand << cards.pop

	#checK for black jacks
	if hand_value(players_hand) == 21
		puts "#{players_name}, you have BlackJack!!!"
		hits = false
		dealer_hits = false
	end
  
  if hand_value(dealers_hand) == 21
		puts "Dealer has BlackJack!!"
		hits = false
		dealer_hits = false
	end
	
	while hits == true
		puts "#{players_name} has #{hand_value(players_hand)}"
		puts "Dealer is showing #{dealers_up_card} for a showing total of #{hand_value([dealers_up_card])}"
		#binding.pry
		puts "#{players_name}, what would you like to do? (h for a hit, s to stay)"
		action = gets.chomp
		if action == "h"
			puts "#{players_name} gets: \t#{cards.last}"
			players_hand << cards.pop
		else
			hits = false
		end
		if hand_value(players_hand) > 21
			puts"#{players_name} you BUSTED!!"
			hits = false
			dealer_hits = false
			busted = true
		end
	end

	puts "Dealer flips over down card showing: #{dealers_hand[1]}."
	
	while dealer_hits == true
		puts "Dealers total #{hand_value(dealers_hand)}"
		if hand_value(dealers_hand) >= 17 && hand_value(dealers_hand) <= 21
			dealer_hits = false
		end
		
		if hand_value(dealers_hand) > 21
			puts "Dealer BUSTED!!!"
			dealer_hits = false
			dealer_busted = true
		end

		if hand_value(dealers_hand) < 17
			puts "Dealer gets: \t#{cards.last}"
			dealers_hand << cards.pop
		end
		

	end
	if busted == false && dealer_busted == false
		puts"#{players_name} total:\t \t#{hand_value(players_hand)}"
		puts"Dealers total:\t \t#{hand_value(dealers_hand)}"
	end
	if (hand_value(players_hand) > hand_value(dealers_hand) && busted == false) || dealer_busted == true
		puts"#{players_name} WINS!!!"
	elsif hand_value(players_hand) == hand_value(dealers_hand)
			puts"TIE "
	else
		puts "Sorry #{players_name}, you LOSE."
	end



puts "#{players_name} play again?"
play_answer = gets.chomp
if play_answer == "y"
	play = true
	puts"-----------------------------------------------------------"
	puts"                       Good Luck"
	puts"___________________________________________________________"
else
	play = false
end
end #play