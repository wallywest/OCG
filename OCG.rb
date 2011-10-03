$: << File.dirname(__FILE__)
#GLOBAL INTERFACE TO GENERATE CONFIGS
require 'OCG/generator.rb'
require 'OCG/utils/filewriter.rb'
require 'yaml'

#need to work out: multiple demux ports, cme ip connection
@config=YAML.load_file("config.yaml")
# Fresh install
OCG::Generator::new(@config)
# Updates
