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
      not_found
    end
  end

  def time(params)
    format = params['format'] || ''

    keys = format.split(',')
    allowed_keys = %w[year month day hour minute second]

    unknown_keys = keys.difference(allowed_keys)
    return bad_format(unknown_keys) if unknown_keys.any?

    now = DateTime.now
    mapping = { 'minute' => 'min', 'second' => 'sec' }
    body = keys.map { |key| now.send(mapping[key] || key) }.join('-') + "\n"

    ok([body])
  end

  private

  def parse_query(query)
    query.gsub!('%2C', ',')
    query.split('&').map { |s| s.split('=') }.to_h
  end

  def bad_format(keys)
    [
      400,
      { 'Content-Type' => 'text/plain' },
      ["Unknown time format [#{keys.join(', ')}]\n"]
    ]
  end

  def ok(body)
    [
      200,
      { 'Content-Type' => 'text/plain' },
      body
    ]
  end

  def not_found
    [
      404,
      {},
      []
    ]
  end
end
