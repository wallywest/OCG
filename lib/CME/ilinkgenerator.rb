module CME
	class Ilinkgenerator
		def initialize(config,filewriter)
			@config=config
      extractNonQuotes
      filewriter.writeTemplate("CME.conf",config)
		end
    def extractNonQuotes
      syms=@config["sym"]
      @config["ilinks"].each do |ilink|
         ilink["quoting"].each {|x| syms.delete(x)} unless ilink["quoting"].nil? 
         @compid=ilink["compid"] unless ilink["default"].nil?
      end
      @config["nonquoting"]={}
      @config["nonquoting"]["syms"]=syms
      @config["nonquoting"]["ilink"]=@compid
    end
	end
end
