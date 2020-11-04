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
    keys = params['format']&.split(',') || []
    allowed_keys = %w[year month day hour minute second]

    unknown_keys = keys.difference(allowed_keys)
    return bad_format(unknown_keys) if unknown_keys.any?

    ok
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

  def ok
    [200, {}, []]
  end

  def not_found
    [404, {}, []]
  end
end
