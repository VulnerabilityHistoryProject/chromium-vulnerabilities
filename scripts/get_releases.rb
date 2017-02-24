require 'nokogiri'
require 'open-uri'
require 'openssl'
require 'yaml'

def get_wiki_table_rows()
  doc =  Nokogiri::HTML(open(
    "https://en.wikipedia.org/wiki/Google_Chrome_version_history",
    ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))

  doc.xpath('//table[2]/tr[position() > 1][position() < last()]')
end

def get_releases()
  rels = {}
  #store values for the rawspans
  layout_eng = ""
  layout_counter = 0
  v8_eng = ""
  v8_counter = 0

  get_wiki_table_rows.each do |row|
    col = row.css('td')

    # Handle number of times layout vals have to be reused
    if(!col[2].attribute('rowspan').nil?)
      layout_eng = col[2].text
      layout_counter = col[2].attribute('rowspan').value.to_i - 1
    elsif layout_counter > 0
      layout_counter -= 1
    elsif layout_counter == 0
      layout_eng = col[2].text
    end

    if(!col[3]&.attribute('rowspan').nil?)
      v8_eng = col[3].text
      v8_counter = col[3].attribute('rowspan').value.to_i - 1
    elsif v8_counter > 0
      v8_counter -= 1
    elsif v8_counter == 0
      v8_eng = col[3].text
    end

    # Get Dates
    dates = {}
    date_rel = col[1].text.gsub(/[()]/, "")
      .gsub(" and",",").gsub("[citation needed]", "").split("\n")
    date_rel.each { |d|
      date = d.slice!(/\d+-\d+-\d+/)
      rel = d.empty? ? "General" : d.strip
      dates[date] = rel
    }

    # Store release number
    rels[col[0].text] = {
      "date" => dates,
      "browser_eng" => layout_eng,
      "js_eng" => v8_eng,
      "notes" => col.last.text.strip
    }
  end
  rels
end

File.open('../releases.yml', 'w') {|f| f.write get_releases.to_yaml}
