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
