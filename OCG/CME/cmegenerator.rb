require 'nokogiri'
require 'erubis'

module CME
class CME::Generator
	attr_reader :configs
	def initialize chash,filewriter
		@chash=chash
		@dir="#{$:.last}/CME"

		f=File.open("#{@dir}/config.xml",'r')
		@translator=YAML.load_file("#{@dir}/translator.yaml")
		@cme=Nokogiri::XML(f)
		@symbols=@chash["symbols"].split(",")
		@interface=@chash["interface"]
		@cmeip=@chash["ip"]
		@configfiles=%w{idchannels.properties mdchannels.properties}
		@filewriter=filewriter

		findChannelDetails
		createFiles
		generateTemplates
		genCMEDisplay
	end
	def getConnectionInfo channel
		id=@cme.xpath("#{channel}").first.attributes["id"].value
		@configs["#{channel}"]["id"]="#{id}"
		@configs["#{channel}"]["connAtts"] = {} 
		%w{IA IB NA NB SA SB}.each do |x|
			@configs["#{channel}"]["connAtts"]["#{id}#{x}"]=[]
		        %w{ip port}.each do |child|
		       		config=@cme.xpath("#{channel}/connections/connection[@id='#{id}#{x}']/#{child}")
			        @configs["#{channel}"]["connAtts"]["#{id}#{x}"] << config.children.text
		        end
		end

	end
	def addChanName(label)
		@allnames << "#{@translator[label]['name']} "
	end
	def addConfigs(channel,code,label)
		 addChanName(label) if @configs["#{channel.path}"].nil?
                 @configs["#{channel.path}"] ||= {}
                 @configs["#{channel.path}"].merge!(@translator[label])
                 configs["#{channel.path}"]["symbols"] ||= []
                 @configs["#{channel.path}"]["symbols"] << "#{code.first.attributes["code"].value}"
	end
	def findChannelDetails
		@configs={}
		@skipid=["Inter Exchange Spreads"]
		@allnames=""
		@cme.xpath("//configuration/channel").each do |channel|
			label=channel.attributes["label"].value.rstrip.chomp
			next if @skipid.include?(label)
			@symbols.each do |sym|
				code=channel.xpath("products/product[@code='#{sym}']")
				addConfigs(channel,code,label) unless code.empty?
			end
		end
		@configs.keys.each {|x| getConnectionInfo x }
	end
	def createFiles
		@allnames.rstrip!.gsub!(/ /,", ")
		@configfiles.each do |f|
			File.open("deploy/"+f,'w')  {|file| file.write("active-channels = #{@allnames}" + "\n")}	
		end
		File.open('deploy/mdchannels.properties','a') do |f| 
                       File.open("#{@dir}/templates/premdchannels.config",'r') {|x| x.each_line {|line| f.write(line)}}
		end
	end
	def generateTemplates
		@vars={}
		@idchan=[]
		@mdchan=[]
		@channel=[]
		@vars["ip"]=@cmeip
		# find out these values
		@vars["book"]="2"
		@vars["ibook"]="1"
		# =====================
		@configs.each_value do |value|
			@vars["name"]=value["name"]
			@id=value["id"]
			@vars["id"]=value["id"]
			@vars["interface"]=@interface
			@vars["book"]=value["bookdepth"]
			@vars["ibook"]=value["implied"]
			@vars["symbols"]=value["symbols"].join(", ")
			@vars["host"]=value["connAtts"]["#{@id}NA"][0]
			@vars["port"]=value["connAtts"]["#{@id}NA"][1]
                        @vars["hostia"]=value["connAtts"]["#{@id}IA"][0]
                        @vars["portia"]=value["connAtts"]["#{@id}IA"][1]
                        @vars["hostib"]=value["connAtts"]["#{@id}IB"][0]
                        @vars["portib"]=value["connAtts"]["#{@id}IB"][1]
                        @vars["hostsa"]=value["connAtts"]["#{@id}SA"][0]
                        @vars["hostsb"]=value["connAtts"]["#{@id}SA"][1]
			%w{idchannels.properties mdchannels.properties channels.list}.each do |conf|
				write "#{conf}", @vars
			end
		end
		write "demux.conf",{:ip => @cmeip}

	end
	def write file,values 
		@vars["name"].gsub(/commodity/,"commodities") if @vars["name"].include?("commodity")
		@filewriter.writeTemplate "CME",file,values
	end
	def genCMEDisplay
                @write=''
                @display=File.open("#{@dir}/templates/globalcmedisplay.txt",'r')
                @finaldisplay=File.open('deploy/CME_DisplayFactor.conf','w')
                @display.each_line do |line|
                        @symbols.each do |sym|
                                if line.gsub(/:.*/,"").chomp == "#{sym}" then @write << line end
                        end
                end
                @finaldisplay.write(@write)
        end

end
end
