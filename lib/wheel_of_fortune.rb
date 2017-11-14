require 'ffaker'

class WheelOfFortune
  attr_reader :theme, :guesses

  def initialize quest = {theme: "vegetable" ,phrase: FFaker::Food.vegetable}
    @phrase = quest[:phrase]
    @theme = quest[:theme]  
    @guesses = []
    @game_on = true
    while !@phrase.match(/^[[:alpha:][:blank:]]+$/)
      @phrase = FFaker::Food.vegetable
    end
    clear
    while @game_on
      play
    end
  end

  def clear
    system "clear"
  end

  def to_s
    phrase_to_return = @phrase
    @phrase.each_char do |c|
      if !@guesses.include?(c.downcase) && c != " "
        phrase_to_return = phrase_to_return.gsub(/#{c}/, "_")
      end
    end
    phrase_to_return
  end

  def print_current
    clear
    print "letters guessed: |"
    @guesses.sort!.each do |c|
      print " #{c.upcase} |"
    end
    print "\n#{to_s}\n"
  end

  def can_i_have?(input="")
    if !input.match(/^[[:alpha:]]$/)
      puts "Invalid input! One letter at a time :)"
      return
    end
    if @guesses.include?(input.downcase)
      puts "You've already tried #{input}!"
      return
    end
    input.downcase!
    @guesses.push input
    print_current
    if @phrase.downcase.include?(input)
      letter_count = @phrase.downcase.scan(/(?=#{input})/).count
      if letter_count > 1
        puts "There are #{letter_count} #{input.upcase}s"
      else
        puts "There is 1 #{input.upcase}"
      end
      if game_over? then puts "You Win!" end
      true
    else
      puts "Nope"
      false
    end
  end

  def game_over?
    phrase_so_far = to_s
    phrase_so_far.include?("_") ? false : true
  end

  def play
    if game_over?
      puts "You Won! Press any key to end"
      y = gets.chomp
      @game_on = false
      return
    end
    puts "Guess a letter: "
    c = gets.chomp
    can_i_have?(c)
    true
  end
end


# Checks to see if we executed this file from the command-line
# e.g. `ruby simple_jepordy.rb`
if __FILE__ == $0

  # DRIVER CODE
  j = WheelOfFortune.new( {theme: "card games", phrase: "Go fish"} )
  j.can_i_have?("g")
  j.can_i_have?("o")
  p j
  #puts j # calls j.to_s
  p j.to_s
  p j.guesses

end
