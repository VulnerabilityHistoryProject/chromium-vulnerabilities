require 'yaml'
require 'open-uri'
require 'zlib'
require 'nokogiri'
require_relative 'pull_task_handler'

namespace :pull do
  desc "This task is used to examine .yml files for the absence of CVSS scores. If absences are detected the CVSS scores will be scraped from the relevant NVD XML and put into the yml file."
  task :cvss do
    cve_dir = './tmp/checkout/chromium-vulnerabilities/cves'
    nvd_base_url = 'http://nvd.nist.gov/view/vuln/detail?vulnId='
    xml_file_base = 'nvd-cve-2.0-'
    xml_dir = './tmp/xml/'
    xpath_cve_ref = '//vuln:cve-id[text()=\''
    xpath_base_ref = '\']/../vuln:cvss/cvss:base_metrics'

    unless Dir.exist?(cve_dir)
      puts "[ERROR] Chromium CVEs not found in /tmp/checkout/chromium-vulnerabilities as expected. Please clone the chromium repo if you have not already."
      return
    end

    loaded_cves = Pull_Task_Handler.load_cves(cve_dir)
    Pull_Task_Handler.download_xml

    for cve in loaded_cves

        #Pull information from XML
        xml_document = Nokogiri::XML(File.open(xml_dir + xml_file_base + year + '.xml'))
        xpath_base_query = xpath_cve_ref + cve['CVE'] + xpath_base_ref
        cvss_score = xml_document.xpath(xpath_base_query + '/cvss:score')
        access_vector = xml_document.xpath(xpath_base_query + '/cvss:access-vector')
        access_complexity = xml_document.xpath(xpath_base_query + '/cvss:access-complexity')
        authentication = xml_document.xpath(xpath_base_query +'/cvss:authentication')
        confidentiality_impact = xml_document.xpath(xpath_base_query +'/cvss:confidentiality-impact')
        integrity_impact = xml_document.xpath(xpath_base_query + '/cvss:integrity-impact')
        availability_impact = xml_document.xpath(xpath_base_query + '/cvss:availability-impact')
        cvss_source = nvd_base_url + cve['CVE']
        cvss_date = xml_document.xpath(xpath_base_query + '/cvss:generated-on-datetime')

        #Transfer information to YML file
        compiled_cvss = Hash.new
        compiled_cvss['score'] = cvss_score.text.to_f
        compiled_cvss['confidentiality'] = confidentiality_impact.text.downcase
        compiled_cvss['integrity'] = integrity_impact.text.downcase
        compiled_cvss['availability'] = availability_impact.text.downcase
        compiled_cvss['access_complexity'] = access_complexity.text.downcase
        compiled_cvss['authentication'] = authentication.text.downcase
        compiled_cvss['gained_access'] = access_vector.text.downcase
        compiled_cvss['source'] = cvss_source
        compiled_cvss['date_generated'] = cvss_date.text
        cve['cvss'] = compiled_cvss

        #Write modified YML file
        File.open(cve_dir + '/' + cve['CVE'] + '.yml', 'w') {|f| f.write cve.to_yaml}

      end
    end

    #delete XMLs since they're no longer needed
    File.delete(xml_dir)
  end
end