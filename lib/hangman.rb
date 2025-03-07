def load_dictionary
  file_path = File.expand_path("../word_list.txt", __dir__)  # Correct path from lib/
  words = File.readlines(file_path, chomp: true)  # Read all words into an array

  # Filter words that are between 5 and 12 characters
  filtered_words = words.select { |word| word.length.between?(5, 12) }

  # Select a random word
  secret_word = filtered_words.sample
  return secret_word
end