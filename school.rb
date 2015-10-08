require 'nokogiri'
require 'open-uri'
require 'json'

schools = []
(0..120).map do |page|
  doc = Nokogiri::HTML(open("http://www.webometrics.info/en/world?page=#{page}"))
  trs = doc.css('table.sticky-enabled tbody tr'){ |tr| tr}
  puts "Parsing page: #{page}"
  trs.map do |tr|
    url = tr.children[1].children[0].attributes['href'].value # get url
    school = tr.children[1].children[0].children[0].text # school name
    country_code = tr.children[3].children[0].children[0].attributes['src'].value.split('/').last.split('.').first # country code

    puts "Adding #{school},#{url},#{country_code} to schools"
    schools << {name: school, url: url, country_code: country_code }
  end

  puts "Total schools added: #{schools.size}"
  puts "Done Parsing page: #{page}"
  puts "sleeping for 10 secs"
  sleep(10)
end

file = File.new(File.join(File.dirname(__FILE__), 'universities.json'), 'w')
file.write(schools.to_json)
file.close
puts schools