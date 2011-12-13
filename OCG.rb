$: << File.dirname(__FILE__)
#GLOBAL INTERFACE TO GENERATE CONFIGS
require 'lib/generator.rb'
require 'lib/builder.rb'
require 'lib/deploy.rb'
require 'lib/utils/filewriter.rb'
require 'lib/utils/functions.rb'
require 'lib/servers/server.rb'
require 'lib/helpers.rb'

require 'yaml'
require 'json'
require 'mongo'
module OCG
  extend self
  include Helpers
  
  def db
      @conn = Mongo::Connection.new
      @db = @conn["servers"]
      @instances = @db["instances"]
      @servers = @db["servers"]
      @products = @db["products"]
  end

  def instances
    return @instances if @instances
    self.db
    @instances
  end

  def servers
    return @servers if @servers
    self.db
    @servers
  end

  def products
    return @products if @products
    self.db
    @products
  end

  def params
    @params
  end

  def run(opts)
    @params=opts
    case @params[:function]
    when "write"
      OCG::Writer.new
    when "attribute"
      OCG::Functions::runQuery
    when "deploy"
      OCG::Deployer::push
    else
      puts "task not supported"
    end
  end
end
