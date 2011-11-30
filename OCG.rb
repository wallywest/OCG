$: << File.dirname(__FILE__)
#GLOBAL INTERFACE TO GENERATE CONFIGS
require 'OCG/generator.rb'
require 'OCG/ilinkgenerator.rb'
require 'OCG/utils/filewriter.rb'
require 'yaml'

#need to work out: multiple demux ports
#@config=YAML.load_file("conf/cmeicefixture.yaml")
#@ilink=YAML.load_file("conf/ilinksprod.yaml")
@live=YAML.load_file("conf/config.yaml")
# Fresh install
OCG::Generator::new(@live)
#OCG::Ilinkgenerator.new(@ilink)
