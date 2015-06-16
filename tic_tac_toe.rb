require 'pry'

# 1. Come up with requirements/specifications, which will determine the scope.
# 2. Application logic; sequence of steps
# 3. Translation of those steps into code
# 4. Run code to verify logic.

def board_configuration
  choices = {}

  (1..9).each { |i| choices[i] = " " }

  choices
end

def render_board(c)
  system('clear')

  puts " #{c[1]} | #{c[2]} | #{c[3]} "
  puts "-----------"
  puts " #{c[4]} | #{c[5]} | #{c[6]} "
  puts "-----------"
  puts " #{c[7]} | #{c[8]} | #{c[9]} "
end

def print_victory_message(c)
  if c == 'X'
    puts "Player Wins!"
  else
    puts "Computer Wins!"
  end

  true
end

def choice_not_taken?(c, choices)
  choices[c.to_i] == " "
end

def evaluate_row(c, *index)
  if (c[index[0]] =~ /[XO]/) != nil
    c[index[0]] == c[index[1]] && c[index[1]] == c[index[2]]
  else
    false
  end
end

def check_for_win(c)
  case
  when evaluate_row(c, 1, 2, 3) then print_victory_message(c[1])
  when evaluate_row(c, 4, 5, 6) then print_victory_message(c[4])
  when evaluate_row(c, 7, 8, 9) then print_victory_message(c[7])
  when evaluate_row(c, 1, 4, 7) then print_victory_message(c[1])
  when evaluate_row(c, 2, 5, 8) then print_victory_message(c[2])
  when evaluate_row(c, 3, 6, 9) then print_victory_message(c[3])
  when evaluate_row(c, 1, 5, 9) then print_victory_message(c[1])
  when evaluate_row(c, 3, 5, 7) then print_victory_message(c[3])
  else false
  end
end

def empty_positions(choices)
  choices.select {|k, v| v == ' ' }.keys
end

def player_makes_choice(choices)
  puts "Pick a square (1 - 9):"

  begin
    player_choice = gets.chomp
  end until choice_not_taken?(player_choice, choices)

  choices[player_choice.to_i] = "X"
end

def computer_makes_choice(choices)
  computer_choice = empty_positions(choices).sample

  choices[computer_choice] = "O"
end

choices = board_configuration
render_board(choices)
loop do
  player_makes_choice(choices)
  computer_makes_choice(choices)
  render_board(choices)
  winner = check_for_win(choices)
  break if winner || empty_positions(choices).empty?
end
