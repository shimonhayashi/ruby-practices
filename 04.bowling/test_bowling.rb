frames = [[10,11],[12,13]]

point = frames.each_with_index.sum do |frame, i| # each_with_indexでframesの順番を得る
p frame.sum
end
puts point
