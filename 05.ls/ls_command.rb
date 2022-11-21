# frozen_string_literal: true

require 'optparse'
require 'etc'

MAXIMUM_COLUMN = 3
FILE_TYPE = { 'fifo' => 'p', 'characterSpecial' => 'c', 'directory' => 'd', 'blockSpecial' => 'b', 'file' => '-', 'link' => 'l', 'socket' => 's' }.freeze
PERMISSION = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }.freeze

def main
  params = parse_params
  dot_include_files = show_dot_file(params)
  files = reverse_sort_order(dot_include_files, params)
  if params['l']
    Dir.chdir(params['argv'] || '.') do
      file_data_list = make_detailed_file_info(files)
      show_detailed_information(file_data_list)
    end
  else
    file_table = make_file_table(files)
    show_files(file_table)
  end
end

def parse_params
  params = ARGV.getopts('arl')
  params['argv'] = ARGV[0]
  params
end

def show_dot_file(params)
  flags = params['a'] ? File::FNM_DOTMATCH : 0
  path = params['argv'] || '.'
  Dir.glob('*', flags, base: path)
end

def reverse_sort_order(dot_include_files, params)
  params['r'] ? dot_include_files.reverse : dot_include_files
end

def make_detailed_file_info(files)
  files.map do |filename|
    file_info = File.lstat(filename)
    permission = file_info.mode.to_s(8)[-3, 3].chars.map { |str| PERMISSION[str] }.join
    link_to_file = " -> #{File.readlink(filename)}" if file_info.symlink?
    {
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
end

def show_detailed_information(file_data_list)
  max_nlink_size = file_data_list.map { |file_data| file_data[:nlink].to_s.size }.max
  max_username_size = file_data_list.map { |file_data| file_data[:user_name].size }.max
  max_groupname_size = file_data_list.map { |file_data| file_data[:group_name].size }.max
  max_size_size = file_data_list.map { |file_data| file_data[:size].to_s.size }.max
  puts "total #{file_data_list.sum { |file_data| file_data[:blocks] }}"
  file_data_list.each do |file_data|
    print file_data[:file_type]
    print "#{file_data[:permission]} "
    print "#{file_data[:nlink].to_s.rjust(max_nlink_size)} "
    print "#{file_data[:user_name].ljust(max_username_size)}  "
    print "#{file_data[:group_name].ljust(max_groupname_size)}  "
    print "#{file_data[:size].to_s.rjust(max_size_size)} "
    print "#{file_data[:date]} "
    print "#{file_data[:file_name]} "
    print file_data[:link]
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
