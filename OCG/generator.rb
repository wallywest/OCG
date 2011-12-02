$: << File.dirname(__FILE__)

require 'OCG/CME/cmegenerator'
require 'OCG/ICE/icegenerator'
require 'OCG/utils/filewriter'

module OCG
	class OCG::Generator
		def initialize(config,opts)
			@config=config
			@globsyms={}
			@globsyms['symbols']=[]
			@filewriter=FileWriter.new
		  
      self.cleanup

      @config["exchange"].each_pair do |key,val|
				unless val.has_value?(nil)
					self.send "#{key}",val 
					@filewriter.exchanges << key 
					@globsyms["symbols"] << val["symbols"].split(",") 
				end
			end
			@users=@config.select {|k| k=="users"}
			finalGenerator unless opts[:sym]
			@filewriter.writeFiles
		end
    
		def finalGenerator
			@filewriter.writeTemplate("default","populatetraders.sql",@users)
			@filewriter.writeTemplate("default","populateportfolio.sql",@globsyms)
			@filewriter.writeTemplate("default","quotingcenter.conf",@users)
      @filewriter.writeTemplate("default","customer.conf",{"customer" => @config["customer"]})
			@filewriter.createExchangeHub @config["default"]
		end
  
		def CME value
			CME::Generator.new value,@filewriter
		end
  
		def CBOE value
		end
  
		def ICE value
			ICE::Generator.new value,@filewriter
		end
		
    def AMEX value
		end
		
    def ACTIV value
		end
		
    def CFE value
		end

    def cleanup
      FileUtils.rm Dir.glob('deploy/*')
    end

	end
end
