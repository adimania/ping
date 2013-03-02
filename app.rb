require "net/http"
require 'rubygems'
require 'dnsruby'

include Dnsruby

get '/' do
    "Some stuff going around here. You wouldn't know."
end

get '/agent' do
    request.user_agent
end

get '/ip' do
    @env['HTTP_X_FORWARDED_FOR']
end

get '/rcode' do
    begin
        if params[:url][0..6]!="http://"
            uri="http://#{params[:url]}"
        else
            uri=params[:url]
        end
        response = Net::HTTP.get_response(URI.parse(uri))
        uri+" => "+response.code+" - "+response.message
    rescue StandardError => e
        e.to_s
    end
end

get '/mx' do
    begin
        resolver = Resolver.new({:nameserver => ["8.8.8.8","8.8.4.4"]})
        mx=resolver.query(params[:domain], "MX")
        mx.answer.size
        mx.answer.each do |server|
            server
        end
#        mx=Resolv::DNS.open.getresources(params[:domain], Resolv::DNS::Resource::IN::MX)
#        mx.size
#        if mx.size > 0        
#            mx.each do |server|
#               server.excahnge
#            end
#        end
    rescue StandardError => e
        e.to_s
    end
end

