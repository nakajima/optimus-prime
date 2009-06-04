require 'rubygems'
require 'spec'
require 'rr'

require File.dirname(__FILE__) + '/../lib/optimus_prime'

Spec::Runner.configure { |c| c.mock_with(:rr) }