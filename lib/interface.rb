# frozen_string_literal: true

#
# The +Interface+ module acts as the game interface. It provides methods...
#
module Interface
  def intro_message
    puts 'Welcome to Ruby Tic Tac Toe!'
  end

  def get_name_message(number)
    puts "Player #{number + 1}, please enter your name."
  end

  def set_marker_message(name, marker)
    puts "Thank you #{name}. Your marker will be #{marker}."
  end

  def get_input_message(name)
    puts "It is your turn #{name}."
  end

  def error_message
    puts 'Invalid input!'
  end

  def end_game_message(winner)
    puts(winner ? "Congratulations #{winner}, you won!" : 'It is a draw!')
  end
end
