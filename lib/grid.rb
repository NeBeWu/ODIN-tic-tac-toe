# frozen_string_literal: true

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
