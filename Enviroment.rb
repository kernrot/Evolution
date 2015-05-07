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

# Population ist ein Lehrbeispiel zum Thema "genetische Algorithmen" in 
# Analogie zur biologischen Evolution.

class Enviroment

  attr_accessor :wortliste
  attr_accessor :merkmal
  attr_accessor :anzahl
  
  #Genpool
  Genpool = [*'0'..'9', *'a'..'z', *'A'..'Z']

  #Überlebensanteil, Mutationswarscheinlichkeit (>0;<1)
  SurviveQuantity = 0.5
  MutationProbability = 0.25

  # Startpopulation initialisieren (Konstruktor)
  def initialize( optimal = "MUTANTEN", size = 100, lev=false)
    
    @lev = lev
    @space = size
    @optimal = optimal
    @population = Array.new(@space) do |i| 
      Individual.new(Genpool.sample( rand( 50)+ 1).join, Genpool, optimal, @lev)
    end
  end

  def population
    return @population
  end

  def populationFittness
    return @population.inject(0){ |sum, el| sum + (el.rating) }.to_f / @population.length
  end

  def genpool
    return Genpool
  end

  def print_configuration
    puts "Gewichungen C "+WeightContent.to_s
    puts "Gewichungen I "+WeightIdentical.to_s
    puts "Gewichungen L "+WeightLength.to_s
    puts "Überlebensanteil "+SurviveQuantity.to_s
    puts "Mutationsrunden pro Mutation: "+MutationRuns.to_s
    puts "Population initialisiert.\n"
  end

  # sortiert nach bewertung, behält die besser bewertete Hälfte der Population
  def selektion
    @population.sort! { |a,b| (a.rating <=> b.rating) }
    @population = @population[0...(@population.length*SurviveQuantity)]
  end

  #kreuzung zweier Elemente
  def mixIndividuals(vather, mother)

    # kindlänge ist zufällig länge von vater,mutter,avg(vater,mutter),zufällig
    length = [vather.gene.length, mother.gene.length,
              (0.5*(vather.gene.length+mother.gene.length)).ceil,
              (0.5*(vather.gene.length+mother.gene.length)).floor].sample

    parentGenes = (vather.gene+mother.gene).split("")

    child = ""
    length.times do |i|
      child+=parentGenes.sample
    end

    # nochmal wenn kind nicht verschieden von mutter und vater
    if ((child == vather) || (child == mother))
      child = mixIndividuals(vather,mother)
    end

    return Individual.new(child,Genpool,@optimal,@lev)
  end

  # kreuzung zufälliger Elemente(2) der Population, aufüllen auf alte Populationsgröße
  def crossover
    fromLastGen = @population.length
    while(@population.length<@space)

      vather = @population[0...10].sample
      mother = @population[10...fromLastGen].sample
      
      child = mixIndividuals(vather,mother)
      @population.push(child)

    end

  end

  # gesamte population mutieren
  def mutate
    @population.each{ |i|
      probability = 1.0/MutationProbability
      if((rand(probability)+1)%probability==0)
        i.mutate
      end
      } 
  end

  # Population anzeigen
  def show
    @population.sort! { |a,b| (a.rating <=> b.rating) }
    puts @population.map{ |i| i.to_s}
  end
end
