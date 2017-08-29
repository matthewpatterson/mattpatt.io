
# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'thatmattpattis.at'
set :repo_url, 'git@github.com:atmattpatt/mattpatt.io'

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

  desc 'Start application'
  task :start do
    on roles(:web), in: :sequence, wait: 5 do
      within release_path do
        execute :bundle, :exec, :thin, :start, "--config", release_path.join("config", "thin.yml")
      end
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:web), in: :sequence, wait: 5 do
      within release_path do
        execute :bundle, :exec, :thin, :stop, "--config", release_path.join("config", "thin.yml")
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:web), in: :sequence, wait: 5 do
      within release_path do
        execute :bundle, :exec, :thin, :restart, "--config", release_path.join("config", "thin.yml"), "--onebyone"
      end
    end
  end

  after :publishing, :restart

end
