$: << File.dirname(__FILE__)
require 'lib/CME/cmegenerator'
require 'lib/CME/ilinkgenerator'
require 'lib/ICE/icegenerator'
require 'lib/utils/filewriter'
require 'helpers'

module OCG
	class Writer
    include OCG::Helpers

		def initialize
      # params is a shareable variable now for function=task and instance
      puts "in writer"
      @builder=OCG::Generator.new
      debugger
			@filewriter=FileWriter.new(@builder)

      @builder.writer.each_key do |key|
					self.send "#{key}" 
					@filewriter.exchanges << key 
			end

      finalGenerator
      #if function=="install"
			@filewriter.writeFiles
		end
    
		def finalGenerator
      @filewriter.setpath("default")
      %w{ traders portfolio quotingcenter customer exchangehub}.each do |render|
        self.send("#{render}")
      end
		end
  
		def CME
			CME::Generator.new(@builder,@filewriter)
		end
  
		def CBOE
		end
  
		def ICE
			ICE::Generator.new(@builder,@filewriter)
		end
		
    def AMEX
		end
		
    def ACTIV
		end
		
    def CFE
		end

    def traders
      #type={"API" => "4", "TRADER" => "1"}
      #role={"VIEW" => "0", "TRADER" => "1", "LIMITED" => "2", "RISK" => "3", "CLERK" => "4"}
      @traders={"users" => @builder.traders}
      debugger
      puts @traders
      @filewriter.writeTemplate("populatetraders.sql",@traders)
    end

    def portfolio
      @filewriter.writeTemplate("populateportfolio.sql",@builder.totsym)
    end

    def quotingcenter
      @filewriter.writeTemplate("quotingcenter.conf",@traders)
    end

    def customer
      @filewriter.writeTemplate("customer.conf",{"customer" => @builder.customer })
    end

    def exchangehub
      @filewriter.createExchangeHub @builder.defaultexchange
    end

	end
end
