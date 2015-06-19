require 'erb'
require 'pry'
require 'yaml'

class Timeline
  attr_accessor :languages, :colors

  def initialize(filter = nil)
    self.languages = YAML.load_file("data/genealogy.yml")
    self.colors = YAML.load_file("data/genealogy_colors.yml")

    # replicate the color configuration to each of the language versions as well
    languages.keys.select { |key| colors.keys.include?(key) }.each do |key|
      languages[key][:versions].map(&:first).each do |version|
        colors.merge!(version => colors[key])
      end
    end
    colors.values.each do |color_set|
      color_set[:fontcolor] = "white" unless color_set[:fontcolor]
    end

    filter_ancestors(filter)
  end

  def recent_versions(year = 2014)
    languages_filtered.keys.inject([]) do |acc, key|
      acc += languages_filtered[key][:versions].select do |version|
               version.last > year
             end.map(&:first)
    end
  end

  def all_languages
    languages_filtered.
      inject([]) do |acc, (key, value)|
        acc += value[:versions].map(&:first) unless value[:versions].empty?
        acc += value[:influenced]
      end
  end

  def ancestors
    languages_filtered.keys - all_languages
  end

  def grouped_by_year(versions = true)
    languages_filtered.keys.inject([]) do |acc, key|
      acc += [[key, languages_filtered[key][:year]]] + ( versions ? languages_filtered[key][:versions] : [] )
    end.group_by { |a| a.last }
  end

  def formatted_main_rank_groups(versions = true)
    versions = grouped_by_year(versions)
    groups = (1955..2015).step(5).map do |year|
      {
          year: year,
          languages: versions.keys.
            select     { |y| y >= (year - 5) && y < year }.
            inject([]) { |acc, y| acc += versions[y].map(&:first) }.flatten
      }
    end
    groups.each { |g| g[:formatted_languages] = escape_list(g[:languages])}
    groups
  end

  def valid_group(list, accumulator)
    [list, ancestors.select { |e| accumulator.include?(e) } ]
  end

  def valid_versions(separator = "; ")
    list = languages_filtered.reject { |key| languages_filtered[key][:versions].empty? }
    accumulator = []
    list.each do |key, value|
      accumulator += value[:versions].map(&:first)
      value[:formatted_versions] = escape_list(value[:versions].map(&:first), separator)
    end
    valid_group(list, accumulator)
  end

  def valid_influenced(separator = "; ")
    list = languages_filtered.reject { |key| languages_filtered[key][:influenced].empty? }
    accumulator = []
    list.each do |key, value|
      accumulator += value[:influenced]
      value[:formatted_influenced] = escape_list(value[:influenced], separator)
    end
    valid_group(list, accumulator)
  end

  def generate
    @ancestors = ancestors

    @valid_versions = @valid_influenced = []
    @main_ranks_str = formatted_main_rank_groups(true)
    @valid_versions, ancestors_filtered = valid_versions(" -> ")
    @ancestors_str = escape_list(ancestors_filtered)
    render_erb('genealogy_versions')

    @valid_versions = @valid_influenced = []
    @main_ranks_str = formatted_main_rank_groups(false)
    @valid_influenced, ancestors_filtered = valid_influenced()
    @ancestors_str = escape_list(ancestors_filtered)
    render_erb('genealogy_influenced')
  end

  private

  def escape_list(list, separator = "; ")
    list.map { |word| "\"#{word}\"" }.join(separator)
  end

  def filter(main_list, list)
    list.select { |word| main_list.include?(word) }
  end

  def languages_filtered
    @languages_filtered ||= languages.reject { |key| languages[key][:noshow] }
  end

  def render_erb(filename)
    template = ERB.new File.new("genealogy.erb").read, nil, "%"
    File.open("output/#{filename}.dot", "w+") do |f|
      f.write template.result(binding)
    end

    system "dot -Tpng output/#{filename}.dot -o output/#{filename}.png"
  end

  def filter_ancestors(filter = nil)
    return unless filter
    queue = [language] + languages.keys.select { |key| languages[key][:versions].map(&:first).include?(language) }
    result = []
    while !queue.empty?
      current_language = queue.pop
      found = languages.keys.select { |key| key != current_language && languages[key][:influenced].include?(current_language) }
      queue = found + queue
      result += found
    end
    self.languages = result.inject({}) { |list, key| list.merge(key => languages[key]) }
  end
end
Timeline.new.generate
