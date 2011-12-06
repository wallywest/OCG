require 'mongo'
@conn = Mongo::Connection.new
@db   = @conn["servers"]
@col = @db["test"]
@inserts={}
def parseLine(x)
    first,value=x.split("=")
    sym,type=first.split(":",2)
    @inserts["#{sym}"] ||= {}
    @inserts["#{sym}"]["#{first}"] = "#{value.chomp}"
end
File.open("globalcmedisplay.txt","r") {|f| 
  f.each_line do |x|
    parseLine(x) unless x=="\n"
  end
}
posts=@col.find_one({"exchange" => "CME"})
p posts
#@col.insert({"exchange" => "CME", "symbols" => @inserts})
@col.update({"exchange"=>"CME"},{"$set" => {"symbols" => @inserts}})
