require 'capistrano_colors'

# App Info
# ========
#set :application, "set your application name here"
set :application, "learndeploy"

# Code Repo
# =========
#set :repository,  "set your repository location here"
set :repository,  "git://github.com/teohm/rails32-sample.git"
set :scm, :git
set :scm_verbose, true
set :deploy_via, :remote_cache

# Multistage
# ==========
set :stages, %w(staging production)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'

# Remote Server
# =============
#set :remote_host,  "set your remote host here"
set :remote_host,  "learndeploy"
server remote_host, :web, :app, :db, :primary => true
set :deploy_to, "~/#{application}"
set :use_sudo, false
ssh_options[:forward_agent] = true

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
set :shared, %w()
set :privates, %w(config/database.yml)

require 'capistrano-checks'
require 'capistrano-shared'

# Restart
# -------
require 'capistrano-helpers/passenger'

# Rails: Asset Pipeline
# ---------------------
load 'deploy/assets'

