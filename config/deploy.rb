# config valid only for current version of Capistrano
#lock '3.4.0'

set :application, 'signage'
set :repo_url, 'git@github.com:chapmanu/signage.git'

# RVM SETTINGS
set :rvm_ruby_version, '2.3.0'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/signage'

# Default value for :scm is :git
# set :scm, :git

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc "Invoke rake task"
  task :task do
    on roles(:web) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, ENV['task']
        end
      end
    end
  end
end
