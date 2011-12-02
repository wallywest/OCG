$: << File.dirname(__FILE__)
#GLOBAL INTERFACE TO GENERATE CONFIGS
require 'OCG/generator.rb'
require 'OCG/ilinkgenerator.rb'
require 'OCG/utils/filewriter.rb'
require 'yaml'
require 'trollop'
require 'fileutils'

opts = Trollop::options do
  opt :sym, "only generate files for symbols"
end
                                                        
@live=YAML.load_file("conf/config.yaml")
# Fresh install
OCG::Generator::new(@live,opts)
