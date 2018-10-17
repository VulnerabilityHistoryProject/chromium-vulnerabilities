require 'byebug'
require 'yaml'
require 'active_support'
require 'active_support/core_ext'
require_relative 'script_helpers'
# Currently, our "curated: true" flag is not totally accurate.
# Let's just find CVEs that need to be curated with:
#  (a) an empty description, and
#  (b) at least one fix commit.
cve_ymls.each do |file|
  yml = YAML.load(File.open(file)).deep_symbolize_keys!
  if yml[:description].blank? && !yml[:fixes].empty?
    puts file
  end
end
