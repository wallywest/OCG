module OCG
class Functions
  #functions for databse updates
  def initialize(collection)
    @col=collection
  end

  def addAccount(instance,password)
    @instances.update({"name" => "#{instance}"}, { "$push" => {"accounts" => "#{account}"}})
  end

  def addTrader(instance,user,password)
    @instances.update({"name" => "#{instance}"}, { "$set" => {"traders.#{user}" => "#{password}"}})
  end

  def addIlink(instance,ilink)
    @instances.update({"name" => "#{instance}"}, { "$push" => {"exchanges.CME.ilinks" => ilink}}) 
  end

  def removeAccount
  end

  def removeTrader
  end

  def removeIlink
  end

  def addSymbol(instance,exchange,symbol)
  end

  def removeSymbol(instance,exchange,symbol)
  end

  def addExchange
  end

  def toggleexchangeDefault
  end

  def changeUser
    #optionscityuser
  end

  def setServerId(instance,server_id)
    
  end

end
end
