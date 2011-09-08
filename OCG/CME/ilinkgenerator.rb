module CME
	class Ilinkgenerator
		def initialize(config,filewriter)
			@config=config
      p @config
      debugger 
      filewriter.writeTemplate("CME","CME.conf",config)
		end
	end
end
