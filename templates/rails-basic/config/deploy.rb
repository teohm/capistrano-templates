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

require 'capistrano/recipes/deploy/remote_dependency'
Capistrano::Deploy::RemoteDependency.class_eval do
  def path(path, options={})
    @message ||= "`#{path}' directory or file is missing"
    try("test -e #{path}", options)
    self
  end

end

require 'capistrano/recipes/deploy/local_dependency'
Capistrano::Deploy::LocalDependency.class_eval do
  def ssh_forward_agent_ready
    command = "ssh-add -l"
    @message ||= "SSH agent has no keys, to add your key: ssh-add -K  OR  ssh-add -K private_key_file"
    @success = true
    begin
      @configuration.logger.debug "executing \"#{command}\"" 
      output = `#{command}`
      @success = !output.include?("no identities")
    rescue => ex
      output = ex.message 
      @success = false
    end
    @configuration.logger.trace "[local] #{output}"
    self
  end
end

set :check_path_vars, [:shared, :privates]
namespace :deploy do
  namespace :check do
    desc <<-DESC
      Check if the paths stored in specified variables exist. \
      By default, it checks for variable :shared, :privates. \
      To change the default, overwrite variable :check_path_vars.
    DESC
    task :path do 
      fetch(:check_path_vars, []).each do |var|
        fetch(var, []).each do |path|
          depend :remote, :path, path
        end
      end
    end

    desc <<-DESC
      If ssh_options[:forward_agent] is enabled, check \
      to ensure SSH agent in local machine has at least \
      one identity key.
    DESC
    task :forward_agent do
      if ssh_options[:forward_agent]
        depend :local, :ssh_forward_agent_ready
      end
    end
  end
end

before 'deploy:check', 'deploy:check:path'
before 'deploy:check', 'deploy:check:forward_agent'

# Restart
# -------
require 'capistrano-helpers/passenger'

# Rails: Asset Pipeline
# ---------------------
load 'deploy/assets'

