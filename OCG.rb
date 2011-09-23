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

@instance=ARGV[0]
@task=ARGV[1]

@builder=OCG::Builder::new(
 # :user => "BenSlater",
 # :function => "install",
 # :user => "PRIME_ARI",
 # :function => "install"
  :instance => "#{@instance}",
  :function => "#{@task}"
)

#@live=YAML.load_file("conf/config.yaml")
# Fresh install
# all tasks that are accomplished
OCG::Writer::new(@builder,@task)
