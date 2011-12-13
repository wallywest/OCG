require 'net/scp'
module OCG
  module Deployer
  include OCG::Helpers
  extend self
    
    def push
      raise "No files to deploy for #{params[:instance]}" unless File.exist?("deploy/#{params[:instance]}")
      findServer
      Net::SCP.start(@credentials["ip"], @serverid["user"], :password => "optserver") do |scp|
          %w{ *.conf *.properties *.list}.each do |files|
            scp.upload!("deploy/#{params[:instance]}/#{files}", "/home/#{@serverid["user"]}/optionscity/bin/city/conf/")
          end
      end
    end

    def findServer
        @serverid=instances.find_one({"name" => params[:instance]},{:fields => {"server_id" => 1,"user" => 1}})
        @credentials=servers.find_one({"_id" => @serverid["server_id"]})
    end
  end
end
