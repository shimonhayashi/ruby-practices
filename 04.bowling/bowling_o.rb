# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = []
NINE_FRAME = 9 # 9フレーム
SHOTS_PER_FRAME = 2 # 1フレームごとの最大投球数
SHOTS_PER_NINE_FRAME = (NINE_FRAME * SHOTS_PER_FRAME) # 9フレーム目までの最大投球数

scores.each do |s|
  if shots.size <= SHOTS_PER_NINE_FRAME - 1 && s == 'X' # 9フレーム目までのstrikeの処理
    shots << 10
    shots << 0
  elsif shots.size >= SHOTS_PER_NINE_FRAME && s == 'X' # 10フレーム目のstrikeの処理
    shots << 10
  else
    shots << s.to_i
  end
end

frames = shots.each_slice(2).to_a # 全投球を1フレーム2投球ずつに分割する

point = frames.each_with_index.sum do |frame, i| # each_with_index.sumでframesの合計と順番を得る
  next_frame = frames[i + 1]
  if i == 10 # 10フレームの3頭目の処理
    frame.sum
  elsif frame[0] == 10 && next_frame[0] == 10 && i + 1 < NINE_FRAME # 連続strikeの処理  8フレームよりも前フレームに適用
    10 + next_frame.sum + frames[i + 2][0]
  elsif frame[0] == 10 && i < NINE_FRAME # strikeの処理 9フレームよりも前フレームに適用
    10 + next_frame[0] + next_frame[1]
  elsif frame.sum == 10 && i < NINE_FRAME # spareの処理 9フレームよりも前フレームに適用
    10 + next_frame[0]
  else
    frame.sum
  end
end
puts point
