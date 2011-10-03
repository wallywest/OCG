require 'mongo'
require 'roo'
@conn = Mongo::Connection.new
@db   = @conn["servers"]
@col = @db["products"]
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
#posts=@col.find("exchanges" => "CME")
@col.insert({"_id" => BSON::ObjectId('4e5fef24c4389533957fa0c4'),  "exchange" => "CME", "symbols" => @inserts})
