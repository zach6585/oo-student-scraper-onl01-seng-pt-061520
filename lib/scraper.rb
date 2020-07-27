require 'open-uri'
require 'pry'
require 'nokogiri'


class Scraper

  def self.scrape_index_page(index_url)
    a = open(index_url)
    doc = Nokogiri::HTML(a)
    b = []
    doc.css('.student-card').each do |elem|
      b << {:name => "#{elem.css('h4.student-name').text}", :location => "#{elem.css('p.student-location').text}", :profile_url => "#{elem.css('a').first["href"]}"}
    end 
    b
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    attributes = doc.css('.social-icon-container a')
    b = {}
    attributes.each do |att|
      if att['href'].include?("twitter")
        b[:twitter] = att['href'] 
      elsif att['href'].include?("linkedin")
        b[:linkedin] = att['href'] 
      elsif att['href'].include?("github") 
        b[:github] = att['href']
      else 
        b[:blog] = att['href']
      end 
    end 
    b[:profile_quote] = doc.css('.profile-quote').text
    b[:bio] = doc.css('.bio-content p').first.text
    b
    
  end

end
