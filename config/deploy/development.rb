server ENV['CAPISTRANO_HOST'], user: ENV['CAPISTRANO_USER'], roles: %w(web app db), ssh_options: { keys: File.expand_path(ENV['CAPISTRANO_SSH_KEY']), port: ENV['CAPISTRANO_PORT'] }

set :stage, :development
set :branch, :development

set :rails_env, 'development'
set :bundle_without, 'production'

set :deploy_to, ENV['DEPLOY_TO_DEVELOPMENT']
set :puma_conf, "#{shared_path}/config/puma.development.rb"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log, "#{release_path}/log/puma.error.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true
