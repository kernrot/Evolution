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
runs = 10

runs.times do
	startIteration = Time.now

	usedIterations = 0
	maxIterations = 100000

	enviroment = Enviroment.new("MUTANTEN",100,false)
	#population.print_configuration

	iteration = 0
	bestIndividual = 10000
	bestPopulation = 10000
	lastPopulation = 10000

	while iteration<maxIterations do

		iteration+=1
		usedIterations = iteration

		enviroment.mutate
		enviroment.crossover
		enviroment.selektion
		
		if(enviroment.population.first.rating<=bestIndividual)
			bestIndividual = enviroment.population.first.rating
			print "^"
			#puts ""
			#puts "Fittest in Iteration " + iteration.to_s + ": " + enviroment.population.first.to_s
		end

		if(enviroment.populationFittness<bestPopulation)
			bestPopulation = enviroment.populationFittness
			lastPopulation = bestPopulation
			print "*"
		else
			if (enviroment.populationFittness<lastPopulation)
				print "+"
			else
				print "-"
			end
			lastPopulation = enviroment.populationFittness
		end

		if(bestIndividual.round(5) == 0.0)
			puts ""
			puts "Zielmerkmal gefunden in Iteration: " + iteration.to_s
			iteration = maxIterations+1
		end
		
		
		$stdout.flush
	end

	finishIteration = Time.now
	runtime = (finishIteration - startIteration)

	puts ""
	puts "Population: " + usedIterations.to_s
	puts "Runtime: " + runtime.to_s + "sec"
	puts "=============================="
	enviroment.show

	File.open("runtimes.log", 'a') {|f| f.write(usedIterations.to_s + " " + runtime.to_s + "\n") }
end
