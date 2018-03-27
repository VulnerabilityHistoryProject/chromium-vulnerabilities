require_relative 'script_helpers'

class ListCVEData

  def print_fixes
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

  def get_fixes
    fixes = []
    cve_ymls.each do |yml_file|
      begin
        cve = File.open(yml_file) { |f| YAML.load(f) }
        cve['fixes'].each do |fix|
          sha = fix['commit'].to_s +
                fix[':commit:'].to_s +
                fix[:commit].to_s
          unless sha.strip.empty?
            fixes << sha
          end
        end
      rescue
        puts "ERROR on #{yml_file}"
        puts e.backtrace
      end
    end
    return fixes
  end

  def print_missing_fixes
    cve_ymls.each do |yml_file|
      cve = File.open(yml_file) { |f| YAML.load(f) }
      empty = true
      cve['fixes'].each do |fix|
        sha = fix['commit'].to_s +
              fix[':commit:'].to_s +
              fix[:commit].to_s
        empty = false unless sha.strip.empty?
      end
      puts cve['CVE'] if empty
    end
  end
end
