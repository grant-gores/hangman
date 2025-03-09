def load_dictionary
  file_path = File.expand_path("../word_list.txt", __dir__)
  words = File.readlines(file_path, chomp: true)
  filtered_words = words.select { |word| word.length.between?(5, 12) }
  return filtered_words.sample
end

def save_game(secret_word, word_display, guessed_letters, wrong_guesses, wrong_letters)
  File.open("save_game.dat", "wb") do |file|
    Marshal.dump({ 
      secret_word: secret_word, 
      word_display: word_display, 
      guessed_letters: guessed_letters, 
      wrong_guesses: wrong_guesses, 
      wrong_letters: wrong_letters
    }, file)
  end
  puts "Game saved!"
end

def load_game
  if File.exist?("save_game.dat")
    File.open("save_game.dat", "rb") do |file|
      return Marshal.load(file)
    end
  else
    puts "No saved game found!"
    return nil
  end
end

def check_guess(secret_word, word_display, guess)
  correct = false
  secret_word.chars.each_with_index do |char, index|
    if char == guess
      word_display[index] = char
      correct = true
    end
  end
  return correct
end

def play_game
  puts "Welcome to Hangman!"
  puts "--------------------------------------------------"
  puts "After eight wrong letter guesses the game will end."
  puts "One wrong full word guess and the game is over!"
  puts "--------------------------------------------------"
  puts "Would you like to open one of your saved games? (Y/N)"
  
  saved_game = gets.downcase.chomp
  if saved_game == "y"
    saved_data = load_game
    if saved_data
      secret_word = saved_data[:secret_word]
      word_display = saved_data[:word_display]
      guessed_letters = saved_data[:guessed_letters]
      wrong_guesses = saved_data[:wrong_guesses]
      wrong_letters = saved_data[:wrong_letters]
    else
      secret_word = load_dictionary
      word_display = Array.new(secret_word.length, "_")
      guessed_letters = []
      wrong_guesses = 0
      wrong_letters = []
    end
  else
    secret_word = load_dictionary
    word_display = Array.new(secret_word.length, "_")
    guessed_letters = []
    wrong_guesses = 0
    wrong_letters = []
  end

  max_wrong_guesses = 8
  puts "Your word to guess: #{word_display.join(' ')}"

  loop do
    puts "Guess a letter or the entire word!"
    puts "Wrong guesses: #{wrong_letters.join(', ')}"
    guess = gets.downcase.chomp

    if guess.length == 1
      if guessed_letters.include?(guess)
        puts "You already guessed '#{guess}'. Try again."
        next
      end

      guessed_letters << guess
      correct = check_guess(secret_word, word_display, guess)

      if correct
        puts "Good job! The word now looks like: #{word_display.join(' ')}"
      else
        wrong_guesses += 1
        wrong_letters << guess
        puts "Incorrect! You have #{max_wrong_guesses - wrong_guesses} guesses left."
      end
    elsif guess.length == secret_word.length
      if guess == secret_word
        puts "Congratulations! You guessed the word: #{secret_word}"
        break
      else
        puts "Wrong guess! Game over. The word was: #{secret_word}"
        break
      end
    else
      puts "Enter a single letter or the entire word."
    end

    # Check win condition
    if word_display.join("") == secret_word
      puts "Congratulations! You guessed the word: #{secret_word}"
      break
    end

    # Check lose condition
    if wrong_guesses >= max_wrong_guesses
      puts "Game over! The word was: #{secret_word}"
      break
    end

    # Ask to save the game
    puts "Would you like to save the game? (Y/N)"
    save = gets.downcase.chomp
    if save == 'y'
      save_game(secret_word, word_display, guessed_letters, wrong_guesses, wrong_letters)
    end
  end
end

play_game
