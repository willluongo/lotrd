$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

# coveralls code coverage bit
require 'coveralls'

Coveralls.wear!

module Helpers
  # Replace standard input with faked one StringIO. 
  def fake_stdin(text)
    begin
      $stdin = StringIO.new
      $stdin.puts(text)
      $stdin.rewind
      yield
    ensure
      $stdin = STDIN
    end
  end
end

RSpec.configure do |conf|
  conf.include(Helpers)
end

require "lotrd"