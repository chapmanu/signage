# server-based syntax
# ======================
server 'dsv-mkt-prd02', user: 'charles', roles: %w{app db web postgres}

# Configuration
# =============
set :branch, ENV["BRANCH"] || "master"