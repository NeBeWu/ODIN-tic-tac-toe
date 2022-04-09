# frozen_string_literal: true

#
# The +Game+ class represents a Tic Tac Toe game. It provides methods for creating
# games, start game intro, initialize players and grid, collect players input and
# check for winners and game end.
#
class Game
  include Interface

  def initialize
    @players = []
    @grid = Grid.new
  end

  def play
    intro_message
    initialize_players
    main_routine
    game_end
  end

  def initialize_players
    (0..1).each do |number|
      puts get_name_message(number)
      name = gets.chomp
      marker = number.zero? ? 'X' : 'O'
      @players.push(Player.new(name, marker))
      puts set_marker_message(@players[number].name, @players[number].marker)
    end
  end

  def main_routine
    print_grid
    turn = 0
    until @grid.end?
      get_input(turn.%2)
      print_grid
      turn += 1
    end
  end

  def print_grid
    puts @grid.layout
  end

  def get_input(player)
    puts get_input_message(@players[player].name)
    input = valid_input
    @grid[input[0].to_i][input[1].to_i] = @players[player].marker
  end

  def valid_input
    loop do
      input = gets.chomp
      possible_inputs = %w[00 01 02 10 11 12 20 21 22]
      return input if possible_inputs.include?(input) && @grid[input[0].to_i][input[1].to_i] == ' '

      puts error_message
    end
  end

  def game_end
    winner = @players.select { |player| player.marker == @grid.winner? }
    puts end_game_message(winner[0]&.name)
  end
end
