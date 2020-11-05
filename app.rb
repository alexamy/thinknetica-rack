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
    response = TimeResponse.new(keys)

    if response.valid?
      response(200, response.success)
    else
      response(400, response.unknown_format)
    end
  end

  private

  def parse_query(query)
    query = query.gsub('%2C', ',')
    query.split('&').map { |s| s.split('=') }.to_h
  end

  def response(code, message = '')
    [
      code,
      { 'Content-Type' => 'text/plain' },
      [message]
    ]
  end
end
