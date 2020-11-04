require 'date'

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
    format = params['format'] || ''

    keys = format.split(',')
    allowed_keys = %w[year month day hour minute second]
    unknown_keys = keys.difference(allowed_keys)

    if unknown_keys.any?
      unknown_format = "Unknown time format [#{unknown_keys.join(', ')}]\n"
      return response(400, unknown_format)
    end

    now = DateTime.now
    mapping = { 'minute' => 'min', 'second' => 'sec' }
    time_response = keys.map { |key| now.send(mapping[key] || key) }.join('-') + "\n"
    response(200, time_response)
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
