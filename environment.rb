require 'rubygems'
require 'extensions'
require 'page'
require 'user'

%w(git maruku).each do |gem|
  require_gem_with_feedback gem
end

GIT_REPO = File.expand_path( ENV['WIKI_HOME'] || (ENV['HOME'] + '/wiki') )
HOMEPAGE = 'index'
PAGE_FILE_EXT = ".markdown"
ATTACH_DIR_SUFFIX = "_files"

unless File.exists?(GIT_REPO) && File.directory?(GIT_REPO)
  puts "Initializing repository in #{GIT_REPO}..."
  Git.init(GIT_REPO)
end

class Git::Lib
  def commit(message, opts = {})
    arr_opts = ["-m '#{message}'"]
    arr_opts << '-a' if opts[:add_all]
    arr_opts << %[--author"=#{opts[:author]}"] if opts[:author]
    command('commit', arr_opts)
  end
end

$repo = Git.open(GIT_REPO)
