require 'cinch'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.libera.chat"
    c.channels = ["#cinch-bots"]
  end

  on :message, "hello" do |m|
    m.reply "Hello, #{m.user.nick}"
  end
end

bot.start

