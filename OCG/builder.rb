module OCG
  class Builder
    def initialize(input)
        @conn = Mongo::Connection.new
        @db   = @conn["servers"]

        @instances_col = @db["instances"]
        @servers_col = @db["servers"]
        @products_col = @db["products"]

        @instance=@instances_col.find_one("name" => "#{input[:user]}") 
        @serverid=@instance["server_id"]
        @writer={}
        buildExchanges
    end
    def buildExchanges
        @instance["exchanges"].each_pair do |exchange,values|
            getSymbolConfig(exchange,values["sym"]) do |product|
                    p product
            end
            @writer["exchange"] ||= {}
            @writer["exchange"]["consts"]=values
            @writer["exchange"]["device"]=interface(exchange)
        end
    end
    def interface(exchange)
        server=@servers_col.find_one("_id" => @serverid)
        server["connections"]["#{exchange}"] 
    end
    
    #def getExchangeConfig(exchange)
    #    @instance["exchanges"]["#{exchange}"]
    #end
    
    def getSymbolConfig(exchange,syms, &block)
       syms.each do |product|
          yield @products_col.find_one({},:fields => {"#{exchange}.symbols.#{product}" => 1})
       end 
    end
    
  end
end
