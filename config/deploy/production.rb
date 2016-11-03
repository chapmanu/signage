# server-based syntax
# ======================
server 'signage.chapman.edu', user: 'charles', roles: %w{app db web}

# role-based syntax
# ==================
role :postgres, %w{charles@signage.chapman.edu}, no_release: true

# Configuration
# =============
set :branch, ENV["BRANCH"] || "master"