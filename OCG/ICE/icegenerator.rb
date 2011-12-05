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
    @ids={}
    @totalids=[]
    @optiongroups=[]
		
    formatSymbols
		writeTemplates
  
	end
  
  def setIds(sym)
    @ids["#{@gname}"] ||= []
    @ids["#{@option}"] ||= []
    @totalids << @translator["symbols"]["#{sym}"]["id"]
    @ids["#{@gname}"] << @translator["symbols"]["#{sym}"]["id"]
    @ids["#{@option}"] << @translator["symbols"]["#{sym}"]["id"]
  end
	
  def formatSymbols
		ids=@chash["symbols"]
    ids.split(",").each do |sym|
      markettype = @translator["symbols"]["#{sym}"]
      raise "invalid symbol" if markettype.nil?
      
      @markettypes << markettype
      @option=@translator["symbols"]["#{sym}"]["options"]
      @gname=markettype["group"]
      
      setIds(sym) 
      
      unless @multicastgroups.include?("#{@gname}")
        @multicastgroups << @gname
        @multicastgroups << @option unless @multicastgroups.include?(@option)
      end
    end
    
    @multicastgroups.each do |grp|
      @groups << {"name" => "#{grp}","network" => @translator["feeds"]["#{grp}"], "ids" => "#{@ids["#{grp}"].join(",")}"}
    end
    
    @chash.merge!({"mtypes" => @markettypes,"groups" => @groups, "pipeids" => "#{@totalids.join("|")}"})
    p @chash
	end
  
	def writeTemplates
		@filestowrite.each do |file|
			@filewriter.writeTemplate "ICE",file,@chash
		end	
	end
  
end
end
