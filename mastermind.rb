module GameHelpers
  def generate_code
    Array.new(4) { rand(1..4) }
  end
end

class Game
  include GameHelpers
  def initialize
    @secret_code = SecretCode.new
    @board = Board.new
  end

  def display_board
    @board.rows.each(&:display)
    puts
  end
end

class Board
  attr_reader :rows
  def initialize
    @rows = Array.new(12) { Row.new }
  end
end

class Guess
  def initialize
    @guess = nil
  end

  def display
    @guess.nil? ? print('-') : print(@guess)
  end
end

class Feedback
end

class Row
  attr_reader :guesses
  def initialize
    @guesses = Array.new(4) { Guess.new }
  end

  def display
    @guesses.each(&:display)
    puts
  end
end

class SecretCode < Row
  include GameHelpers
  def initialize
    @guesses = generate_code
    guesses.each(&:display)
    puts
  end
end

Game.new.display_board
