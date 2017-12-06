classdef Model
   properties
      payoffIndex
      eliminationIndex
   end
   methods
       
       % Takes index to payoff function
       % 1 = Simple payoff, 2 = linear payoff, 3 = exponential payoff
       function setPayoff(index)
           payoffIndex = val
       end
       
       % Takes index to elimination rule
       % 1 = Total elimination, 2 = unweight. elimination, 3 = weight. elim
       function setElimination(index)
           eliminationIndex = val
       end
       
       % Iterates the evolution in one step
       function evolve()
          % TODO: Implement 
       end
       
       % Returns the grid of strategies
       function getGrid()
          % TODO: Implement
       end
       
       % Returns the set of alive strategies at the current generation
       function getPopulation()
          % TODO: Implement (possibly as a function of getGrid()) 
       end
   end
end