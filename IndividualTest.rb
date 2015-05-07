# encoding: UTF-8

#
#	Evolution.ruby
#	(Konsolenanwendung in Ruby)
#
#	String-Evolution in Ruby mit Kreuzung und Mutation
#	erstellt von Conrad Kernrot 4-2015
#	github@conradhenke.de
#

require "./Individual.rb"
require "test/unit" 

class TestIndividual < Test::Unit::TestCase
	
	Genpool = [*'0'..'9', *'a'..'z', *'A'..'Z']

	def test_initalisation
		i = Individual.new("IndividualGENE",Genpool,"TargetGENE")
		assert("IndividualGENE" == i.gene)
	end

	def test_rating
		testGene = ["GENE1", "GENA", "GENEN"] # alle verlieren

		testGene.each{ |t|
			loose = Individual.new(t,Genpool,"GENE")
			assert(loose.rating > 0)
		}

		win = Individual.new("TargetGENE",Genpool,"TargetGENE")
		assert(win.rating == 0)
	end

	def test_mutation
		i = Individual.new("IndividualGENE",Genpool,"TargetGENE")
		i.mutate
		assert(i.gene != "IndividualGENE")
		assert(i.gene != "")
	end

	def test_mutationAdd
		i = Individual.new("IndividualGENE",Genpool,"TargetGENE")
		oldLength = i.gene.length
		i.mutateAdd
		assert(i.gene.length>oldLength)
	end

	def test_mutationAdd
		i = Individual.new("IndividualGENE",Genpool,"TargetGENE")
		oldLength = i.gene.length
		i.mutateRem
		assert(i.gene.length<oldLength)
	end

	def test_mutationChange
		i = Individual.new("IndividualGENE",Genpool,"TargetGENE")
		oldGene = i.gene.dup
		i.mutateChange
		assert(i.gene!=oldGene)
		assert(i.gene.length==oldGene.length)
	end

	def setup
	end 

	def teardown
	end 

end