set :runner, 'apache'
set :user, 'root'
set :domain, 'timepulse.algoverse.org'
set :application, 'tracks' # eg 'rfx'
set :deploy_to, "/var/www/timepulse"
set :keep_releases, 10
set :branch, 'master'
set :rails_env, "production"
set :use_sudo, false
