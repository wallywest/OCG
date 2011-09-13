$: << File.dirname(__FILE__)
require 'OCG/CME/cmegenerator'
require 'OCG/CME/ilinkgenerator'
require 'OCG/ICE/icegenerator'
require 'OCG/utils/filewriter'

module OCG
	class OCG::Writer
		def initialize(builder,function)
			@builder=builder
			@globsyms={}
			@globsyms['symbols']=[]
			@filewriter=FileWriter.new
      @builder.writer.each_key do |key|
					self.send "#{key}",@builder 
					@filewriter.exchanges << key 
			end
      finalGenerator if function=="install"
			@filewriter.writeFiles
		end
    
		def finalGenerator
			@filewriter.writeTemplate("default","populatetraders.sql",@builder.traders)
			@filewriter.writeTemplate("default","populateportfolio.sql",@builder.totsym)
			@filewriter.writeTemplate("default","quotingcenter.conf",@builder.traders)
      @filewriter.writeTemplate("default","customer.conf",{"customer" => @builder.customer })
			@filewriter.createExchangeHub @builder.defaultexchange
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
