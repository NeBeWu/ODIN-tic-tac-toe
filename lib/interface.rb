# frozen_string_literal: true

#
# The +Interface+ module acts as the game interface. It provides methods...
#
module Interface
  def intro_message
    puts 'Welcome to Ruby Tic Tac Toe!'
  end

  def get_name_message(number)
    "Player #{number + 1}, please enter your name."
  end

  def set_marker_message(name, marker)
    "Thank you #{name}. Your marker will be #{marker}."
  end

  def get_input_message(name)
    "It is your turn #{name}."
  end

  def error_message
    'Invalid input!'
  end

  def end_game_message(winner)
    winner ? "Congratulations #{winner}, you won!" : 'It is a draw!'
  end
end
