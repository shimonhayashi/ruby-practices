# frozen_string_literal: true

require 'optparse'

MAXIMUM_COLUMN = 3

def main
  files = attribute
  file_table = slice_column(files)
  show_files(files, file_table)
end

def attribute
  params = ARGV.getopts('a')
  opt = OptionParser.new
  path = opt.parse(ARGV)[0]
  a_flag = params['a'] ? File::FNM_DOTMATCH : 0
  Dir.glob('*', a_flag, base: path).sort
end

def slice_column(files)
  column_count = (files.size.to_f / MAXIMUM_COLUMN).ceil
  files.each_slice(column_count).to_a
end

def show_files(files, file_table)
  (MAXIMUM_COLUMN - files.size % MAXIMUM_COLUMN).times { file_table[-1] << '' } if file_table.size >= MAXIMUM_COLUMN && files.size % MAXIMUM_COLUMN != 0
  column_width = file_table.flatten.max_by(&:size).size
  file_table.transpose.each do |file_paths|
    file_paths.each do |file_path|
      print File.basename(file_path).ljust(column_width)
    end
    print "\n"
  end
end

main
