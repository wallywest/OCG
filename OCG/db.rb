module OCG
module DB
  attr_accessor :servers_col, :instances_col, :products_col
  def setupdb
        @conn = Mongo::Connection.new
        @db = @conn["servers"]

        @instances_col = @db["instances"]
        @servers_col = @db["servers"]
        @products_col = @db["products"]
  end
end
end
