require_relative 'script_helpers'
require_relative 'script_helpers'
require_relative 'script_helpers'

class CVEUpdateSkeleton

  def run
    cve_ymls.each do |yml_file|
      cve = File.open(yml_file) { |f| YAML.load(f) }
      cve = cve_skeleton_data.merge(cve)
      cve['unit_tested']['question'] = cve_skeleton_data['unit_tested']['question']
      cve['discovered']['question'] = cve_skeleton_data['discovered']['question']
      cve['subsystem']['question'] = cve_skeleton_data['subsystem']['question']
      cve['interesting_commits']['question'] = cve_skeleton_data['interesting_commits']['question']
      cve['mistakes']['question'] = cve_skeleton_data['mistakes']['question']
      cve['lessons']['question'] = cve_skeleton_data['lessons']['question']
      cve['major_events']['question'] = cve_skeleton_data['major_events']['question']
      cve['description_instructions'] = cve_skeleton_data['description_instructions']
      cve['fixes_vcc_instructions'] = cve_skeleton_data['fixes_vcc_instructions']
      File.open(yml_file, 'w+') { |f| f.write cve.to_yaml }
    end
  end
end
