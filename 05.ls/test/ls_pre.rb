# frozen_string_literal: true

require 'optparse'

MAXIMUM_COLUMN = 3

def main
  params = ARGV.getopts('a')
  files = if params['a'] && ARGV[0]
            Dir.entries(ARGV[0]).sort
          elsif params['a']
            Dir.entries('.').sort
          else
            path = ARGV.size >= 1 ? File.join(ARGV[0], '*') : '*'
            Dir.glob(path)
          end
  count_file(files)
end

def count_file(files)
  total_files_count = files.size
  column_count = (total_files_count.to_f / MAXIMUM_COLUMN).ceil
  file_table = files.each_slice(column_count).to_a

  if file_table.size >= MAXIMUM_COLUMN && total_files_count % MAXIMUM_COLUMN != 0
    (MAXIMUM_COLUMN - total_files_count % MAXIMUM_COLUMN).times do
      file_table[-1] << ''
    end
  end
  show_files(file_table)
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
