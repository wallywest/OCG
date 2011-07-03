require 'fileutils'
class FileWriter
	attr_accessor :exchanges
	def initialize
		@filenames=[]
		@exchanges=[]
	end
	
  def setpath type
		if type=="default" then @path="#{$:.last}/templates" else @path="#{$:.last}/#{type}/templates" end
	end
	
  def readFile tfile,&block
		f=File.read("#{@path}/#{tfile}.eruby")
		#yield Erubis::Eruby.new(f)
    yield Erubis::EscapedEruby.new(f)
	end
	
  def writeTemplate(type,tfile,hinput)
		setpath type
		@filenames << tfile
		var=tfile.gsub(/\..*/,"")
		
    readFile(tfile) {|out| @cs=out.result(hinput)}	
		if self.instance_variable_defined?("@#{var}")
			eval "@#{var} << @cs"
		else
			self.instance_variable_set("@#{var}",@cs)
		end
	end
	
  def writeFiles
		@filenames.uniq.each do |file|
			data=instance_variable_get("@#{file.gsub(/\..*/,"")}")
      File.open("deploy/#{file}",'a') {|f| f.write(data) }
		end
	end
	
  def createExchangeHub defaultexchange
		setpath "default"
		args={}
		args["exchanges"]=""
		exch=YAML::load(File.open("#{@path}/exchanges.conf.yaml"))		
		@exchanges.each do |exchange|
			args["exchanges"] << exch["#{exchange}"].gsub(/#/,"#{@exchanges.index(exchange) + 1}") + "\n"
		end 
		args.merge!("count" => @exchanges.length,"defaultexchange" => defaultexchange)
		writeTemplate("default","exchangehub.exchange.conf",args)
	end
end
