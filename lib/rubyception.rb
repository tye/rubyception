require 'haml'
require 'compass'
require 'coffee-script'
require 'rubyception/engine'
module Rubyception
  mattr_accessor :threads
  self.threads = []
end
