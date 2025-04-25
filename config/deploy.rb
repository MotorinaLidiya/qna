lock "~> 3.19.2"

set :application, "qna"
set :repo_url, "git@github.com:MotorinaLidiya/qna.git"

set :deploy_to, "/home/deployer/qna"
set :deploy_user, "deployer"
set :keep_releases, 5

append :linked_files, "config/database.yml", "config/master.key", ".env", 'config/puma/production.rb'
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"

set :rbenv_type, :user
set :rbenv_ruby, '3.1.2'

set :pty, false
set :ssh_options, { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa) }
set :puma_systemd_unit, "#{fetch(:application)}_puma_#{fetch(:stage)}.service"
