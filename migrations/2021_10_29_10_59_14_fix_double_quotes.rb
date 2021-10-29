require 'yaml'

# MIGRATION STATUS: Not done yet.
# raise 'Migration already performed.' # Don't run this migration. Kept for posterity

# This is just an example - edit to your liking.
# puts YAML.load(File.open('skeletons/cve.yml',).read).keys.join("\n")
def order_of_keys

  %w(
    CVE
    yaml_instructions
    curated_instructions
    curation_level
    reported_instructions
    reported
    announced_instructions
    announced
    published_instructions
    published
    description_instructions
    description
    bounty_instructions
    bounty
    reviews
    bugs
    repo
    fixes_vcc_instructions
    fixes
    vccs
    upvotes_instructions
    upvotes
    unit_tested
    discovered
    autodiscoverable
    specification
    subsystem
    interesting_commits
    i18n
    ipc
    lessons
    mistakes
    CWE_instructions
    CWE
    CWE_note
    nickname_instructions
    nickname
  )
end

ymls = Dir['cves/*.yml']
ymls.each do |yml_file|
  yml_str = File.open(yml_file, 'r').read
  # h = YAML.load yml_str

  File.open(yml_file, 'w+') do |f|
    f.write yml_str.gsub(/''(.+)''/, "'\\1'")
  end

  # Do stuff to your hash here.

  # Reconstruct the hash in the order we specify
  # out_h = {}
  # order_of_keys.each do |key|
  #   out_h[key] = h[key]
  # end

  # Generate the new YML, clean it up, write it out.
  # File.open(yml_file, "w+") do |file|
  #   yml_txt = out_h.to_yaml[4..-1] # strip off ---\n
  #   stripped_yml = ""
  #   yml_txt.each_line do |line|
  #     stripped_yml += "#{line.rstrip}\n" # strip trailing whitespace
  #   end
  #   file.write(stripped_yml)
  #   print '.'
  # end
end
puts 'Done!'
