require 'yaml'

module GitDayOne
  class Configuration
    GIT_CMD_DATE_FORMAT = "%Y-%m-%d %H:%M"

    attr_accessor :start_commit, :stop_commit, :start_time, :stop_time, :git_command, :start_day, :stop_day, :author, :projects, :path

    def initialize(args = nil)
      hash_to_vars(args)
      defaults
    end

    def defaults
      @start_commit ||= "________STARTCOMMIT_________"
      @stop_commit ||= "________STOPCOMMIT___________"
      @start_day ||= Time.now
      @stop_day ||= start_day
      @start_time ||= self.class.beginning_of_the_day(start_day)
      @stop_time ||= self.class.beginning_of_the_day(stop_day) + 23 * 3600 + 59 * 60 + 59
    end

    def git_command
      "git log --after=\"#{start_time.strftime(GIT_CMD_DATE_FORMAT)}\" --before=\"#{stop_time.strftime(GIT_CMD_DATE_FORMAT)}\" --author=\"#{author}\" --numstat --all --pretty='#{start_commit}%ncommit %h%ndate %aD%+s%+b%n#{stop_commit}'"
    end

    def load_config_from_file
      if path && File.exists?(path)
        begin
          hash_to_vars(YAML.load_file(path))
        rescue Errno::ENOENT
          warn 'WARNING: Config file path is bad'
        end
      end
    end

    def self.beginning_of_the_day(time)
      time - time.hour * 3600 - time.min * 60 - time.sec
    end

    def self.git_time_format(time)
      time.strftime()
    end

    def hash_to_vars(hash)
      hash.each do |key, value|
        key = key.to_s
        send(key + '=', value) if respond_to? key
      end
    end
  end
end
