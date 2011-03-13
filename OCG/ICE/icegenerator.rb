module ICE
class ICE::Generator
	def initialize chash,filewriter
                @chash=chash
		@filewriter=filewriter
                @dir="#{$:.last}/ICE"
                @translator=YAML.load_file("#{@dir}/translator.yaml")
		formatSymbols
		writeTemplates
	end
	def formatSymbols
		ids=@chash["symbols"]
		@chash["symbols"].split(",").each do |s|
			ids.gsub!(/#{s}/,"#{@translator["symbols"]["#{s}"]}")
		end
		pipe=ids.gsub(/,/,"|")
		@chash.merge!("ids" => "#{ids}","pipeids" => "#{pipe}")
	end
	def writeTemplates
		%w{ ICE.conf impactjava.properties }.each do |f|
			@filewriter.writeTemplate "ICE",f,@chash
		end	
	end
end
end
