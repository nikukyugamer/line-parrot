server ENV['CAPISTRANO_HOST'], user: ENV['CAPISTRANO_USER'], roles: %w(web app db), ssh_options: { keys: File.expand_path(ENV['CAPISTRANO_SSH_KEY']), port: ENV['CAPISTRANO_PORT'] }

set :stage, :production
set :branch, :master

set :rails_env, 'production'

set :deploy_to, ENV['DEPLOY_TO_PRODUCTION']
set :puma_conf, "#{shared_path}/config/puma.production.rb"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_conf, "#{shared_path}/config/puma.production.rb"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log, "#{release_path}/log/puma.error.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true
