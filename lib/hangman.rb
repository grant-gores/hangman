def load_dictionary
  file_path = File.expand_path("../word_list.txt", __dir__)  # Correct path from lib/
  words = File.readlines(file_path, chomp: true)  # Read all words into an array

  # Filter words that are between 5 and 12 characters
  filtered_words = words.select { |word| word.length.between?(5, 12) }

  # Select a random word
  secret_word = filtered_words.sample
  return secret_word
end

def play_game
  puts "Welcome to Hangman!"
  puts "--------------------------------------------------"
  puts "After eight wrong letter guesses the game will end."
  puts "One wrong full word guess and the game is over!"
  puts "--------------------------------------------------"

  secret_word = load_dictionary  # Get the word
  word_display = Array.new(secret_word.length, "_")  # Create a hidden word
  wrong_guesses = 0
  max_wrong_guesses = 8
  guessed_letters = []
  wrong_letters = []

  puts "Your word to guess: #{word_display.join(' ')}"

  loop do
    puts "Guess a letter or the entire word!"
    puts "Wrong guesses: #{wrong_letters}"
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

play_game