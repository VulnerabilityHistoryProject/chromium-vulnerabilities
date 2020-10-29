require 'yaml'

class UpdateCurated

  # Iterate over the CVE YAMLs and set curation_level: 1 on ones that "look" curated.
  # THIS IS A ONE-TIME TASK! From now on, it'll be in the skeleton anyway.
  def run
    Dir['cves/*.yml'].each do |yml_file|
      cve = File.open(yml_file) { |f| YAML.load(f) }
      if curated?(cve) # has description? curated.
        cve['curated'] = true
        File.open(yml_file, 'w+') { |f| f.write cve.to_yaml }
      end
    end
  end

  def curated?(cve)
     !cve['description'].to_s.empty?
  end
end
