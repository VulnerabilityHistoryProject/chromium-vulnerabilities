require 'git'
require 'optparse'
require 'logger'
require 'json'

options = {}
options[:environment] = '../'
options[:output] = '../commits/'

OptionParser.new do |opts|
  opts.banner = "Usage: pretty-print.rb -e environment -f firstcommit -l lastcommit"
  opts.on('-e v', '--environment v', 'Environment') {|v| options[:environment] = v}
  opts.on('-f f', '--firstcommit f', 'First Commit') {|f| options[:firstcommit] = f}
  opts.on('-l l', '--lastcommit l', 'Last Commit') {|l| options[:lastcommit] = l}
  opts.on('o o', '--outdir o', 'Output Dir') {|o| options[:output] = o}
end.parse!

g = Git.open(options[:environment])


if options[:firstcommit] && options[:lastcommit]
  commits = g.log.between(options[:firstcommit], options[:lastcommit])
else
  commits = g.log
end

json_array = []
files_hash = {}

commits.each do |x|
  json = {}
  json[:commit] = x
  json[:author] = x.author.name
  json[:email] = x.author.email
  json[:date] = x.author.date
  json[:parent] = x.parent.sha
  json[:message] = x.message.gsub('\n', '\\n').gsub('"', '&quot')
  json[:insertions] = g.diff(x, x.parent.sha).insertions
  json[:deletions] = g.diff(x, x.parent.sha).deletions
  stats = g.diff(x, x.parent.sha).stats
  g.gtree(x).diff(x.parent.sha).each do |f|
    file_churn = stats[:files][f.path]
    churn = file_churn[:insertions] + file_churn[:deletions]
    files_hash[f.path] = churn
  end
  json[:filepaths] = files_hash
  json_array.push(JSON.generate(json))
  files_hash.clear
end

File.open(options[:output] + 'gitlog.json', 'w') { |file| file.write(JSON.pretty_generate(json_array).gsub('\"','"').gsub('"{','{').gsub('}"','}'))}