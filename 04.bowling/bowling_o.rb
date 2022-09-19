# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = []
scores.each do |s|
  if shots.size <= 17 && s == 'X' # 9フレーム目までのstrikeの処理
    shots << 10
    shots << 0
  elsif shots.size >= 18 && s == 'X' # 10フレーム目のstrikeの処理
    shots << 10
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

point = 0
frames.each_with_index do |frame, i| # each_with_indexでframesの順番を得る
  next_frame = frames[i + 1]
  point += if frame.size == 1 # 10フレームで3投の場合
             frame.sum
           elsif frame[0] == 10 && next_frame[0] == 10 && i <= 7 # 連続strike  8フレームよりも前フレームに適用
             10 + next_frame.sum + frames[i + 2][0]
           elsif frame[0] == 10 && i <= 8 # strike 9フレームよりも前フレームに適用
             10 + next_frame[0] + next_frame[1]
           elsif frame.sum == 10 && i <= 8 # spare 9フレームよりも前フレームに適用
             10 + next_frame[0]
           else
             frame.sum
           end
end
puts point
