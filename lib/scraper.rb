require 'open-uri'

class Scraper
  # All Cards: doc.css("div.roster-cards-container .student-card a").text
  # Student Name: doc.css("div.roster-cards-container .student-card h4.student-name").text
  # Student Location: doc.css(".student-card p.student-location").text
  # Student Link: doc.css(".student-card a").attr('href')

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    students = []
    doc.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        student_link = "#{student.attr('href')}"
        student_location = student.css('.student-location').text
        student_name = student.css('.student-name').text
        students << {name: student_name, location: student_location, profile_url: student_link}
      end
    end
    students
  end

  # Bio: doc.css("div.main-wrapper .description-holder p").text
  # Profile Quote: doc.css("div.main-wrapper .profile-quote").text
  # Social Links: doc.css("div.main-wrapper .social-icon-container a").attr('href')
  # Main doc.css("div.main-wrapper)

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
   
    profile = {}

    links = doc.css(".social-icon-container").children.css("a").map { |l| l.attribute('href').value}
    links.each do |link|
      if link.include?("twitter")
        profile[:twitter] = link
      elsif link.include?("linkedin")
        profile[:linkedin] = link
      elsif link.include?("github")
        profile[:github] = link
      else
        profile[:blog] = link
      end
    end

    profile[:profile_quote] = doc.css("div.main-wrapper .profile-quote").text
    profile[:bio] = doc.css("div.main-wrapper .description-holder p").text

    profile
  end

end



