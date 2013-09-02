require "sinatra"

set :environment, :production
disable :run, :reload

require File.join(File.dirname(__FILE__), 'yapg')
run Yapg
