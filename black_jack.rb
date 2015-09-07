require 'pry'
cards = ['A', 'K', 'Q', 'J', '10', '9', '8', '7', '6', '5', '4', '2']
suits = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
DECK = cards.product(suits)

def deal_cards(quantity, hand = [])
  if hand.empty?
    quantity.times do
      hand << DECK.sample
    end
  else
    quantity.times do
      hand << DECK.sample
    end
  end

  hand
end

def display_hand(hand, player)
  puts "#{player}'s Cards:"

  hand.length.times do |i|
    puts "#{hand[i][0]} #{hand[i][1]}"
  end
end

def display_score(score)
  if score.kind_of?(Array)
    puts "Scores with Ace: #{score[0]}, #{score[1]}"
  else
    puts "Score: #{score}"
  end
end

def update_score(hand)
  values = hand.flatten.map do |v|
    v = "10" if v =~ /[JQK]/
    v.to_i
  end

  if hand.flatten.include?('A')
    score = [values.inject(:+) + 1, values.inject(:+) + 11]
  else
    score = values.inject(:+)
  end
end

def black_jack_or_bust?(score, player, dealer = false)
  if !dealer
    win_msg = "BlackJack! #{player} Wins!"
    bust_msg = "Bust! Dealer Wins!"
  else
    win_msg = "Dealer has BlakJack! #{player} Loses!"
    bust_msg = "Dealer Busts! #{player} Wins!"
  end

  if score.kind_of?(Array)
    if score.include?(21)
      puts win_msg
      return true
    elsif score[0] > 21 && score[1] > 21
      puts bust_msg
      return true
    else
      return false
    end
  else
    if score == 21
      puts win_msg
      return true
    elsif score > 21
      puts bust_msg
      return true
    else
      return false
    end
  end
end

def hit_or_stay(score)
  if score.kind_of?(Array)
    if score[0] <= 17 || score[1] <= 17
      return true
    else
      return false
    end
  else
    if score <= 17
      return true
    else
      return false
    end
  end
end

def sanitize_score(score)
  if score.kind_of?(Array)
    score.keep_if { |v| v < 21 }.join.to_i
  else
    score
  end
end

def compare_scores(d_score, p_score, players_name)
  dealer_win_msg = "Dealer Wins!"
  player_win_msg = "#{players_name} Wins!"
  dealer_score = sanitize_score(d_score)
  player_score = sanitize_score(p_score)

  if dealer_score > player_score
    puts dealer_win_msg
  elsif dealer_score == player_score
    puts dealer_win_msg
  else
    puts player_win_msg
  end
end

def prompt_to_play_again
  puts "Would you like to play again?(y/n)"
  ready = gets.chomp
end

def prompt_for_name
  puts "Please Enter a Name:"
  gets.chomp
end

def prompt_for_hit_stay
  puts "Would you like to Hit or Stay?(h/s)"
  gets.chomp
end

puts "Welcome to BlackJack!"
puts "Are you ready to begin?(y/n)"
play = gets.chomp

while play == "y"
  players_name = prompt_for_name
  puts ""

  players_hand = deal_cards(2)
  system("clear")
  display_hand(players_hand, players_name)
  player_score = update_score(players_hand)
  display_score(player_score)
  player_black_jack_or_bust = black_jack_or_bust?(player_score, players_name)

  if player_black_jack_or_bust
    play = prompt_to_play_again
  else
    hit_stay = prompt_for_hit_stay

    while hit_stay == "h"
      deal_cards(1, players_hand)
      system("clear")
      display_hand(players_hand, players_name)
      player_score = update_score(players_hand)
      display_score(player_score)

      if black_jack_or_bust?(player_score, players_name)
        break
      end

      hit_stay = prompt_for_hit_stay
    end

    if hit_stay == "s"
      # puts ""
      dealers_hand = deal_cards(2)
      display_hand(dealers_hand, "Dealer")
      dealer_score = update_score(dealers_hand)
      display_score(dealer_score)
      hit_stay = hit_or_stay(dealer_score)
      # if hit_stay
      while hit_stay
        deal_cards(1, dealers_hand)
        dealer_score = update_score(dealers_hand)
        display_score(dealer_score)
        hit_stay = hit_or_stay(dealer_score)
        break if !hit_stay
      end

      if !black_jack_or_bust?(dealer_score, players_name, true)
        compare_scores(dealer_score, player_score, players_name)
      end
    end
  end

  puts ""
  play = prompt_to_play_again
end
