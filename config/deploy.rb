# config valid only for current version of Capistrano
lock '3.9.1'

set :application, 'signage'
set :repo_url, 'git@github.com:chapmanu/signage.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/signage'

# Capistrano rbenv: https://github.com/capistrano/rbenv
# Set Ruby version here.
set :rbenv_type, :user
set :rbenv_ruby, '2.2.1'
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, [:web]

# puma configuration
set :puma_conf, "#{shared_path}/config/puma.rb"
set :puma_role, :web

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

