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
    @instances_col.update({"name" => "#{@params["instance"]}"}, { "$push" => {"accounts" => "#{@params["account"]}"}})
  end

  def addTrader
    @params["trader"].each_pair do |user,pass|
      @instances_col.update({"name" => "#{@params["instance"]}"}, { "$set" => {"traders.#{user}" => "#{pass}"}})
    end
  end

  def addIlink
    @params["ilink"].each_pair {|key,value| if value.empty? then raise "missing value for #{key} key" end}
    @instances_col.update({"name" => "#{@params["instance"]}"}, { "$push" => {"exchanges.CME.ilinks" => @params["ilink"]}}) 
  end

  def removeAccount
    #@instances_col.update({"name" => "#{@params["instance"]}"}, { "$unset" => {"traders.#{user}" => "#{password}"}})
  end
  
  def addICEids
      @params["ice"].each_pair {|key,value| if value.empty? then raise "missing value for #{key} key" end}

      @instances_col.update({"name" => "#{@params["instance"]}"}, { "$set" => {"exchanges.ICE." => "#{ice}"}})
  end

  def removeTrader
    @params["trader"].each_pair do |user,pass|
      @instances_col.update({"name" => "#{@params["instance"]}"}, { "$unset" => {"traders.#{user}" => "#{pass}"}})
    end
  end

  def removeIlink
  end

  def addSymbol
      
  end

  def removeSymbol
  end

  def addExchange
      exchange={"isdefault" => "", "isquoting" => "", "sym" => []}
      @instances_col.update({"name" => "#{@params["instance"]}"}, { "exchanges.#{@params["exchange"]}" => exchange})
  end
  
  def removeExchange
  end

  def toggleexchangeDefault
  end

  def changeUser
  end

  def addServer
    status=OCG::Server::checkserver(@params["ip"],@servers_col) 
    puts "server already exists" unless status.eql?(true) 
  end
end
end
end
