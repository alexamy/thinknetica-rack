require 'date'
require_relative 'time_response'

class App
  def call(env)
    path = env['REQUEST_PATH']
    params = parse_query(env['QUERY_STRING'])
    process(path, params)
  end

  def process(path, params)
    return response(404) unless path == '/time'
    time_response(params)
  end

  def time_response(params)
    keys = params['format']&.split(',') || []
    time = TimeResponse.call(keys)

    if time.valid?
      response(200, time.success)
    else
      response(400, time.unknown_format)
    end
  end

  private

  def parse_query(query)
    query = query.gsub('%2C', ',')
    query.split('&').map { |s| s.split('=') }.to_h
  end

  def response(status, message = '')
    headers = { 'Content-Type' => 'text/plain' }
    Rack::Response.new(message, status, headers).finish
  end
end
