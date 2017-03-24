require 'yaml'

class CVECommits

  # Iterate over CVE yaml files and find every reference to a commit, then look up the commit in the Git log and append it to the file
  def run
    cve_ymls.each do |yml_file|
      cve = File.open(yml_file) { |f| YAML.load(f) }
      cve['fixes'].each do |fix|
        store(fix['commit']) unless fix['commit'].to_s.empty?
      end
      cve['vccs'].each do |vcc|
        store(vcc['commit']) unless vcc['commit'].to_s.empty?
      end
      cve['interesting_commits']['commits']&.each do |int_commit|
        unless int_commit['commit']&.to_s.empty?
          store(int_commit['commit'])
        end
      end
    end
  end

  def store(hash)
    %w(src v8).each do |repo|
      Dir.chdir("tmp/#{repo}") do
        out = `#{git_log_cmd} -1 #{hash} 2>&1`
        if $?.exitstatus == 0 # found the commit!
          File.open("../../#{gitlog_txt}", 'a') { |f| f.write out}
          return # done! return
        end
      end
    end
    puts "ERROR: Unable to find commit data for #{hash} in src, v8, or blink"
  end

end
