set :application, 'line_parrot'
set :repo_url, 'git@github.com:corselia/line-parrot.git'

set :rbenv_type, :user
set :rbenv_ruby, '2.6.1'

# shared/ にあらかじめ作る
set :linked_dirs,
    [
      'log',
      'tmp/pids',
      'tmp/cache',
      'tmp/sockets',
      'public/recieved_files',
    ]

# shared/ にあらかじめ作る
set :linked_files,
    [
      '.env',
      'config/master.key',
      '.vision-api.json',
    ]

namespace :deploy do
  task :restart_puma do
    invoke  'puma:stop'
    invoke! 'puma:start'
  end
end

after 'deploy:finishing', 'deploy:restart_puma'
