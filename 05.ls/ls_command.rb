# frozen_string_literal: true

@path = ARGV[0]
MAXIMUM_COLUMN = 3

@files = if ARGV.size >= 1
           if @path.match?(%r{.+/})
             Dir.glob("#{@path}*")
           elsif @path.match?(%r{.+[^/]})
             Dir.glob("#{@path}/*")
           else
             Dir.glob('*')
           end
         else
           @path = ''
           Dir.glob('*')
         end

def main
  total_files_count = @files.size
  column_number = (total_files_count.to_f / MAXIMUM_COLUMN).ceil(0)
  columns = @files.each_slice(column_number).to_a
  # 配列ごとの最後に何もなかった場合'nil'を入れる
  if columns.size >= MAXIMUM_COLUMN && total_files_count % MAXIMUM_COLUMN != 0
    (MAXIMUM_COLUMN - total_files_count % MAXIMUM_COLUMN).to_i.times do
      columns[-1] << nil
    end
  end
  show_files(@files, columns)
end

def show_files(files, columns)
  longest_name = files.max_by(&:size)
  columns.transpose.each do |column|
    column.each do |column_show|
      print column_show.to_s.gsub(%r{#{@path}/*}, '').ljust(longest_name.size, ' ')
    end
    print "\n"
  end
end

main
