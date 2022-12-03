# frozen_string_literal: true

require 'optparse'

def main
  params = ARGV.getopts('lwc').transform_keys(&:to_sym)
  files = ARGV
  texts = files.empty? ? [$stdin.read] : files.map { |file| File.read(file) }
  number_lists = word_count(texts, params)
  number_lists_with_space = add_space(number_lists)
  number_lists_with_filename = add_filename(files, number_lists_with_space)
  show(files, number_lists_with_filename)
end

def word_count(texts, params)
  number_lists = texts.map do |str|
    numbers = []
    numbers << count_lines(str) << count_words(str) << count_bytes(str) if params.values.none?
    numbers << count_lines(str) if params[:l]
    numbers << count_words(str) if params[:w]
    numbers << count_bytes(str) if params[:c]
    numbers
  end
  texts.size > 1 ? calculate_total(number_lists) : number_lists
end

def count_lines(texts)
  texts.count("\n")
end

def count_words(texts)
  texts.split(/\s+/).size
end

def count_bytes(texts)
  texts.bytesize
end

def calculate_total(number_lists)
  total_numbers = number_lists.transpose.map(&:sum)
  number_lists.push(total_numbers)
end

def add_space(number_lists)
  number_lists.map do |number_list|
    number_list.map do |number|
      number.to_s.rjust(8)
    end
  end
end

def add_filename(files, number_lists_with_space)
  number_lists_with_space.each_with_index do |number_list_with_space, i|
    number_list_with_space.push(" #{files[i]}")
  end
end

def show(files, number_lists_with_filename)
  number_lists_with_filename.each_with_index do |number_list_with_filename, i|
    if files.size > 1 && i == number_lists_with_filename.size - 1
      puts "#{number_list_with_filename.join} total"
    else
      puts number_list_with_filename.join
    end
  end
end

main
