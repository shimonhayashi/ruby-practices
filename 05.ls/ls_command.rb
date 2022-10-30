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
    file_informations = []
    Dir.chdir(path) do
      file_informations = l_option_file_information(path)
    end
    l_option_show(file_informations)
  else
    files = Dir.glob('*', 0, base: path)
    file_table = make_file_table(files)
    show_files(file_table)
  end
end

def l_option_file_information(path)
  file_informations = []
  Dir.glob('*').each do |filename|
    file_info = File.lstat(filename)
    permission = file_info.mode.to_s(8)[-3, 3].chars.map { |str| PERMISSION[str] }.join
    link_to_file = " -> #{File.readlink("#{path}#{filename}")}" if file_info.symlink?
    file_informations << {
      blocks: file_info.blocks, file_type: FILE_TYPE[file_info.ftype],
      permission: permission, nlink: file_info.nlink,
      user_name: Etc.getpwuid(file_info.uid).name, group_name: Etc.getgrgid(file_info.gid).name,
      size: file_info.size, date: file_info.mtime.strftime('%_m %e %H:%M'),
      file_name: filename, link: link_to_file
    }
  end
  file_informations
end

def l_option_show(file_informations)
  max_username_size = file_informations.max_by { |file_information| file_information[:user_name].size }[:user_name].size + 1
  max_groupname_size = file_informations.max_by { |file_information| file_information[:group_name].size }[:group_name].size + 2
  puts "total #{file_informations.sum { |file_information| file_information[:blocks] }}"
  file_informations.each do |file_information|
    print file_information[:file_type]
    print file_information[:permission]
    print format('%3d', file_information[:nlink])
    print format("%#{max_username_size}s", file_information[:user_name])
    print format("%#{max_groupname_size}s", file_information[:group_name])
    print format('%6d', file_information[:size])
    print " #{file_information[:date]}"
    print " #{file_information[:file_name]}"
    print file_information[:link]
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
