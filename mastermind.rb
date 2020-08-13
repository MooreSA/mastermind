module GameHelpers
  def generate_code
    Array.new(4) { Guess.new(rand(1..4)) }
  end
end

class Game
  include GameHelpers
  def initialize
    @turn_counter = 0
    @secret_code = SecretCode.new
    @board = Board.new
  end

  def display_board
    @board.secret_code.display
    @board.rows.each(&:display)
  end

  def get_guess(error = nil)
    puts(error) unless error.nil?
    puts('Enter your guess!')
    input = gets.chomp.to_i
    input = get_guess('Invalid Guess') unless input.between?(1, 4) # recursion is cool
    input
  end

  def save_guess(guess)
    @board.rows[-1 - (@turn_counter / 4)].guesses[@turn_counter % 4].set(guess)
    @turn_counter += 1
  end

  def check_win
    # todo
    false
  end

  def turn
    return win if check_win
    return lose if @turn_counter >= 48

    display_board
    save_guess(get_guess)
    generate_feedback if ((@turn_counter + 1) % 4).zero? # If just completed a row. Generate feedback for row
    turn # recursion is neat
  end

  def generate_feedback
    @board.generate_feedback(-1 - (@turn_counter / 4), @secret_code) # current row access through reverse index
  end

  def win; end

  def lose; end
end

class Board
  attr_reader :rows, :secret_code
  def initialize
    @secret_code = SecretCode.new
    @rows = Array.new(12) { Row.new }
  end

  def generate_feedback(row, secret_code)
    @rows[row].generate_feedback(secret_code)
  end
end

class Guess
  attr_reader :guess
  def initialize(guess = nil)
    @guess = guess
  end

  def display
    @guess.nil? ? print('- ') : print("#{@guess} ")
  end

  def set(guess)
    @guess = guess
  end
end

class Feedback
  attr_reader :feedback
  def initialize
    @feedback = nil
  end

  def display
    @feedback.nil? ? print('-') : print('TODO FEEDBACK')
  end
end

class Row
  attr_reader :guesses
  def initialize
    @guesses = Array.new(4) { Guess.new }
    @feedback = Array.new(4) { Feedback.new }
  end

  def display
    @guesses.each(&:display)
    print(' | ')
    @feedback.each(&:display)
    puts
  end

  def generate_feedback(secret_code)
    matches = []
    @guesses
  end
end

class SecretCode < Row
  include GameHelpers
  def initialize
    @guesses = generate_code
  end

  def display
    @guesses.each(&:display)
    puts
  end
end

new_game = Game.new
new_game.turn
