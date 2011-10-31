$: << File.dirname(__FILE__)
#GLOBAL INTERFACE TO GENERATE CONFIGS
require 'OCG/generator.rb'
require 'OCG/db.rb'
require 'OCG/builder.rb'
require 'OCG/utils/filewriter.rb'
require 'OCG/utils/functions.rb'
require 'OCG/servers/server.rb'
require 'yaml'
require 'json'
require 'mongo'
require 'trollop'

opts = Trollop::options do
  opt :task, "task to run", :type => :string
  opt :write, "write to file", :type => :string
  opt :json, "json param file", :type => :string
  opt :instance, "specify instance for writer function", :type => :string
  opt :deploy, "deploy config file", :type => :string
end

#tasks: install,disable,addProduct,removeProduct,addIlink,removeIlink,disableExchange,enableExchange,

#later
#database changes addTradeAccount,removeTradeAccount, addTrader,removeTrader

#@instance=ARGV[0]
#@task=ARGV[1]
#opts={:task => "debug", :write => "true", :instance => "GBAR_Silver"}

unless opts[:json].nil?
  params=JSON.parse(File.read(opts[:json])) 
  opts.merge!(params)
end

@builder=OCG::Builder::new(opts) 
  #:instance => "#{@instance}",
  #:function => "#{@task}"
  #:write => true

# Fresh install
# all tasks that are accomplished
OCG::Writer::new(@builder,opts[:instance],opts[:task]) if opts[:write]=="true"
