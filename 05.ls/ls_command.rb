# frozen_string_literal: true

MAXIMUM_COLUMN = 3

def main
  path = ARGV.size >= 1 ? File.join(ARGV[0], '*') : '*'
  files = Dir.glob(path)
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
  longest_name = file_table.flatten.max_by(&:size).size
  file_table.transpose.each do |file_paths|
    file_paths.each do |file_path|
      print File.basename(file_path).ljust(longest_name)
    end
    print "\n"
  end
end

main
