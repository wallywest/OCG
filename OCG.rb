$: << File.dirname(__FILE__)
#GLOBAL INTERFACE TO GENERATE CONFIGS
require 'generators/generator.rb'
require 'generators/cmegenerator.rb'
require 'yaml'

#need to work out: multiple demux ports, cme ip connection
@config=YAML.load_file("config.yaml")

syms="GC,OG,SI,SO"
ip="172.21.150.95"
OCG::Generator::setup(@config)
#cme=CME::Generator.new syms,ip
#cme.generateTemplates
