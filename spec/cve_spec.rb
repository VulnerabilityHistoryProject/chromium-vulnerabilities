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

      cve_hash(file)['fixes'].each do |fix|
        it "has git log data for fix #{fix}" do
          expect(git_log_has?(fix)).to be true
        end
      end

      cve_hash(file)['vccs'].each do |vcc|
        vcc = vcc.keys[0] if vcc.respond_to? :keys
        it "has git log data for vcc #{vcc}" do
          expect(git_log_has?(vcc)).to be true
        end
      end

    end

  end

end
