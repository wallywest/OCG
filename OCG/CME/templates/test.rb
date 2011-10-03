require 'erubis'
insert={"ilinks"=>[{"compid"=>"6QK3P7N", "password"=>"imusk", "subid"=>"JCONNORS", "port"=>"9036", "host"=>"205.209.216.129"}], "isdefault"=>"yes", "isquoting"=>"false", "sym"=>["LE"]}
f=File.read("test.conf.eruby")
eruby=Erubis::EscapedEruby.new(f)
puts eruby.result(insert)
