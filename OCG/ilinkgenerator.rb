$: << File.dirname(__FILE__)
require 'OCG/utils/filewriter'
module OCG
	class OCG::Ilinkgenerator
		def initialize(config)
			@config=config
			@filewriter=FileWriter.new
      
      @filewriter.writeTemplate("ILink","CME.conf",config)
      @filewriter.writeFiles
		end
	end
end
