require 'rss'
require 'tty-spinner'
require 'colorize'

class Podcast 

  attr_reader :podcasts, :podcast

  def parse(path)
    podcasts_parser = RSS::Parser.new(path)
    @podcasts = podcasts_parser.parse
    @podcasts.items.reverse!
    @podcast = []
  end

  def download()
  end

  private

  def get_file_name_from_url(url)
    remove_proto_from_url(url)
    url_parts = url.split('/')
    return false if url_parts.size < 2

    return url_parts[-1] 
  end

  def remove_proto_from_url(url)
    return url.sub(/(^https?:\/\/)(.+)/, '\2')
  end

end

class Hobbytalks < Podcast

  @@podcast_rss_url = 'http://hobbytalks.org/rss.xml'

  def initialize
    self.parse(@@podcast_rss_url)
  end

  def download(podcast_number)
    get_podcast_info(podcast_number)
    file_name = get_file_name_from_url(@podcast.guid.content)
    spinner = TTY::Spinner.new("[:spinner] Загрузка ...", format: :pulse_2)
    spinner.auto_spin
    open(file_name, 'wb') do |file|
      file << open(@podcast.guid.content).read
    end
    spinner.stop('Готово!')
    puts "Файл: #{file_name}"
  end

  def get(param)
    if param == 'all'
      get_all
    elsif param == 'last'
      get_by_number (-1)
    elsif param.to_i > 0
      get_by_number(param.to_i)
    else
      false
    end
  end


  private

  def get_by_number(number)
    number = @podcasts.items.length-1 if number == -1
    print_podcast_info(build_podcast_info(number), true)
  end
  
  def build_podcast_info(podcast_number)
    podcast_info = {
      number: podcast_number,
      subtitle: @podcasts.items[podcast_number].itunes_subtitle,
      duration: @podcasts.items[podcast_number].itunes_duration.value,
      summary: @podcasts.items[podcast_number].itunes_summary
    }

    podcast_info
  end

  def get_all
    @podcasts.items.each_index do |number|
      print_podcast_info(build_podcast_info(number), false)
    end
  end

  def statistic
  end

  def get_podcast_info(podcast_number)
    @podcast = @podcasts.items[podcast_number]
  end

  def print_podcast_info_extend(podcast_info)
      puts "#{"Краткое описание:".cyan} #{podcast_info[:summary]}"
  end

  def print_podcast_info(podcast_info, print_extend)
      puts "Выпуск №#{podcast_info[:number]}".light_red
      puts "#{"Название:".cyan} #{podcast_info[:subtitle]}"
      puts "#{"Продолжительность:".cyan} #{podcast_info[:duration]}"
      print_podcast_info_extend(podcast_info) if print_extend
      puts "---"
  end
end

def help
  puts 'Справка:'
end

def run_command(command, param = '') 
  
  hobbytalks = Hobbytalks.new

  case command

    when 'get' then
      hobbytalks.get param
    when 'statistic'
      hobbytalks.statistic
    when 'download' then
      if param.nil? || param.empty?
        help
        exit 0
      end
      hobbytalks.download param.to_i 
    else
      help
  end
end

if ARGV.empty?
  help
  exit 0
end

run_command(ARGV[0], ARGV[1])
