require 'faraday'
require 'yaml'
#require 'base64'
require 'json'
require 'pp'

class RallyConnector
  attr_reader :server, :apikey, :workspace, :endpoint, :connection
  def initialize(config ={})
    @server = config['server']
    @apikey = config['apikey']
    @workspace = config['workspace'].to_s
    @endpoint = config['type']
    @connection = Faraday.new(:url => @server) do |faraday|
      faraday.request  :url_encoded             
      #faraday.response :logger                  
      faraday.adapter  Faraday.default_adapter  
    end
  end
  def execute_request(method, endpoint, options={}, data=nil, extra_headers=nil)
    response = @connection.send(method) do |req|
    if !options.empty?
      option_items = options.collect {|key, value| "#{key}=#{value}"}
      endpoint << "?" << option_items.join("&")
    end

    #puts "issuing a #{method.to_s.upcase} request for endpoint: #{endpoint}"

    req.url(endpoint)
    req.headers['Content-Type'] = 'application/json'
    req.headers['zsessionid'] = @apikey
    if data
      req.body = data.to_json
    end
  end

  payload = response.body
  begin
    payload = JSON.parse(payload)
  rescue => e
    puts e.message
  end
    payload["QueryResult"]["TotalResultCount"] 
  end
end
