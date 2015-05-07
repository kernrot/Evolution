# encoding: UTF-8

#
#	Evolution.ruby
#	(Konsolenanwendung in Ruby)
#
#	String-Evolution in Ruby mit Kreuzung und Mutation
#	erstellt von Conrad Kernrot 4-2015
#	github@conradhenke.de
#

require "./Enviroment.rb"
require "test/unit" 

class TestEnviroment < Test::Unit::TestCase

  def test_selection
    oldSize = @enviroment.population.length
    @enviroment.selektion
    assert(oldSize>@enviroment.population.length)
  end

  def setup
    @enviroment = Enviroment.new()
  end 

  def teardown
  end 
end

