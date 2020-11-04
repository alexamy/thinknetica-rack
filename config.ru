require_relative 'middleware/runtime.rb'
require_relative 'middleware/logger.rb'
require_relative 'app'

use Runtime
use AppLogger
run App.new
