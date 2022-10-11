# frozen_string_literal: true

MAXIMUM_COLUMN = 3

def main
  path = if ARGV.size >= 1
           File.join(ARGV[0], '*')
         else
           '*'
         end
  files = Dir.glob(path)
  total_files_count = files.size
  column_count = (total_files_count.to_f / MAXIMUM_COLUMN).ceil
  columns = files.each_slice(column_count).to_a

  # 配列ごとの最後に何もなかった場合'nil'を入れる
  if columns.size >= MAXIMUM_COLUMN && total_files_count % MAXIMUM_COLUMN != 0
    (MAXIMUM_COLUMN - total_files_count % MAXIMUM_COLUMN).to_i.times do
      columns[-1] << nil
    end
  end
  show_files(columns)
end

def show_files(columns)
  longest_name = columns.flatten.max_by(&:size)
  columns.transpose.each do |file_tables|
    file_tables.each do |file_table|
      print File.basename(file_table.to_s).ljust(longest_name.size)
    end
    print "\n"
  end
end

main
