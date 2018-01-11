require_relative 'script_helpers'

class ListCVEFixes

  def run
    puts "CVE,commit"
    cve_ymls.each do |yml_file|
      begin
        cve = File.open(yml_file) { |f| YAML.load(f) }
        cve['fixes'].each do |fix|
          sha = fix['commit'].to_s +
                fix[':commit:'].to_s +
                fix[:commit].to_s
          unless sha.strip.empty?
            puts "#{cve['CVE']},#{sha}"
          end
        end
      rescue
        puts "ERROR on #{yml_file}"
        puts e.backtrace
      end
    end
  end
end
