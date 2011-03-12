module ICE
class ICE::Generator
	def initialize chash,filewriter
                @chash=chash
                @dir="#{$:.last}/ICE"
                @translator=YAML.load_file("#{@dir}/translator.yaml")
		p @translator
		p @chash
	end
end
end
