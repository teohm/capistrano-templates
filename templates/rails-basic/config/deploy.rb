# Fill in your info
# ========
set :application, "set your application name here"
set :repository,  "set your repository location here"
server "set remote host here", :web, :app, :db, :primary => true
set :deploy_to, "/home/deployer/#{application}"
set :shared, %w()
set :privates, %w(config/database.yml)


# Coloring
# ========
require 'capistrano_colors'

# Multistage
# ==========
set :stages, %w(staging production)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'

# Code Repository
# =========
set :scm, :git
set :scm_verbose, true
set :deploy_via, :remote_cache

# Remote Server
# =============
set :use_sudo, false
ssh_options[:forward_agent] = true
require 'capistrano-ssh-helpers'

# RVM
# ---
set :rvm_ruby_string, "default"
require 'rvm/capistrano'

# Bundler
# -------
require 'bundler/capistrano'

# Shared Paths/Files
# ------------------
require 'capistrano-helpers/shared'
require 'capistrano-helpers/privates'
require 'capistrano-shared-helpers'

# Restart
# -------
require 'capistrano-helpers/passenger'

# Rails: Asset Pipeline
# ---------------------
load 'deploy/assets'

