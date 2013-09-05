$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

# coveralls code coverage bit
require 'coveralls'

Coveralls.wear!

require "lotrd"