class App

  PUNCTUATION_MARKS = %w[ ; : ? ! . , - ]
  yaml_file = "lib/fixtures/blog-titles.yml"

  def self.run(url="http://www.maxfuncon.com/", env="dev")
    app = self.new(url)
    app.run
  end   

  attr_reader :html, :old_titles, :new_titles, :url, :yaml_file
  attr_accessor :different

  def initialize(url, env)
    @url = url
    @html = save_html(url)
    @new_titles = process_titles(get_titles)
    @old_titles = YAML.load_file(yaml_file)
    @different = false
    @yaml_file = set_file

  end

  def set_file
    env == "dev" ? "lib/fixtures/blog-titles.yml" : "lib/fixtures/test-titles.yml"
  end

  def save_html(url)
    Nokogiri::HTML(open(url))
  end

  def run
    until different
      compare
      sleep(2.minutes)
    end
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
    yml = titles.to_yaml
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
