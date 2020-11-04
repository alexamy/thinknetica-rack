require 'date'
require_relative 'time_response'

class App
  def call(env)
    path = env['REQUEST_PATH']
    params = parse_query(env['QUERY_STRING'])
    router(path, params)
  end

  def router(path, params)
    case path
    when '/time'
      time(params)
    else
      response(404)
    end
  end

  def time(params)
    keys = params['format']&.split(',') || []
    response(200, TimeResponse.call(keys))
  rescue UnknownKeysException => e
    response(400, e.msg)
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
