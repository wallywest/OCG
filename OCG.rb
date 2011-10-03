$: << File.dirname(__FILE__)
#GLOBAL INTERFACE TO GENERATE CONFIGS
require 'OCG/generator.rb'
require 'OCG/ilinkgenerator.rb'
require 'OCG/utils/filewriter.rb'
require 'yaml'
require 'slop'

opts=Slop.parse do
    on :e, :exchange, "specify exchange config to write"
end
#need to work out: multiple demux ports
#@config=YAML.load_file("conf/cmeicefixture.yaml")
#@ilink=YAML.load_file("conf/ilinksprod.yaml")
@live=YAML.load_file("conf/config.yaml")
# Fresh install
OCG::Generator::new(@live,opts.to_hash)
#OCG::Ilinkgenerator.new(@ilink)
