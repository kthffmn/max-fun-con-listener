class App

  PUNCTUATION_MARKS = %w[ ; : ? ! . , - ]
  yaml_file = "lib/fixtures/blog-titles.yml"

  def self.run(url="http://www.maxfuncon.com", env="dev")
    app = self.new(url, env)
    app.run
  end   

  attr_reader :old_titles, :url, :yaml_file, :env
  attr_accessor :different, :new_titles, :html

  def initialize(url, env)
    @url = url
    @env = env
    @yaml_file = set_file 
    @old_titles = YAML.load_file(yaml_file)
    @different = false
  end

  def set_file
    env == "dev" ? "lib/fixtures/blog-titles.yml" : "lib/fixtures/test-titles.yml"
  end

  def save_html(url)
    Nokogiri::HTML(open(url))
  end

  def fetch_titles
    self.html = save_html(url)
    self.new_titles = process_titles(get_titles)
  end

  def run
    first_time = true
    until different
      fetch_titles
      print_title if first_time
      compare
      first_time = false if first_time
      print "."
      sleep(120)
    end
  end

  def print_title
    website_title = html.search("h1").text
    puts "Tracking #{website_title}"
  end

  def compare
    new_titles.each do |title|
      if old_titles.include?(title) == false
        change_detected(title)
      end
    end
  end

  def change_detected(title)
    Launchy.open(url)
    Tweeter.run("Change detected: #{title} --- URL: #{url}")
    update_titles
    self.different = true
  end

  def update_titles
    yml = new_titles.to_yaml
    File.open(yaml_file, 'w') { |file| file.write(yml) }
  end

  def get_titles
    html.search("#blog h2").map{|b| b.children[0]}.compact
  end

  def process_titles(nokogiri_titles)
    nokogiri_titles.map do |noko_title|
      title = noko_title.text.gsub(/\s+\Z/, "").gsub(/\A\s+/, "").downcase
      remove_punctuation(title)
      title.empty? ? nil : title
    end.compact
  end

  def remove_punctuation(string)
    PUNCTUATION_MARKS.each { |mark| string.gsub!(mark, "") }
  end
end
