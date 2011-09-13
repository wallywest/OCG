module OCG
  class Builder
    attr_reader :writer,:symprop,:feeds,:traders,:accounts,:customer,:totsym,:defaultexchange

    def initialize(options)

        @conn = Mongo::Connection.new
        @db = @conn["servers"]

        @instances_col = @db["instances"]
        @servers_col = @db["servers"]
        @products_col = @db["products"]

        @instance=@instances_col.find_one("name" => "#{options[:instance]}") 
        @serverid=@instance["server_id"]
        @accounts={"accounts" => @instance["accounts"]}
        @traders={"users" => @instance["traders"]}
        @customer="#{options[:user]}"

        buildExchanges
        
    end
    def buildExchanges
        @writer={}
        @symprop={}
        @totsym={"symbols" => []}
        @instance["exchanges"].each_pair do |exchange,values|
            @writer["#{exchange}"] ||= {}
            @defaultexchange=exchange if values["isdefault"]
      
            setSymbolConfig(exchange,values["sym"])
            setExchangeFeeds(exchange)
            
            @writer["#{exchange}"]["consts"]=values
            @writer["#{exchange}"]["device"]=interface(exchange)
        end
    end
    def interface(exchange)
        server=@servers_col.find_one("_id" => @serverid)
        server["connections"]["#{exchange}"] 
    end
    def setSymbolConfig(exchange,syms)
       syms.each do |product|
          @totsym["symbols"] << product
          config=@products_col.find_one({"exchange" => "#{exchange}"},:fields => {"symbols.#{product}" => 1})
          @symprop.merge!(config["symbols"])
       end 
    end
    def setExchangeFeeds(exchange)
        @feeds=@products_col.find_one({"exchange" => "#{exchange}"}, :fields => {"feeds" => 1})
    end
  end
end
