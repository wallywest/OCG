require 'net/ssh'
module OCG
class Server
  def self.checkserver(ip,server_col)
      @ip=ip
      @server_col=server_col
      raise "no ip specified" if @ip.nil?
      server=@server_col.find_one({"ip"=>"#{@ip}"})
      if server.nil? then generate else return "#{server}" end
      return true
  end
  def self.generate

    @insert={"ip" => @ip, "connections" => {}}
    begin
    Net::SSH.start(@ip,@user,:password => 'optserver') do |ssh|
        command=" egrep 'IPADDR=' /etc/sysconfig/network-scripts/ifcfg-eth[0-9]"
        findExchanges(ssh)
        ssh.exec!(command) do |ch,str,data|
          data.split("\n").each do |x|
          a=x.split(":")
          interface=a[0].gsub(/^.*-/,"")
          ipaddr=a[1].gsub(/IPADDR=/,"")
          next if ipaddr.empty? or @feeds[interface].nil?
          @insert["connections"]["#{@feeds[interface]}"] ||= []
          @insert["connections"]["#{@feeds[interface]}"] << {"int" => "#{interface}", "ip" => "#{ipaddr}"}
        end
    end
    end
    rescue Timeout::Error
    rescue Net::SSH::AuthenticationFailed
    puts "#{@ip} is not accesible"
    end

    #server=@coll.find_one({"ip"=>"#{@ip}"})
    #if server.nil?
    #  @coll.insert(@insert)
  end
  
  def self.findExchanges(ssh)
    command="/sbin/route -n | awk '{print $1,$8}' | tail -n +3 | sort -k2"
    @feeds={}
    ssh.exec!(command) do |ch,str,data|
      data.split("\n").each do |line|
      values=line.split(" ")
      case
      when values[0].match(/63.247.*/)
      @feeds["#{values[1]}"] = "ICE"
      #puts "ICE"
      when values[0].match(/170.137.*/)
      @feeds["#{values[1]}"] = "CBOE"
      #puts "CBOE"
      when values[0].match(/159.125.66.*/)
      @feeds["#{values[1]}"] = "AMEX"
      #puts "AMEX"
      when values[0].match(/205.209.*/)
      @feeds["#{values[1]}"] = "CME"  if  @feeds["#{values[0]}"].nil?
      #puts "CME"
      else
      end
    end
  end

  if @feeds.empty?
    ssh.exec!("ip=$(ps aux | grep demux | egrep -v grep  |  awk '{print $12}'); /sbin/ip addr show | grep \"$ip\" | awk '{print $7}'") do |ch,str,data|
        @feeds["#{data.chomp}"]="CME" if data.chomp.match(/eth*/)
     end
  end
  end

end
end
