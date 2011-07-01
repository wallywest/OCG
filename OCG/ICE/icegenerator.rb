module ICE
class ICE::Generator
	def initialize chash,filewriter
    @chash=chash
		@filewriter=filewriter
    @dir="#{$:.last}/ICE"
    @translator=YAML.load_file("#{@dir}/translator.yaml")
    @filestowrite=["ICE.conf","impactMulticastConfig.xml"]
    @groups=[]
    @markettypes=[]
    @multicastgroups=[]
    @ids=[]
		
    formatSymbols
		writeTemplates
  
	end
  
	def formatSymbols
		ids=@chash["symbols"]
    ids.split(",").each do |sym|
      markettype = @translator["symbols"]["#{sym}"]
      @ids << @translator["symbols"]["#{sym}"]["id"]
      @markettypes << markettype
      @option=@translator["symbols"]["#{sym}"]["options"]
      unless @multicastgroups.include?("#{markettype["group"]}")
        @multicastgroups << markettype["group"]
        debugger
        if @option.nil?
          @multicastgroups << "#{markettype["group"]} Options"
        else
          @multicastgroups << "#{@option}" 
        end
      end
    end
    @multicastgroups.each do |grp|
      @groups << {"name" => "#{grp}","network" => @translator["feeds"]["#{grp}"], "ids" => "#{@ids.join(",")}"}
    end
    
    pipe=@groups[1]["ids"].gsub(/,/,"|")
    @chash.merge!({"mtypes" => @markettypes,"groups" => @groups, "pipeids" => "#{pipe}"})
    debugger
	end
  
	def writeTemplates
		@filestowrite.each do |f|
			@filewriter.writeTemplate "ICE",f,@chash
		end	
	end
  
end
end
