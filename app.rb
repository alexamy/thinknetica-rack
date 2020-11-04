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
    ok
  end

  private

  def parse_query(query)
    query.split('&').map { |s| s.split('=') }.to_h
  end

  def ok
    [200, {}, []]
  end

  def not_found
    [404, {}, []]
  end
end
