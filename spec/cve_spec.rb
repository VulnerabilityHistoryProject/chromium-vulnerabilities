require_relative 'spec_helper'
require 'yaml'

describe 'CVE yml file' do

  cve_ymls.each do |file|

    context "#{File.basename(file)}" do
      it 'is legal YAML' do
        expect(YAML.load(File.open(file))).to be
      end

      let(:vuln) { YAML.load(File.open(file)) }

      it('has CVE key')   { expect(vuln).to include('CVE') }
      it('has fixes key') { expect(vuln).to include('fixes') }
      it('has vccs key')  { expect(vuln).to include('vccs') }

      it 'has valid git hashes commits in fixes' do
        vuln['fixes'].each do |fix|
          expect(fix['commit']).to(match(/[0-9a-f]{40}/).or(be_nil))
        end
      end

      # it 'has git commits in vccs'
      #
      # it 'has git commits in interesting commits'
      #
      # it 'has true, false, or nil in unit_test->code'
      #
      # it 'has true, false, or nil in unit_test->fix'
      #
      # it 'has true, false, or nil in discovered->automated'
      #
      # it 'has true, false, or nil in lessons->*->applies'

    end

  end

end
