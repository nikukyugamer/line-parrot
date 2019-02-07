require 'dotenv/load'

require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

require 'capistrano/rails'
require 'capistrano/rails/console'
require 'capistrano/rbenv' # ~/.rbenv を見に行くので、anyenv で rbenv を入れているとダメ
require 'capistrano/puma'
install_plugin Capistrano::Puma

# require 'capistrano/sidekiq'

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
