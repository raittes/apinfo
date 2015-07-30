require 'sinatra'
require 'json'
require 'sysinfo'
require 'net/http'


class Apinfo < Sinatra::Base

  configure {
    set :server, :puma
    set :bind, "0.0.0.0"
  }

  s = SysInfo.new
  counter = 0
  public_ip = Net::HTTP.get URI "https://api.ipify.org"

  before do
    content_type :json
  end

  get '/' do
    counter += 1

    response = {}
    response['ip'] = s.ipaddress_internal
    response['counter'] = counter

    response.to_json
  end


  get '/info' do
    counter += 1
    sys = {}
    sys['hostname'] = s.hostname
    sys['ip'] = s.ipaddress_internal
    sys['public_ip'] = public_ip
    sys['linux'] = `head -1 /etc/issue.net`.chomp
    sys['kernel'] = `uname -r`.chomp

    var = {}
    var['uptime'] = `uptime`.chomp
    var['date'] = Time.now
    var['counter'] = counter

    response = {}
    response['system'] = sys
    response['variables'] = var

    response.to_json
  end


  get '/ip' do
    ip = {}
    ip["ip"] = s.ipaddress_internal
    ip["public_ip"] = public_ip

    ip.to_json
  end


  get '/counter' do
    counter += 1
    {"counter" => counter.to_i}.to_json
  end


  get '/sleep/:int' do |i|
    sleep i.to_i
    {"sleep" => i.to_i}.to_json
  end


  get '/kill' do
    Process.kill 'TERM', Process.pid
  end


end


if __FILE__ == $0
  Apinfo.run!
end
