class Tweeter

  def self.run(tweet="testing 1, 2, 3")
    tweeter = self.new(tweet)
    tweeter.send_tweet
  end

  attr_reader :client, :tweet

  def initialize(tweet)
    @client = get_client
    @tweet = tweet
  end

  def get_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["KEY"]
      config.consumer_secret     = ENV["SECRET"]
      config.access_token        = ENV["TOKEN"]
      config.access_token_secret = ENV["TOKEN_SECRET"]
    end
  end

  def send_tweet 
    self.client.update(self.tweet)
  end

end