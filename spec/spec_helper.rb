require 'rubygems'
require 'spec'
require 'cgi'
require 'rr'

require File.dirname(__FILE__) + '/../lib/optimus_prime'

Spec::Runner.configure { |c| c.mock_with(:rr) }

def pre(*args)
  args.each { |str| puts "<pre>" + CGI.escapeHTML(str) + "</pre>" }
end