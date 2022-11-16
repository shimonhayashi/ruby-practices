require 'optparse'
opt = OptionParser.new

params = {}

opt.on('-a') { |v| v }
opt.on('-b') { |v| v }

opt.parse!(ARGV, into: params) # intoオプションにハッシュを渡す
p ARGV
p params
