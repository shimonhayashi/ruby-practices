# frozen_string_literal: true

require 'date'
require 'optparse'

def option_parse
  options = {}
  OptionParser.new do |opts|
    opts.on('-y', '--year YEAR') do |v|
      options[:year] = v.to_i
    end
    opts.on('-m', '--month MONTH') do |v|
      options[:month] = v.to_i
    end
  end.parse!

  options
end

def calendar(year: Date.today.year, month: Date.today.month)
  firstday = Date.new(year, month, 1) # 月の最初の日
  lastday = Date.new(year, month, -1) # 月の最終日
  dt = Date.today # 今日
  first_wday = firstday.wday # 曜日を返す (0-6、日曜日は零)。ただし最初日が1のため、実質は1-7

  puts firstday.strftime('%m月 %Y').center(20) # 中央寄り
  puts '日 月 火 水 木 金 土'
  print ' ' * 3 * first_wday # 最初日をスペース(3bytes)でずらす。putsは改行するため、改行しないprint

  (firstday..lastday).each do |date| # 1~最終日まで繰り返し
    if date == dt # 今日の日付だったら
      print "\e[31m" # 赤色にする
      print "#{date.day.to_s.rjust(2)} "
      print "\e[0m" # 元の色に戻す
    else
      print "#{date.day.to_s.rjust(2)} " # 日付を文字列＋右寄せ＋数字の間にスペースで表示
      print "\n" if date.wday == 6 # 土曜日まで表示したら改行。実質土==7
    end
  end
  print "\n" if lastday.wday != 6 # 最終日が土曜日以外改行しないための処理
end

calendar(**option_parse) # **とすると定義にない引数を受け取れる
