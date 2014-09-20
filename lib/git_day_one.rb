require 'date'

Dir.glob(File.join(File.dirname(__FILE__), 'git_day_one', '**', '*.rb')).each do |path|
  require_relative path
end
