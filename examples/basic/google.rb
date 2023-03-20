require 'cinch'
require 'open-uri'
require 'nokogiri'
require 'cgi'

bot = Cinch::Bot.new do
  configure do |c|
    c.server   = "irc.libera.chat"
    c.nick     = "MrCinch"
    c.channels = ["#cinch-bots"]
  end

  helpers do
    # Extremely basic method, grabs the first result returned by Google
    # or "No results found" otherwise
    def google(query)
      url = "http://www.google.com/search?q=#{CGI.escape(query)}"
      content = URI.open(url).read
      parsed_content = Nokogiri.parse(content)
      
      # Parse the result: first result's title, description and link
      title = parsed_content.css('h3').first&.text || "No results found"
      link = parsed_content.css('cite').first&.text || "No link found"
    rescue StandardError => e
      return "Error: #{e.message} (#{e.class})"
    else
      CGI.unescape_html "#{title} - (#{link})"
    end
  end

  on :message, /^!google (.+)/ do |m, query|
    m.reply google(query)
  end
end

bot.start
