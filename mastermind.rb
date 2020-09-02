
class MastermindBoard

  def initialize
    puts "Let's play Mastermind!"
    $guessed_correctly = false;
    sleep(1)
  end
  
  #Lets player decide what role they want to play
  def get_player_choice()
    @player_choice = 'Unknown'
    until @player_choice == 'code breaker' || @player_choice == 'code maker' do
      puts "Do you want to be the 'Code Maker' or the 'Code Breaker'?"
      @player_choice = gets.chomp().downcase
    end
    if @player_choice == 'code breaker'
      puts "Okay, you are the Code Breaker"
      return @player_choice
    else
      puts "Okay, you are the Code Maker"
      return @player_choice
    end
  end     
  
  #Shows depiction of what balls were chosen by the player
  def update_balls(returned)
    print "The guess was: "
    for i in 0..3
      case returned[i]
      when 'green'
        print "(G)"
      when 'red'
        print "(R)" 
      when 'yellow'
        print "(Y)"
      when 'blue'
        print "(B)"
      when 'pink'
        print "(P)"  
      when 'white'  
        print "(W)"
      else
        puts "Not working"
      end
    end
    puts "\n"
  end   
 
end

class Computer
  
  #Initializing class variables
  def initialize()
    temp_balls = Array.new
    @@ball1 = 'blank'
    @@ball2 = 'blank'
    @@ball3 = 'blank'
    @@ball4 = 'blank'
    @@color_list = ["white", "red", "yellow", "blue", "green", "pink"]
  end

  #Computer chooses balls either as code breaker or code maker
  def comp_choose_colors(all_pegs = ['empty'])
    if all_pegs[0] != 'empty' && all_pegs.length() == 0
      for i in 0..@@color_list.length()
        @@chosen_balls.each do |chosen_ball|
          if chosen_ball.eql?(@@color_list[i])
            @@color_list.delete_at(i)
          end
        end
      end
    end  
    @@ball1 = @@color_list.sample
    @@ball2 = @@color_list.sample
    @@ball3 = @@color_list.sample
    @@ball4 = @@color_list.sample
    @@chosen_balls = [@@ball1, @@ball2, @@ball3, @@ball4]
  return @@chosen_balls
  end

  #Checks to see if the code breakers balls is the same as the code maker's balls
  def check_guess(balls_picked, guessed_balls)
    white_peg = 0
    all_pegs = Array.new
    @balls_picked = [balls_picked[0], balls_picked[1], balls_picked[2], balls_picked[3]]
    for i in 0...4
      if guessed_balls[i].eql?(@balls_picked[i])
        @balls_picked[i] = "used"
        guessed_balls[i] = "used"
        all_pegs.append("white peg")
        white_peg += 1
      end
    end
    guessed_balls.each do |guessed_ball|
      @balls_picked.each do |ball_picked|
        if guessed_ball.eql?(ball_picked) && ball_picked != "used" && guessed_ball != "used"
          ball_picked = "used"
          guessed_ball = "used"
          all_pegs.append("red peg")
          break
        end
      end
    end
    print "The computer returned: " + all_pegs.shuffle.to_s + "\n"
    return all_pegs
  end
end  

#Player class

class Human
  
  def initialize
    @@guessed_balls = Array.new
  end

  #Returns what balls the player choses as the code maker or the code breaker
  def human_choose_colors()
    i = 1
    while i < 5
      puts "What is the color of the #" + i.to_s + " ball? (white, red, yellow, blue, green, pink)"
        ball = gets.chomp().downcase().strip();
        if ball == "blue" || ball == "pink" || ball == "white" || ball == "red" || ball == "green" || ball == "yellow"
          @@guessed_balls[i-1] = ball
          i += 1
        else
          puts "You typed in an incorrect color, please try again"
        end  
    end
    return @@guessed_balls
  end

end

#Game class
class Game
  #Start of game for player
  start = MastermindBoard.new
  player_choice = start.get_player_choice()
  #If the player chose to be the code breaker
  if player_choice == 'code breaker'  
    cmp = Computer.new
    balls_picked = cmp.comp_choose_colors()
    puts "The balls have been selected 
          O O O O"
    guesses = 1
    #loops 12 times to allow the player to guess
    while guesses < 13 && $guessed_correctly == false
      puts "Turn: #" + guesses.to_s + " out of 12"
      human = Human.new
      guessed_balls = human.human_choose_colors()
      start.update_balls(guessed_balls)
      all_pegs = cmp.check_guess(balls_picked, guessed_balls)
      guesses += 1
      white_peg = 0
      for i in 0..all_pegs.length()
        if all_pegs[i].eql?("white peg")
          white_peg += 1
          if white_peg == 4
            puts "You won!"
            exit
          end
        end
      end
    end
    puts "You lose"
    puts "The answer was: " + balls_picked.to_s
   exit
  #If the player chose to be the code maker
  else
    human = Human.new
    balls_picked = human.human_choose_colors()
    guesses = 1
    cmp = Computer.new
    #Loops 12 times to allow computer to guess
    while guesses < 13 && $guessed_correctly == false
      guess = cmp.comp_choose_colors()
      puts "Turn: #" + guesses.to_s + " out of 12"
      start.update_balls(guess)
      all_pegs = cmp.check_guess(balls_picked, guess)
      guesses += 1
      cmp.comp_choose_colors(all_pegs)
    end
    puts "You won, the computer didn't figure out your answer!"
    exit
  end
end
