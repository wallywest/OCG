$: << File.dirname(__FILE__)
require 'nokogiri'
require 'erubis'
require 'yaml'
#figure out bookdepth later

module CME
class CME::Generator
	attr_reader :configs
	def initialize syms,cmeip
		f=File.open("generators/config.xml",'r')
		@translator=YAML.load_file("./generators/translator.yaml")
		@cme=Nokogiri::XML(f)
		@symbols=syms.split(",")
		@cmeip=cmeip
		@configfiles=%w{idchannels.properties mdchannels.properties}
		findChannelDetails
		createFiles
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
	def findChannelDetails
		@configs={}
		@skipid=["Inter Exchange Spreads"]
		@allnames=""
		@cme.xpath("//configuration/channel").each do |channel|
			label=channel.attributes["label"].value.rstrip.chomp
			next if @skipid.include?(label)
			@symbols.each do |sym|
				code=channel.xpath("products/product[@code='#{sym}']")
				unless code.empty?
					p sym
					p label
					@configs["#{channel.path}"] ||= {}
					@configs["#{channel.path}"]["name"]="#{@translator[label]}"
					@allnames << "#{@translator[label]} "
					@configs["#{channel.path}"]["symbols"] ||= []
					@configs["#{channel.path}"]["symbols"] << "#{code.first.attributes["code"].value}"
				end
			end
		end
		@configs.keys.each {|x| getConnectionInfo x }
	end
	def createFiles
		@allnames.rstrip!.gsub!(/ /,", ")
		@configfiles.each do |f|
			File.open("deploy/"+f,'w')  {|file| file.write("active-channels = #{@allnames}" + "\n")}	
		end
	end
	def genIdchan
		idchan = File.read('generators/templates/idchannels.eruby')
                id=Erubis::Eruby.new(idchan)
		@idchan << id.result(@vars)

	end
	def genMdchan
                mdchan = File.read('generators/templates/mdchannels.eruby')
                md=Erubis::Eruby.new(mdchan)
                @mdchan << md.result(@vars)
	end
	def genDemux
		demux=File.read('generators/templates/demux.eruby')
		de=Erubis::Eruby.new(demux)
		@demux=de.result(:ip => @cmeip)
	end
	def genChannelist
		channlist=File.read('generators/templates/channels.eruby')
		chan=Erubis::Eruby.new(channlist)
		@channel << chan.result(@vars)

	end
	def generateTemplates
		@vars={}
		@idchan=[]
		@mdchan=[]
		@channel=[]
		@vars["ip"]=@cmeip
		@vars["book"]="2"
		@vars["ibook"]="1"
		@configs.each_value do |value|
			@vars["name"]=value["name"]
			@id=value["id"]
			@vars["id"]=@id
			@vars["symbols"]=value["symbols"].join(", ")
			@vars["host"]=value["connAtts"]["#{@id}NA"][0]
			@vars["port"]=value["connAtts"]["#{@id}NA"][1]
                        @vars["hostia"]=value["connAtts"]["#{@id}IA"][0]
                        @vars["portia"]=value["connAtts"]["#{@id}IA"][1]
                        @vars["hostib"]=value["connAtts"]["#{@id}IB"][0]
                        @vars["portib"]=value["connAtts"]["#{@id}IB"][1]
                        @vars["hostsa"]=value["connAtts"]["#{@id}SA"][0]
                        @vars["hostsb"]=value["connAtts"]["#{@id}SA"][1]
		genChannelist
		genIdchan
                genMdchan
		end
		genDemux
		File.open('deploy/demux.conf','w',) {|f| f.write(@demux) }
		File.open('deploy/channels.list','w',) {|f| @channel.each {|x| f.write(x)} }
                File.open('deploy/idchannels.properties','a') {|f| @idchan.each {|x| f.write(x)} }
                File.open('deploy/mdchannels.properties','a') do |f| 
			File.open('generators/templates/premdchannels.config','r') {|x| x.each_line {|line| f.write(line)}}
			@mdchan.each {|x| f.write(x)}
		end

	end
end
end
