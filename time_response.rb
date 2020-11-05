class TimeResponse
  ALLOWED_KEYS = %w[year month day hour minute second]
  METHOD_MAPPING = { 'minute' => 'min', 'second' => 'sec' }

  def initialize(keys)
    @keys = keys
    @keys_unknown = @keys.difference(ALLOWED_KEYS)
  end

  def valid?
    @keys_unknown.any?
  end

  def success
    now = DateTime.now
    @keys.map { |key| now.send(METHOD_MAPPING[key] || key) }.join('-') + "\n"
  end

  def unknown_format
    "Unknown time format [#{@keys_unknown.join(', ')}]\n"
  end
end
