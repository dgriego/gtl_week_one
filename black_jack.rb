# Constants
BLACKJACK = 21

# Helper Methods
def initialize_deck
  cards = ['A', 'K', 'Q', 'J', '10', '9', '8', '7', '6', '5', '4', '2']
  suits = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
  cards.product(suits)
end

def prompt_for_name
  puts "Please Enter a Name:"
  gets.chomp
end

def deal(quantity, hand, deck)
  quantity.times do
    hand << deck.pop
  end
end

def display_hand(hand, player, start_of_game = false)
  puts "--------- #{player.upcase}'s Cards ------------"

  if start_of_game && player == "Dealer"
    puts "=> #{hand[0][0]} of #{hand[0][1]}"
  else
    hand.each do |e|
      puts "=> #{e[0]} of #{e[1]}"
    end
  end
end

def calculate_total(hand) # [["D", "A"], ["S", "Q"]]
  card_values = hand.flatten.map do |e|
    e = "10" if e =~ /[JQK]/
    e = "11" if e =~ /A/
    e.to_i
  end # [11, 10, 3]

  total = card_values.inject(:+)

  # Correct for aces
  hand.flatten.select { |e| e == "A" }.count.times do
    total -= 10 if total > BLACKJACK
  end

  total
end

def display_total(total)
  puts "Total: #{total}"
  puts ""
end

# Start Game

puts "Welcome to BlackJack!"
puts "Are you ready to begin?(y/n)"
play = gets.chomp
players_name = prompt_for_name
puts ""

while play == "y"
  system("clear")

  # Deal Cards
  deck = initialize_deck
  deck.shuffle!

  players_hand = []
  dealers_hand = []
  blackjack = false
  bust = false

  deal(2, players_hand, deck)
  deal(2, dealers_hand, deck)

  # Show Cards
  system("Clear")
  display_hand(players_hand, players_name)
  player_total = calculate_total(players_hand)
  display_total(player_total)

  display_hand(dealers_hand, "Dealer", true)
  dealer_total = calculate_total(dealers_hand)

  # Check for blackjack
  if player_total == BLACKJACK
    puts "#{players_name} hit blackjack! #{players_name} wins!"
    next
  elsif dealer_total == BLACKJACK
    display_total(dealer_total)
    puts "Sorry #{players_name}, dealer hit blackjack! You lose."
    next
  end

  # Player turn
  puts ""
  puts "#{players_name}, it's your turn"
  while player_total < BLACKJACK
    puts "Would you like to 1) Hit or 2) Stay?"
    hit_or_stay = gets.chomp

    if !["1", "2"].include?(hit_or_stay)
      puts "Please Enter a 1 or 2..."
      next
    end

    if hit_or_stay == "2"
      puts "You chose to stay..."
      break
    end

    system("clear")
    deal(1, players_hand, deck)
    display_hand(players_hand, players_name)
    player_total = calculate_total(players_hand)
    display_total(player_total)
    display_hand(dealers_hand, "Dealer", true)
    puts ""

    if player_total == BLACKJACK
      blackjack = true
      puts "#{players_name} hit blackjack! #{players_name} wins!"
      next
    elsif player_total > BLACKJACK
      bust = true
      puts "Sorry #{players_name}, it looks like you busted!"
      next
    end
  end

  if !blackjack && !bust
    # Dealer Turn
    while dealer_total < 17
      system("clear")

      # Hit
      puts "Dealer hits..."
      puts ""
      deal(1, dealers_hand, deck)
      display_hand(players_hand, players_name)
      display_total(player_total)
      display_hand(dealers_hand, "Dealer")
      dealer_total = calculate_total(dealers_hand)
      display_total(dealer_total)

      if dealer_total == BLACKJACK
        blackjack = true
        puts "Sorry #{players_name}, dealer hit blackjack! You lose."
        next
      elsif dealer_total > BLACKJACK
        bust = true
        puts "Congratulations, dealer busted! #{players_name} Wins!"
        next
      end
    end
  end

  if !blackjack && !bust
    system("clear")
    # Compare Hands
    display_hand(players_hand, players_name)
    display_total(player_total)
    display_hand(dealers_hand, "Dealer")
    display_total(dealer_total)

    if player_total > dealer_total
      puts "#{players_name} Wins!"
    elsif player_total < dealer_total
      puts "Sorry #{players_name}, Dealer Wins!"
    else
      puts "Tie Game!"
    end
  end

  puts "#{players_name}, Would you like to play again?(y/n)"
  play = gets.chomp
end
