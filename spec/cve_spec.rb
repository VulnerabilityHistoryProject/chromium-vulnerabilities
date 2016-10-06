require_relative 'spec_helper'
require 'yaml'

describe 'CVE data' do

  it 'is legal YAML' do
    Dir["#{cve_dir}/**/*.yml"].each do |file|
      expect(YAML.load(File.open(file))).to be_truthy
    end
  end

  

end
