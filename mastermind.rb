
class MastermindBoard

  def initialize
    @player_choice = 'Unknown'
  end
  
  #Lets player decide what role they want to play
  def get_player_choice()
    until @player_choice.include?('Breaker') || @player_choice.include?("Maker") do
      puts "Do you want to be the Code 'Maker' or the 'Breaker'?"
      @player_choice = gets.chomp().split(/ |\_/).map(&:capitalize).join(" ")
    end
      puts "Okay, you are the #{@player_choice}"
      return @player_choice
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

  attr_accessor :color_list

  def initialize()
    @all_pegs = Array.new
    @chosen_balls = []
    @color_list = ["white", "red", "yellow", "blue", "green", "pink"]
    @all_answers = @color_list.repeated_permutation(4).to_a
  end
 

  #Computer chooses balls either as code breaker or code maker
  def comp_choose_colors()
    @chosen_balls = 4.times.map { @color_list.sample }
    #puts "These are the chosen balls:" +  @chosen_balls.to_s
    return @chosen_balls
  end

  def comp_guess_colors(guesses, all_pegs)
    if guesses == 1
      return @chosen_balls = ['red', 'red', 'pink', 'pink']
    end
    @all_answers.delete_if do |answer|
      answer == @chosen_balls
    end
    if all_pegs.length() == 0
      @chosen_balls.each do |ball|
        @all_answers.reject! do |possibility_arr|
          possibility_arr.include?(ball)
        end 
      end    
    elsif all_pegs.include?("white peg")
      @all_answers.delete_if do |answer|
        answer[0] != @chosen_balls[0] && answer[1] != @chosen_balls[1] && answer[2] != @chosen_balls[2] && answer[3] != @chosen_balls[3]
          end
    elsif all_pegs.include?("red peg")  
      if all_pegs.none? { |peg| peg == "white peg" }
        for i in 0...4 do
          @all_answers.delete_if do |answer|
              answer[i] == @chosen_balls[i]
          end
        end
      end
    end
    #print  @all_answers
    #print "\n"
    puts "Possible answers left: " +  @all_answers.length.to_s  
    random = rand(0...@all_answers.length())
    @chosen_balls =  @all_answers[random]
  end

  #Checks to see i f the code breaker's balls is the same as the code maker's balls
  def check_guess(balls_picked, guessed_balls, player_choice)
    white_peg = 0
    @all_pegs.clear
    temps_guessed = [guessed_balls[0], guessed_balls[1], guessed_balls[2], guessed_balls[3]]
    temps_picked = [balls_picked[0], balls_picked[1], balls_picked[2], balls_picked[3]]
    for i in 0...4
      if temps_guessed[i].eql?(temps_picked[i])
        temps_picked[i] = "used"
        temps_guessed[i] = "used"
        @all_pegs.append("white peg")
        white_peg += 1
        if white_peg == 4
          if player_choice == "Breaker"
            puts "You won!"
          else
            puts "Computer won!"
          end
        exit
        end
      end
    end
    for i in 0...4
      for j in 0...4
        if temps_guessed[i].eql?(temps_picked[j]) && temps_picked[j] != "used" && temps_guessed[i] != "used"
          temps_picked[j] = "used"
          temps_guessed[i] = "used"
          @all_pegs.append("red peg")
          break
        end
      end
    end
      print "The computer returned: " + @all_pegs.shuffle.to_s + "\n"
      puts ""
      return @all_pegs
  end 
end 

#Player class

class Human
  
  def initialize
    @guessed_balls = Array.new
  end

  #Returns what balls the player choses as the code maker or the code breaker
  def human_choose_colors(color_list)
    i = 1
    while i < 5
      puts "What is the color of the #" + i.to_s + " ball? (white, red, yellow, blue, green, pink)"
        ball = gets.chomp().downcase().strip();
        if color_list.any? {|color| color == ball } # ball == "blue" || ball == "pink" || ball == "white" || ball == "red" || ball == "green" || ball == "yellow"
          @guessed_balls[i-1] = ball
          i += 1
        else
          puts "You typed in an incorrect color, please try again"
        end  
    end
    return @guessed_balls
  end
end

#Game class
class Game
  puts "Let's play Mastermind!"
  sleep(1)
  # Start of game for player
  start = MastermindBoard.new
  puts ""
  player_choice = start.get_player_choice()
  puts ""
  cmp = Computer.new
  human = Human.new
  color_list = cmp.color_list
  # If the player is the code breaker
  if player_choice.include?('Breaker')
    balls_picked = cmp.comp_choose_colors()
    puts "The balls have been selected 
          O O O O"
    puts ""
    puts "If you recieve a 'red peg' it means you have one right ball but in the wrong position."
    puts "If you recieve a 'white peg' it means you have one right ball in the right position."
    puts"If you have four white pegs, you win!"
    guesses = 1
    #loops 12 times to allow the player to guess
    while guesses < 13
      puts ""
      puts "Turn: #" + guesses.to_s + " out of 12"
      guessed_balls = human.human_choose_colors(color_list)
      puts ""
      start.update_balls(guessed_balls)
      all_pegs = cmp.check_guess(balls_picked, guessed_balls, player_choice)
      guesses += 1
    end
    puts "You lose"
    puts "The answer was: " + balls_picked.to_s
   exit
  # If the player chose to be the code maker
  else
    balls_picked = human.human_choose_colors(color_list)
    guesses = 1
    #Loops 12 times to allow computer to guess
    while guesses < 13
      guess = cmp.comp_guess_colors(guesses, all_pegs)
      puts "Turn: #" + guesses.to_s + " out of 12"
      start.update_balls(guess)
      all_pegs = cmp.check_guess(balls_picked, guess, player_choice)
      guesses += 1
    end
    puts "You won, the computer didn't figure out your answer!"
    exit
  end
end
