
class MastermindBoard
  #attr_accessor :ball

  def initialize
    puts "Let's play Mastermind!"
    $guessed_correctly = false;
    sleep(1)
  end

  # def beginning
    
    # puts "Are there 1 or 2 players?"
    # numOfPlayers = gets.chomp();
    # if (numOfPlayers == 1)
    #   {
    #     puts "Do you want to be the Code Maker or the Code Breaker?"
    #   }
    # elsif (numOfPlayers == 2) 
    #   {
    #     puts "Okay Player 1, choose your balls."
    #     player1 = CodeMaker.new()
    #   } 
  # end
end

class CodeMaker
  
  def chooseColors()
  color_list = ["white", "red", "yellow", "blue", "green", "black"]
  ball1 = color_list.sample
  ball2 = color_list.sample
  ball3 = color_list.sample
  ball4 = color_list.sample
  @@chosen_balls = [ball1, ball2, ball3, ball4]
  puts @@chosen_balls
  puts "The balls have been selected 
          O O O O"
  return @@chosen_balls
  end
3
  def checkGuess(guessed_balls)
    #p("Before: " + guessed_balls.to_s)
    white_peg = 0
    for i in 0..3
      if guessed_balls[i].eql?(@@chosen_balls[i])
        puts "white peg"
        white_peg += 1
        guessed_balls[i] = "used"  
      else
        for a in -3..5
          if i + a < 4 && i + a >= 0 && guessed_balls[i] == @@chosen_balls[i+a]
            guessed_balls[i] = "used"
            puts "red peg"
          end
        end
      end
      #p("Chosen: " + @@chosen_balls.to_s)
      #p(guessed_balls)
    end
    return white_peg
  end
end

class CodeBreaker
  
  def initialize
    @@guessed_balls = Array.new
  end

  def guess
    for i in 1...5
      puts "What is the color of the #" + i.to_s + " ball? (white, red, yellow, blue, green, black)"
        ball = gets.chomp().downcase();
        @@guessed_balls[i-1] = ball
    end
      return @@guessed_balls
  end
end

class Game

start = MastermindBoard.new
computer = CodeMaker.new
chosen = computer.chooseColors()
player = CodeBreaker.new
guesses = 1
while guesses < 3 && $guessed_correctly == false
  puts "Turn: #" + guesses.to_s
  returned = player.guess()
  white_peg = computer.checkGuess(returned)
  guesses += 1
  if white_peg == 4
    puts "You won!"
    exit
  end
end
puts "You lose"
puts "The answer was: " + chosen.to_s
puts "Thanks for playing!"
exit
end
