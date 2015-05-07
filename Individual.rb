# encoding: UTF-8

#
#	Evolution.ruby
#	(Konsolenanwendung in Ruby)
#
#	String-Evolution in Ruby mit Kreuzung und Mutation
#	erstellt von Conrad Kernrot 4-2015
#	github@conradhenke.de
#

class Individual

  #Bewertungsgewichtung
  WeightIdentical = 1.0
  WeightLength = 1.5

  #Mutationsrunden pro Mutation
  MutationRuns = 5

  def initialize(gene,genpool,optimal,lev=false)
    @genpool = genpool
    @lev = lev
    @gene = gene
    @optimal = optimal
    @optimalSubStrings = split_word(optimal)  #substrings speichern (performance)
  end

  def gene
    return @gene
  end

  # bewertet ein Individuum der Population auf Übereinstimmung mit dem Ziel (merkmal)
  def rating
      #Bewertet die Übereinstimmung der Länge
      def rateL
        return (@optimal.length - @gene.length).abs
      end
      #Bewertet das genaue Übereinstimmen
      def rateI
        value = 0.0
        @optimalSubStrings.each{ |t|
          worth = 1.0/t.length
          value += worth
          if(@gene.include?(t))
            value -= worth
          end 
        }
        return value
      end

      def levenshtein(first, second)
        matrix = [(0..first.length).to_a]
        (1..second.length).each do |j|
          matrix << [j] + [0] * (first.length)
        end
       
        (1..second.length).each do |i|
          (1..first.length).each do |j|
            if first[j-1] == second[i-1]
              matrix[i][j] = matrix[i-1][j-1]
            else
              matrix[i][j] = [
                matrix[i-1][j],
                matrix[i][j-1],
                matrix[i-1][j-1],
              ].min + 1
            end
          end
        end
        return matrix.last.last
      end

    if(@lev)
      return (rateL*WeightLength + rateI*WeightIdentical + levenshtein(@gene, @optimal))
    else
      return (rateL*WeightLength + rateI*WeightIdentical)
    end
  end

  #Zeichen hinzufügen
  def mutateAdd
    insertChar = @genpool.sample
    position = rand(@gene.length+1)
    @gene.insert(position,insertChar)
  end
  #Zeichen entfernen
  def mutateRem
    position = rand(@gene.length)
    @gene.slice!(position)
  end
  #Zeichen ändern
  def mutateChange
    insertChar = @genpool.sample
    position = rand(@gene.length)-1
    if (@gene[position] != insertChar)
      @gene[position] = insertChar
    else
     mutateChange #nochmal versuchen falls keine Änderung (recursion is fun)
    end
  end

  def mutate
    unmutated = @gene.dup
    # Mutationsrunden die je ein Zeichen ändern
    for i in 0...rand(MutationRuns)
      case rand(3)
        when 0
          mutateAdd
        when 1
          mutateChange
        when 2
          if(@gene.length<2)
            mutateRem
          end
      end
    end

    # nochmal wenn mutation nicht verschieden (recursion is fun)
    if (unmutated == @gene)
      mutate
    end
  end

  def to_s
    return gene + " : " + rating.to_s
  end

  #return alle Substrings eines strings
  def split_word s
    return (0..s.length).inject([]){|ai,i|
      (1..s.length - i).inject(ai){|aj,j|
        aj << s[i,j]
      }
    }.uniq
  end

end
