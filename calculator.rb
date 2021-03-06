#
# Simple Calculator
#

def is_valid_expression?(expression)
  regexp = /
    \A\d+\.?\d* # any number that contains only one decimal
    \s+         # white space after first number and before operand
    [\+\/\-\*]  # matches available operands
    \s+         # white space after first number and before operand
    \d+\.?\d*$  # any number that contains only one decimal
  /x

  (expression =~ regexp) == nil ? false : true
end

def display_intro_msg
  puts "=> Simple Calculator Rules:" \
       "\n * Currently only supports calculations on two digits" \
       "\n * Please include spaces before and after operand" \
       "\n * Integers can contain decimals" \
       "\n * valid operators: +, /, -, *" \
       "\n * Press [Ctrl + c] anytime to exit"
end

def calculate(expression)
  expression = expression.split()

  values = [expression[0].to_f, expression[2].to_f]

  operator = expression[1].to_sym

  solution = values.inject(operator)

  puts "=> Solution: #{solution.round(2)}\n\n"
end

def get_user_expression
  puts "\nPlease Enter expression: e.g(1 + 2 or 2.3 / 4.5)"

  input = gets.chomp
end

error_message = "ERROR: not a valid expression, please follow this format:" \
                "\n   e.g(1 + 5 or 2 / 5)\n\n"

display_intro_msg
loop do
  expression = get_user_expression
  if is_valid_expression?(expression)
    calculate(expression)
  else
    puts error_message
  end
end
