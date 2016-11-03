# server-based syntax
# ======================
server 'dev-signage.chapman.edu', user: 'charles', roles: %w{app db web postgres}

# role-based syntax
# ==================
# role :postgres, %w{charles@dev-signage.chapman.edu}, no_release: true

def red(str)
  "\e[31m#{str}\e[0m"
end

# Figure out the name of the current local branch
def current_git_branch
  branch = `git symbolic-ref HEAD 2> /dev/null`.strip.gsub(/^refs\/heads\//, '')
  puts "Deploying branch #{red branch}"
  branch
end

# Set the deploy branch to the current branch
set :branch, ENV["BRANCH"] || current_git_branch