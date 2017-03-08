#Methods found here are specific to pulling CVSS Scores
module Pull_CVSS_Methods
  def self.modify_cvss(cve, xml)
    nvd_base_url = 'http://nvd.nist.gov/view/vuln/detail?vulnId='
    compiled_cvss = Hash.new

    base_metrics = xml.xpath("//vuln:cve-id[text()='#{cve['CVE']}']/../vuln:cvss/cvss:base_metrics")
    compiled_cvss['score'] = base_metrics.xpath('cvss:score').text.to_f
    compiled_cvss['gained_access'] = base_metrics.xpath('cvss:access-vector').text.downcase
    compiled_cvss['access_complexity'] = base_metrics.xpath('cvss:access-complexity').text.downcase
    compiled_cvss['authentication'] = base_metrics.xpath('cvss:authentication').text.downcase
    compiled_cvss['confidentiality'] = base_metrics.xpath('cvss:confidentiality-impact').text.downcase
    compiled_cvss['integrity'] = base_metrics.xpath('cvss:integrity-impact').text.downcase
    compiled_cvss['availability'] = base_metrics.xpath('cvss:availability-impact').text.downcase
    compiled_cvss['source'] = nvd_base_url + cve['CVE']
    compiled_cvss['date_generated'] = base_metrics.xpath('cvss:generated-on-datetime').text
    cve['cvss'] = compiled_cvss

    return cve
  end
end