#Methods found here are general use methods for pulling information from XMLs and putting them in CVEs
require_relative('pull_cvss_methods')
require('rake/clean')

class Pull_Task_Handler
  def self.load_cves(cve_dir)
    loaded_cves = []

    for name in Dir.glob("#{cve_dir}/*.yml")
      loaded_cve = begin
        YAML.load(File.open(name))
      rescue ArgumentError => e
        puts "Could not parse YAML: #{e.message}"
      end
      loaded_cves.push(loaded_cve)
    end

    return loaded_cves
  end

  def self.modify_yml(loaded_cves, type)
    for cve in loaded_cves
        if type == 'cvss'
          if cve['cvss'].nil?
            year = cve['CVE'].match(/CVE-([0-9]{4})-[0-9]{4}/)[1]
            xml = 'tmp/xml/nvd-cve-2.0-' + year + '.xml'
            doc = File.open(xml) { |f| Nokogiri::XML(f) }
            modified_cve = Pull_CVSS_Methods.modify_cvss(cve, doc)
            File.open('cves/' + cve['CVE'] + '.yml', 'w') {|f| f.write modified_cve.to_yaml}
          end
      end
    end
  end

  def self.download_xml()
    url = 'https://static.nvd.nist.gov/feeds/xml/cve/nvdcve-2.0-'
    years = %w(2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017)
    base = 'nvd-cve-2.0-'
    dir = './tmp/xml/'

    FileUtils.makedirs(dir) unless Dir.exist?(dir)

    for year in years
      download = open(url + year + '.xml.gz')
      IO.copy_stream(download, dir + base + year + '.xml.gz')
      Zlib::GzipReader.open(dir + base + year + '.xml.gz') do | input_stream |
        File.open(dir + base + year + '.xml', "w") do | output_stream |
          IO.copy_stream(input_stream, output_stream)
        end
      end
    end
  end

  def self.clean(directory)
    Rake::Cleaner.cleanup_files(FileList[directory])
  end

end