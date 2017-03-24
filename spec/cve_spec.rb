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

      it 'has valid git hashes commits in fixes, vccs, and interesting_commits' do
        vuln['fixes'].each do |fix|
          expect(fix['commit']).to(match(/[0-9a-f]{40}/).or(be_nil))
        end
        vuln['vccs'].each do |fix|
          expect(fix['commit']).to(match(/[0-9a-f]{40}/).or(be_nil))
        end
        vuln['interesting_commits']['commits'].each do |fix|
          expect(fix['commit']).to(match(/[0-9a-f]{40}/).or(be_nil))
        end
      end

      it 'has true, false, or nil in various places' do
        expect(vuln['unit_tested']['code']).to be(true).
                                             or(be(false)).
                                             or(be_nil)
        expect(vuln['unit_tested']['fix']).to be(true).
                                           or(be(false)).
                                           or(be_nil)
        expect(vuln['discovered']['automated']).to be(true).
                                                or(be(false)).
                                                or(be_nil)
        expect(vuln['discovered']['google']).to be(true).
                                                or(be(false)).
                                                or(be_nil)
        expect(vuln['lessons']['defense_in_depth']['applies']).to be(true).
                                                               or(be(false)).
                                                               or(be_nil)
        expect(vuln['lessons']['least_privilege']['applies']).to be(true).
                                                               or(be(false)).
                                                               or(be_nil)
        expect(vuln['lessons']['frameworks_are_optional']['applies']).to be(true).
                                                               or(be(false)).
                                                               or(be_nil)
        expect(vuln['lessons']['native_wrappers']['applies']).to be(true).
                                                               or(be(false)).
                                                               or(be_nil)
        expect(vuln['lessons']['distrust_input']['applies']).to be(true).
                                                               or(be(false)).
                                                               or(be_nil)
        expect(vuln['lessons']['security_by_obscurity']['applies']).to be(true).
                                                               or(be(false)).
                                                               or(be_nil)
        expect(vuln['lessons']['serial_killer']['applies']).to be(true).
                                                               or(be(false)).
                                                               or(be_nil)
        expect(vuln['lessons']['environment_variables']['applies']).to be(true).
                                                               or(be(false)).
                                                               or(be_nil)
        expect(vuln['lessons']['secure_by_default']['applies']).to be(true).
                                                               or(be(false)).
                                                               or(be_nil)
        expect(vuln['lessons']['yagni']['applies']).to be(true).
                                                               or(be(false)).
                                                               or(be_nil)
        expect(vuln['lessons']['complex_inputs']['applies']).to be(true).
                                                               or(be(false)).
                                                               or(be_nil)
      end

    end

  end

end
