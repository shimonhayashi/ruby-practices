# frozen_string_literal: true

require 'optparse'

def main
  params = ARGV.getopts('lwc').transform_keys(&:to_sym)
  files = ARGV
  texts = files.empty? ? [$stdin.read] : files.map { |file| File.read(file) }
  number_lists = word_count(texts, params)
  number = make_list(files, number_lists)
  number_with_files = add_filename(files, number)
  show_list(number_with_files)
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
  number_lists << total_numbers
end

def make_list(files, number_lists)
  lines = number_lists.map do |number_list|
    number_list.map do |number|
      number.to_s.rjust(8)
    end
  end
  files.empty? ? add_filename(files, lines) : lines
end

def add_filename(files, number)
  files.each_with_index do |file, i|
    number[i] << " #{file}"
  end
  number.last << ' total' if files.size > 1
  number
end

def show_list(number_with_files)
  number_with_files.each { |number_with_file| puts number_with_file.join }
end

main
