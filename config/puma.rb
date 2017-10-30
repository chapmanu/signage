# Use socket file rather port for reverse proxy.
bind 'unix:///var/www/signage/shared/tmp/sockets/puma.sock'

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
# Disabled since we're using bind socket above.
#port        ENV.fetch("PORT") { 3000 }

# Config / Log Paths
directory '/var/www/signage/current'
rackup "/var/www/signage/current/config.ru"
pidfile "/var/www/signage/shared/tmp/pids/puma.pid"
state_path "/var/www/signage/shared/tmp/pids/puma.state"
stdout_redirect '/var/www/signage/current/log/puma.error.log', '/var/www/signage/current/log/puma.access.log', true

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch("RAILS_ENV") { "production" }

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
workers 1
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart

# Run process in background
daemonize

on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = "/var/www/signage/current/Gemfile"
end