$: << File.dirname(__FILE__)
require 'OCG/CME/cmegenerator'
require 'OCG/ICE/icegenerator'
require 'OCG/utils/filewriter'
module OCG
	class OCG::Writer
		def initialize(builder)
			@builder=builder
			@globsyms={}
			@globsyms['symbols']=[]
			@filewriter=FileWriter.new
		   
      p @builder 
      @builder.writer.each_key do |key|
					self.send "#{key}",@builder 
					@filewriter.exchanges << key 
          debugger
					#@globsyms["symbols"] << val["symbols"].split(",") 
			end
			@users=@config.select {|k| k=="users"}
			finalGenerator if opts["exchange"].nil?
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
	end
end
