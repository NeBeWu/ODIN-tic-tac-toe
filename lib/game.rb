# frozen_string_literal: true

require_relative 'player'
require_relative 'grid'
require_relative 'interface'

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
    game_start
    game_loop
    game_end
  end

  def game_start
    intro_message
    initialize_players
  end

  def initialize_players
    2.times do |number|
      @players.push(create_player(number))
    end
  end

  def create_player(number)
    name = get_name(number)
    marker = select_marker(number)
    set_marker_message(name, marker)

    Player.new(name, marker)
  end

  def get_name(number)
    get_name_message(number)
    gets.chomp
  end

  def select_marker(number)
    number.zero? ? 'X' : 'O'
  end

  def game_loop
    @grid.layout
    turn = 0
    until @grid.end?
      player_move(turn.%2)
      @grid.layout
      turn += 1
    end
  end

  def player_move(player)
    get_input_message(@players[player].name)
    slot = player_input
    @grid[slot.first][slot.last] = @players[player].marker
  end

  def player_input
    loop do
      slot = gets.chomp.chars.map(&:to_i)
      return slot if valid_slot?(slot)

      error_message
    end
  end

  def valid_slot?(slot)
    possible_slots = [[0, 0], [0, 1], [0, 2],
                      [1, 0], [1, 1], [1, 2],
                      [2, 0], [2, 1], [2, 2]]

    possible_slots.include?(slot) && @grid.empty?(*slot)
  end

  def game_end
    winner = @players.select { |player| player.marker == @grid.winner? }.first
    end_game_message(winner&.name)
  end
end
