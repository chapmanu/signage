# server-based syntax
# ======================
server 'signage.chapman.edu', user: 'charles', roles: %w{app db web postgres}

# Configuration
# =============
set :branch, ENV["BRANCH"] || "master"