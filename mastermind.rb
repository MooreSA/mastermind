class Game
  def initialize
    @turn_counter = 0
    @board = Board.new
  end

  def display_board
    @board.secret_code.display
    puts
    @board.rows.each(&:display)
  end

  def get_guess(error = nil)
    puts(error) unless error.nil?
    puts('Enter your guess!')
    input = gets.chomp.to_i
    input = get_guess('Invalid Guess') unless input.between?(1, 8) # recursion is cool
    input
  end

  def save_guess(guess)
    @board.rows[-1 - (@turn_counter / 4)].set(@turn_counter % 4, guess)
    @turn_counter += 1
  end

  def check_win
    @board.rows[-(@turn_counter / 4)].guesses == @board.secret_code.codes
  end

  def turn
    return lose if @turn_counter >= 48

    display_board
    save_guess(get_guess)
    if (@turn_counter % 4).zero?
      return win if check_win

      generate_feedback # If just completed a row. Generate feedback for row
    end
    turn # recursion is neat
  end

  def generate_feedback
    @board.generate_feedback(-(@turn_counter / 4)) # current row access through reverse index
  end

  def win
    puts 'You Win!'
  end

  def lose
    puts 'You Lose!'
  end
end

class Board
  attr_reader :rows, :secret_code
  def initialize
    @secret_code = SecretCode.new
    @rows = Array.new(12) { Row.new }
  end

  def generate_feedback(row)
    @rows[row].generate_feedback(@secret_code)
  end
end

class Row
  attr_reader :guesses, :feedback
  def initialize
    @guesses = Array.new(4) { nil }
    @feedback = Array.new(4) { nil }
  end

  def write_line(line)
    line.each do |item|
      item.nil? ? print('- ') : print("#{item} ")
    end
  end

  def display
    write_line(@guesses)
    print('| ')
    write_line(@feedback)
    puts
  end

  def set(num, input)
    @guesses[num] = input
  end

  def generate_feedback(secret_code)
    num_exact = exact_match(secret_code)
    num_color_match = color_match(secret_code)
    @feedback = ([0] * num_exact) + ([1] * (num_color_match - num_exact))
    @feedback.push(nil) until @feedback.length == 4
  end

  def exact_match(secret_code)
    codes = secret_code.codes
    matches = 0
    codes.each_index do |index|
      matches += 1 if codes[index] == @guesses[index]
    end
    matches
  end

  def color_match(secret_code)
    codes = secret_code.codes
    matches = codes.reduce(0) do |result, code|
      result += 1 if guesses.include?(code)
      result
    end
    matches
  end
end

class SecretCode < Row
  attr_reader :codes
  def initialize
    @codes = []
    gen_codes(8) until @codes.length == 4
  end

  def gen_codes(max)
    code = rand(1..max)
    @codes.push(code) unless @codes.include?(code)
  end

  def display
    @codes.each { |code| print("#{code} ") }
  end
end

Game.new.turn
