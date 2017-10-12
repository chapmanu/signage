#
# This deploy script is for a VirtualBox VM running on your local machine.
# See the dev Ansible script for more info.
#
# USAGE:
#   vboxmanage startvm redhat7 --type headless
#   cap virtualbox deploy
#
# Roles are where the various servers live
server "localhost", user: "deploy", roles: %w{web}, port: 2222

# Rbenv is under user.
set :rbenv_type, :user
set :rbenv_ruby, '2.2.1'
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, [:web]

# The git branch for staging
def current_git_branch
  branch = `git symbolic-ref HEAD 2> /dev/null`.strip.gsub(/^refs\/heads\//, '')
  puts "Deploying branch #{branch}"
  branch
end

# Set the deploy branch to the current branch
set :branch, current_git_branch