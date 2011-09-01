module ICE
class ICE::Generator
	def initialize chash,filewriter
    debugger
    @config=chash.writer["ICE"]
    @defin=chash.symprop
    @feeds=chash.feeds["feeds"]
		@filewriter=filewriter
    @file={}
    
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
  
  def setIds(markettype)
    @ids["#{@gname}"] ||= []
    @ids["#{@option}"] ||= []
    
    @totalids << markettype["id"]
    
    @ids["#{@gname}"] << markettype["id"]
    @ids["#{@option}"] << markettype["id"]
  end
	
  def formatSymbols
		ids=@config["consts"]["sym"]
    ids.each do |sym|
      markettype = @defin["#{sym}"]
      raise "invalid symbol" if markettype.nil?
      
      @markettypes << markettype
      @option=markettype["options"]
      @gname=markettype["group"]
      
      setIds(markettype) 
      
      unless @multicastgroups.include?("#{@gname}")
        @multicastgroups << @gname
        @multicastgroups << @option unless @multicastgroups.include?(@option)
      end
    end
    
    @multicastgroups.each do |grp|
      @groups << {"name" => "#{grp}","network" => @feeds["#{grp}"], "ids" => "#{@ids["#{grp}"].join(",")}"}
    end
    
    @file.merge!({"mtypes" => @markettypes,"groups" => @groups, "pipeids" => "#{@totalids.join("|")}"})
    @file.merge!(@config["consts"])
    # need to fix this, specify device based on the exchange
    @file.merge!({"interface" => "#{@config['device'].first['int']}", "traderaccount" => "TESTACCOUNT"})
	end
  
	def writeTemplates
		@filestowrite.each do |file|
			@filewriter.writeTemplate "ICE",file,@file
		end	
	end
  
end
end
