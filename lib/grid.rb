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

  def layout
    puts(@rows.map { |row| " #{row.join(' | ')} " }.join("\n---+---+---\n"))
  end

  def empty?(row, column)
    @rows[row][column] == ' '
  end

  def full?
    @rows.each { |row| return false if row.include?(' ') }
  end

  def check_rows
    3.times do |row|
      return @rows[row][0] if @rows[row][0] + @rows[row][1] + @rows[row][2] =~ /XXX|OOO/
    end

    nil
  end

  def check_columns
    3.times do |column|
      return @rows[0][column] if @rows[0][column] + @rows[1][column] + @rows[2][column] =~ /XXX|OOO/
    end

    nil
  end

  def check_diagonals
    2.times do |parameter|
      return @rows[1][1] if @rows[0][2 * parameter] + @rows[1][1] + @rows[2][2 - 2 * parameter] =~ /XXX|OOO/
    end

    nil
  end

  def winner?
    check_rows || check_columns || check_diagonals
  end

  def end?
    winner? || full?
  end
end
