$: << File.dirname(__FILE__)
require 'OCG/CME/cmegenerator'
#require 'OCG/ICE/icegenerator'
require 'OCG/utils/filewriter'
module OCG
	class OCG::Generator
		def initialize(opts)
			@config=opts
			@globsyms={}
			@globsyms['symbols']=[]
			@filewriter=FileWriter.new
			@config["exchange"].each_pair do |key,val|
                                        self.send "#{key}",val
					@filewriter.exchanges << key unless val["symbols"].nil?
					@globsyms["symbols"] << val["symbols"].split(",") unless val["symbols"].nil?
			end
			@users=@config.select {|k| k=="users"}
			finalGenerator
		end
		def finalGenerator
			@filewriter.writeTemplate("default","populatetraders.sql",@users)
			@filewriter.writeTemplate("default","populateportfolio.sql",@globsyms)
			@filewriter.writeTemplate("default","quotingcenter.conf",@users)
			@filewriter.createExchangeHub @config["default"]
			@filewriter.writeFiles
		end
		def CME value
			CME::Generator.new value,@filewriter
		end
		def CBOE value
		end
		def ICE value
			#ICE::Generator.new value,@filewriter
		end
		def AMEX value
		end
		def ACTIV value
		end
		def CFE value
		end
	end
end
