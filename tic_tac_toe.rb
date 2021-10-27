# frozen_string_literal: true

#
# The +Player+ class represents a Tic Tac Toe player. It provides methods for creating
# players and reading their data.
#
class Player
  attr_reader :name, :marker

  def initialize(name, marker)
    @name = name
    @marker = marker
  end
end

#
# The +Grid+ class represents a Tic Tac Toe grid. It provides methods for creating
# grids, access their entries, check the win and end conditions and print the grid
# layout in the command line.
#
class Grid
  def initialize
    @rows = Array.new(3) { Array.new(3, ' ') }
  end

  def [](row)
    @rows[row]
  end

  def []=(row, value)
    @rows[row] = value
  end

  def check_rows
    [0, 1, 2].cycle(1) do |row|
      return @rows[row][0] if @rows[row][0] + @rows[row][1] + @rows[row][2] =~ /XXX|OOO/
    end
  end

  def check_columns
    [0, 1, 2].cycle(1) do |column|
      return @rows[0][column] if @rows[0][column] + @rows[1][column] + @rows[2][column] =~ /XXX|OOO/
    end
  end

  def check_diagonals
    [0, 2].cycle(1) do |parameter|
      return @rows[1][1] if @rows[0][parameter] + @rows[1][1] + @rows[2][2 - parameter] =~ /XXX|OOO/
    end
  end

  def winner?
    check_rows || check_columns || check_diagonals
  end

  def end?
    winner? || @rows.each { |row| return false if row.include?(' ') }
  end

  def layout
    @rows.map { |row| " #{row.join(' | ')} " }.join("\n---+---+---\n")
  end
end

#
# The +Game+ class represents a Tic Tac Toe game. It provides methods for creating
# games, start game intro, initialize players and grid, collect players input and
# check for winners and game end.
#
class Game
  def initialize
    game_intro
    initialize_players
    initialize_grid
    main_routine
    game_end
  end

  def game_intro
    puts 'Welcome to Ruby Tic Tac Toe'
  end

  def initialize_players
    @players = []
    (0..1).each do |number|
      puts "Player #{number + 1}, please enter your name."
      name = gets.chomp
      marker = number.zero? ? 'X' : 'O'
      @players.push(Player.new(name, marker))
      puts "Thank you #{@players[number].name}. Your marker will be #{@players[number].marker}."
    end
  end

  def initialize_grid
    @grid = Grid.new
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
    puts "It is your turn #{@players[player].name}."
    input = valid_input
    @grid[input[0].to_i][input[1].to_i] = @players[player].marker
  end

  def valid_input
    loop do
      input = gets.chomp
      return input if @grid[input[0].to_i][input[1].to_i] == ' '

      puts 'Invalid input!'
    end
  end

  def game_end
    winner = @grid.winner?
    case winner
    when 'X'
      puts "Congratulations #{@players[0].name}, you won!"
    when 'O'
      puts "Congratulations #{@players[1].name}, you won!"
    else
      puts 'It is a draw!'
    end
  end
end

Game.new
