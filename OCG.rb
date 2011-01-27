$: << File.dirname(__FILE__)
#GLOBAL INTERFACE TO GENERATE CONFIGS
require 'OCG/generator.rb'
require 'yaml'

#need to work out: multiple demux ports, cme ip connection
@config=YAML.load_file("config.yaml")

syms="GC,OG,SI,SO"
ip="172.21.150.95"
# Fresh install
OCG::Generator::setup(@config)

# Updates
