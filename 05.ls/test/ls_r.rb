# frozen_string_literal: true

require 'optparse'

MAXIMUM_COLUMN = 3

def main
  files = parse_files
  file_table = make_file_table(files)
  show_files(file_table)
end

def parse_files
  params = ARGV.getopts('r')
  opt = OptionParser.new
  path = opt.parse(ARGV)[0]
  if params['r']
    Dir.glob('*', 0, base: path).sort.reverse
  else
    Dir.glob('*', 0, base: path).sort
  end
end

def make_file_table(files)
  row_count = (files.size.to_f / MAXIMUM_COLUMN).ceil
  files.each_slice(row_count).to_a.map do |file_paths|
    file_paths.fill('', file_paths.size, row_count - file_paths.size)
  end
end

def show_files(file_table)
  column_width = file_table.flatten.max_by(&:size).size
  file_table.transpose.each do |file_paths|
    file_paths.each do |file_path|
      print File.basename(file_path).ljust(column_width)
    end
    print "\n"
  end
end

main
