# frozen_string_literal: true

require 'optparse'
require 'etc'

MAXIMUM_COLUMN = 3
FILE_TYPE = { 'fifo' => 'p', 'characterSpecial' => 'c', 'directory' => 'd', 'blockSpecial' => 'b', 'file' => '-', 'link' => 'l', 'socket' => 's' }.freeze
PERMISSION = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }.freeze

def main
  params = ARGV.getopts('l')
  opt = OptionParser.new
  path = opt.parse(ARGV)[0] || '.'
  if params['l']
    file_data = []
    Dir.chdir(path) do
      file_data = make_l_option_file(path)
    end
    show_l_option(file_data)
  else
    files = Dir.glob('*', 0, base: path)
    file_table = make_file_table(files)
    show_files(file_table)
  end
end

def make_l_option_file(_path)
  file_data = []
  Dir.glob('*').map do |filename|
    file_info = File.lstat(filename)
    permission = file_info.mode.to_s(8)[-3, 3].chars.map { |str| PERMISSION[str] }.join
    link_to_file = " -> #{File.readlink(filename)}" if file_info.symlink?
    file_data << {
      blocks: file_info.blocks,
      file_type: FILE_TYPE[file_info.ftype],
      permission: permission,
      nlink: file_info.nlink,
      user_name: Etc.getpwuid(file_info.uid).name,
      group_name: Etc.getgrgid(file_info.gid).name,
      size: file_info.size,
      date: file_info.mtime.strftime('%_m %e %H:%M'),
      file_name: filename,
      link: link_to_file
    }
  end
  file_data
end

def show_l_option(file_data)
  max_nlink_size = file_data.max_by { |file_datum| file_datum[:nlink].size }[:nlink].size - 5
  max_username_size = file_data.max_by { |file_datum| file_datum[:user_name].size }[:user_name].size + 1
  max_groupname_size = file_data.max_by { |file_datum| file_datum[:group_name].size }[:group_name].size + 2
  max_size_size = file_data.max_by { |file_datum| file_datum[:size].size }[:size].size - 2
  puts "total #{file_data.sum { |file_datum| file_datum[:blocks] }}"
  file_data.each do |file_datum|
    print file_datum[:file_type]
    print file_datum[:permission].ljust(10)
    print file_datum[:nlink].to_s.rjust(max_nlink_size)
    print file_datum[:user_name].rjust(max_username_size)
    print file_datum[:group_name].rjust(max_groupname_size)
    print file_datum[:size].to_s.rjust(max_size_size)
    print " #{file_datum[:date]}"
    print " #{file_datum[:file_name]}"
    print file_datum[:link]
    print "\n"
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
