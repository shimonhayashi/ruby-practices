# frozen_string_literal: true

@path = ARGV[0]

files = Dir.glob("#{@path}*")

MAXIMUM_COLUMN = 3.0
total_files_number = files.size

column_number = (total_files_number.to_f / MAXIMUM_COLUMN).ceil(0)

columns = files.each_slice(column_number).to_a

# 配列ごとの最後に何もなかった場合'nil'を入れる
if columns.size >= MAXIMUM_COLUMN && total_files_number % MAXIMUM_COLUMN != 0
  (MAXIMUM_COLUMN - total_files_number % MAXIMUM_COLUMN).to_i.times do
    columns[-1] << nil
  end
end

def show_files(files, columns)
  trans_columns = columns.transpose
  longest_name = files.max_by(&:size)
  trans_columns.each do |t|
    t.each do |s|
      print s.to_s.gsub(@path, '').ljust(longest_name.size, ' ')
    end
    print "\n"
  end
end

show_files(files, columns)
