require 'git'
require 'mongoid'
require 'chroma-db'
require 'ruby/openai'
require 'rest-client'
require 'dotenv/load'

require 'byebug'

ENV['MONGOID_ENV'] = 'development'
Mongoid.load!('config/mongoid.yml')

Chroma.connect_host = 'http://localhost:8000'
Chroma.logger = Logger.new($stdout)
Chroma.log_level = Chroma::LEVEL_ERROR

OPENAI_API_KEY = ENV['OPENAI_API_KEY']

LOCAL_GIT_REPO_PATH = ENV['LOCAL_GIT_REPO_PATH']

GITLAB_API_TOKEN = ENV['GITLAB_API_TOKEN']
GITLAB_PROJECT_BASE_URL = ENV['GITLAB_PROJECT_BASE_URL']

require './app/gitlab'
require './app/commit'
require './app/issue'
require './app/vector'
