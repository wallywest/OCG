module OCG
module Functions
  #functions for database updates
  class << self
  include OCG::DB
  
  def runQuery(params)
    @params=params
    setupdb
    self.send(params["task"])
  end

  def addAccount
    @instances_col.update({"name" => "#{@params["instance"]}"}, { "$push" => {"accounts" => @params["vars"]["account"]}})
  end

  def addTrader
    @params["vars"]["trader"].each_pair do |user,pass|
      @instances_col.update({"name" => "#{@params["instance"]}"}, { "$set" => {"traders.#{user}" => "#{pass}"}})
    end
  end

  def addIlink
    @params["vars"]["ilink"].each_pair {|key,value| if value.empty? then raise "missing value for #{key} key" end}
    @instances_col.update({"name" => "#{@params["instance"]}"}, { "$push" => {"exchanges.CME.ilinks" => @params["vars"]["ilink"]}}) 
  end

  def removeAccount
    #@instances_col.update({"name" => "#{@params["instance"]}"}, { "$unset" => {"traders.#{user}" => "#{password}"}})
  end
  
  def addICEids
      @params["ice"].each_pair {|key,value| if value.empty? then raise "missing value for #{key} key" end}

      @instances_col.update({"name" => "#{@params["instance"]}"}, { "$set" => {"exchanges.ICE" => @params["ice"]}})
  end

  def removeTrader
    @params["vars"]["trader"].each_pair do |user,pass|
      @instances_col.update({"name" => "#{@params["instance"]}"}, { "$unset" => {"traders.#{user}" => "#{pass}"}})
    end
  end

  def removeIlink
  end

  def addSymbol
    @params["vars"].each do |h|
      exchange,sym=h["exchange"],h["sym"]
      sym.each do |s|
        @instances_col.update({"name" => "#{@params["instance"]}"}, { "$addToSet" => {"exchanges.#{exchange}.sym" => "#{s}"}})
      end
    end  
  end

  def removeSymbol
      @params["vars"].each do |h|
        exchange,sym=h["exchange"],h["sym"]
        sym.each do |s|
          @instances_col.update({"name" => "#{@params["instance"]}"}, { "$pull" => {"exchanges.#{exchange}.sym" => "#{s}"}})
        end
      end
  end

  def addExchange
      @params["vars"]["exchanges"].each_pair do |ex,isdefault|
        quoting="false"
        isdefault=false if isdefault.empty?
        exchange={"isdefault" => "#{isdefault}", "isquoting" => "#{quoting}", "sym" => []}
        @instances_col.update({"name" => "#{@params["instance"]}"}, { "$set" => {"exchanges.#{ex}" => exchange}})
      end
  end
  
  def removeExchange
  end

  def toggleexchangeDefault
  end

  def changeUser
  end

  def addServer
      status=OCG::Server::checkserver(@params["vars"],@servers_col) 
      puts "server already exists" unless status.eql?(true) 
  end
  def addInstance
      @server= @servers_col.find_one({"ip" => "#{@params["ip"]}"}) 
      @params["vars"]["server_id"]=@server["_id"]
      input=@params["vars"]
      @instances_col.insert(input)
  end
end
end
end
