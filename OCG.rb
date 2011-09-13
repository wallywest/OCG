$: << File.dirname(__FILE__)
#GLOBAL INTERFACE TO GENERATE CONFIGS
require 'OCG/generator.rb'
require 'OCG/builder.rb'
require 'OCG/utils/filewriter.rb'
require 'yaml'
require 'mongo'

#tasks: install,disable,addProduct,removeProduct,addIlink,removeIlink,disableExchange,enableExchange,

#later
#database changes addTradeAccount,removeTradeAccount, addTrader,removeTrader

@task=ARGV[0]

@builder=OCG::Builder::new(
 # :user => "BenSlater",
 # :function => "install",
 # :user => "PRIME_ARI",
 # :function => "install"
  :instance => "Vermillion",
 # :tasks => "#{params}"
)

#@live=YAML.load_file("conf/config.yaml")
# Fresh install
# all tasks that are accomplished
OCG::Writer::new(@builder,@task)
