# frozen_string_literal: true

require 'optparse'

def main
  params = ARGV.getopts('lwc').transform_keys(&:to_sym)
  files = ARGV
  texts = files.empty? ? [$stdin.read] : files.map { |file| File.read(file) }
  number_lists = word_count(texts, params)
  number_lists_with_space = add_space(number_lists)
  number_sum_list = calculate_total(number_lists)
  show(files, number_lists_with_space, number_sum_list)
end

def word_count(texts, params)
  texts.map do |str|
    numbers = []
    numbers << count_lines(str) << count_words(str) << count_bytes(str) if params.values.none?
    numbers << count_lines(str) if params[:l]
    numbers << count_words(str) if params[:w]
    numbers << count_bytes(str) if params[:c]
    numbers
  end
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
  number_sum_list = number_lists.transpose.map(&:sum)
  number_sum_list.map do |number|
    number.to_s.rjust(8)
  end
end

def add_space(number_lists)
  number_lists.map do |number_list|
    number_list.map do |number|
      number.to_s.rjust(8)
    end
  end
end

def show(files, number_lists_with_space, number_sum_list)
  number_lists_with_space.each_with_index do |number_list_with_space, i|
    puts "#{number_list_with_space.join} #{files[i]}"
  end
  number_sum_list.each do |number|
    print number if files.size > 1
  end
  puts ' total' if files.size > 1
end

main
