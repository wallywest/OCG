$: << File.dirname(__FILE__)
#GLOBAL INTERFACE TO GENERATE CONFIGS
require 'OCG/generator.rb'
require 'OCG/builder.rb'
require 'OCG/utils/filewriter.rb'
require 'yaml'
require 'mongo'

#p @servers
#fuctions: install,disable,addProduct,removeProduct,addIlink,removeIlink,addTradeAccount,removeTradeAccount,  
@builder=OCG::Builder::new(
 # :user => "BenSlater",
 # :function => "install",
 # :user => "PRIME_ARI",
 # :function => "install"
  :user => "RockOC_JConnors",
  :function => "install"
)
#need to work out: multiple demux ports
#@config=YAML.load_file("conf/cmeicefixture.yaml")
#@ilink=YAML.load_file("conf/ilinksprod.yaml")

#@live=YAML.load_file("conf/config.yaml")
# Fresh install
OCG::Writer::new(@builder)
#OCG::Ilinkgenerator.new(@ilink)
