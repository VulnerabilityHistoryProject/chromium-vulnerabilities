require_relative 'script_helpers'
require_relative 'script_helpers'
require_relative 'script_helpers'

class CVEUpdateSkeleton

  def run
    cve_ymls.each do |yml_file|
      cve = File.open(yml_file) { |f| YAML.load(f) }
      cve = cve_skeleton_data.merge(cve)
      File.open(yml_file, 'w+') { |f| f.write cve.to_yaml }
    end
  end
end
