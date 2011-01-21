$: << File.dirname(__FILE__)
#GLOBAL INTERFACE TO GENERATE CONFIGS
require 'generators/cmegenerator.rb'
require 'yaml'

#need to work out: multiple demux ports, cme ip connection
@config=YAML.load_file("config.yaml")
p @config

syms="ES,ZC,OZC,ZW,OZW,ZS,OZS,HE,LE,SPX,SP,GE,CL"
ip="216.14.120.252"
cme=CME::Generator.new syms,ip
cme.generateTemplates
