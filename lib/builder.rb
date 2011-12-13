require 'helpers.rb'
module OCG
  class Generator
    include OCG::Helpers
    attr_reader :writer,:symprop,:feeds,:traders,:accounts,:customer,:totsym,:defaultexchange

    def initialize
        ## need to add which instance we will right for
        #runTask unless params[:json].nil?
        mainFunction
    end

    def mainFunction
        puts "runnign main function"
        @instance=instances.find_one({"name" => params[:instance]})
        unless @instance.nil?
          @serverid=@instance["server_id"]
          @customer=@instance["name"]
          buildTraders
          buildExchanges
        end
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
        server=servers.find_one("_id" => @serverid)
        server["connections"]["#{exchange}"] 
    end

    def setSymbolConfig(exchange,syms)
       syms.each do |product|
          @totsym["symbols"] << product
          config=products.find_one({"exchange" => "#{exchange}"},:fields => {"symbols.#{product}" => 1})
          @symprop.merge!(config["symbols"])
       end 
    end
    def setExchangeFeeds(exchange)
        @feeds=products.find_one({"exchange" => "#{exchange}"}, :fields => {"feeds" => 1})
    end

    def buildTraders
        @traders=@instance["traders"]
    end

  end
end
