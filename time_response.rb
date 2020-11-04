class UnknownKeysException < StandardError
  attr_reader :msg

  def initialize(msg)
    @msg = msg
    super(msg)
  end
end

class TimeResponse
  ALLOWED_KEYS = %w[year month day hour minute second]
  METHOD_MAPPING = { 'minute' => 'min', 'second' => 'sec' }

  def self.call(keys)
    new(keys).response
  end

  def initialize(keys)
    @keys = keys
  end

  def response
    check_keys!
    now = DateTime.now
    @keys.map { |key| now.send(METHOD_MAPPING[key] || key) }.join('-') + "\n"
  end

  private

  def check_keys!
    unknown_keys = @keys.difference(ALLOWED_KEYS)

    if unknown_keys.any?
      unknown_format = "Unknown time format [#{unknown_keys.join(', ')}]\n"
      raise UnknownKeysException.new(unknown_format)
    end
  end
end
