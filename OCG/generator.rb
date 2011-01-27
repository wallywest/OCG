require 'OCG/CME/cmegenerator'
require 'OCG/utils/filewriter'

module OCG
	class OCG::Generator
		def self.setup(opts)
			@config=opts
			@globsyms={}
			p @config
			@globsyms['symbols']=[]
			@config["exchange"].each_pair do |key,val|
					self.send "#{key}", val
					@globsyms["symbols"] << val["symbols"].split(",") unless val["symbols"].nil?
			end
			finalGenerator
		end
		def self.finalGenerator 
			@out=""
			@dout=""
			traders = File.read('OCG/templates/populatetraders.eruby')
			trade = Erubis::Eruby.new(traders)
			@out << trade.result(@config)
			symbols = File.read('OCG/templates/populateportfolio.sql.eruby')
			sym = Erubis::Eruby.new(symbols)
			@dout << sym.result(@globsyms)
			writeFile "populatetraders.sql",@out
			writeFile "populateportfolio.sql",@dout
		end
		def self.CME config
			CME::Generator.new config
		end
		def self.CBOE config
		end
		def self.ICE config
		end
		def self.AMEX config
		end
		def self.ACTIV config
		end
		def self.CFE config
		end
		def self.writeFile name,value
			File.open("deploy/#{name}","w") {|f| f.write(value) }		
		end
	end
end
