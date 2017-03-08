require 'yaml'

class ReviewsToFixes

  # Iterate over the CVE YAMLs and find the commit(s) for every code
  # review fix.
  def run
    Dir['cves/*.yml'].each do |yml_file|
      dirty = false
      cve = File.open(yml_file) { |f| YAML.load(f) }
      cve['reviews'].each do |review_id|
        puts "Looking up #{review_id}..."
        Dir.chdir('tmp/src') do
          out = `git log -1 --pretty="%H" --grep="codereview.chromium.org/#{review_id}$"`.strip
          if is_git_hash?(out) && !already_have?(out, cve)
            cve['fixes'] << out
            dirty = true
            puts "Found! #{out}"
          end
        end
      end unless cve['reviews'].nil?
      File.open(yml_file, 'w+') { |f| cve.to_yaml } if dirty
    end
  end

  def is_git_hash? str
    str =~ /^[a-f0-9]{40}$/ # matches a git hash
  end

  def already_have?(str, cve)
    (!cve['fixes'].nil?) && (cve['fixes'].include?(str))
  end

end
