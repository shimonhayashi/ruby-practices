require 'optparse'
OPTS = {}
parser = OptionParser.new
parser.version = '0.0.1'
parser.on('-u user', '--user') { |v| OPTS[:u] = v }
parser.on('-p password', '--password') { |v| OPTS[:p] = v }
parser.on('-s [server]', '--server') do |v|
  v = if !v.nil?
        v
      else
        '998'
      end
end

parser.parse!(ARGV)
p ARGV[0]
p OPTS
