
# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'thatmattpattis.at'
set :repo_url, 'git@github.com:matthewpatterson/thatmattpattis.at.git'

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/deploy/thatmattpattis.at'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

namespace :deploy do

  before :publishing, :this do
    on roles(:web) do
      within release_path do
        execute :bundle, :exec, :rake, 'assets:compile'
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
