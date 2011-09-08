require 'mongo'
module OCG
class Functions
  #functions for databse updates
  def initialize
    @conn= Mongo::Connection.new
    @db=@conn["servers"]
    @instances=@db["instances"]
    addIlink("RockOC_JConnors",ilink)
    #ilink={ "compid" => "6QK3P7N", "password" => "imusk", "subid" => "JCONNORS", "port" => "9036", "host" => "205.209.216.129"}
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

  def addSymbol
  end

  def removeSymbol
  end

  def addExchange
  end

  def toggleexchangeDefault
  end

  def changeUser
    #optionscityuser
  end

  def setServerId
  end

end
end
