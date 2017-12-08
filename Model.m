% Model class that has GameGrid as a component
% The GUI communicates directly with this Model class
% On event from the gui, the corresponding method is called within this
% class. The methods of this class (should) depend on GameGrid.

classdef Model
   properties
       
      % The actual class doing the simulation
      gameGrid = GameGrid(9);
       
      payoff = 0;
      elimination = 0;
      coins = 0;
      running = 0;
      
      % TODO: Let class by Johan be member of this Model
      % Implement setPayoff, setElimination, getGrid and evolve
      % in terms of the class by Johan
      
   end
   methods
       
       % Takes string indicating payoff function
       function out = setPayoff(obj, str)
           obj.payoff = str;
           obj.reset(); % Make sure to reset model after changing payoff
           obj.gameGrid.setPayoff(obj.payoff);
       end
       
       % Takes string indicating elimination rule
       function out = setElimination(obj, str)
           obj.elimination = str;
           obj.reset(); % Make sure to reset model after changing elimination
           obj.gameGrid.setElimination(obj.elimination);
       end
       
       function out = setCoins(obj, val)
           obj.coins = val;
           obj.reset();
           obj.gameGrid.setCoins(obj.coins);
       end
       
       % Iterates the evolution in one step
       function out = evolve(obj)
          % TODO: Implement 
       end
       
       % Reset whole simulation
       function out = reset(obj)
          % TODO: Implement
       end
       
       % Toggle between running and not running state
       function out = toggle(obj)
           
          % FIXME: I have no clue why obj.running doesnt alter 0,1
          obj.running = 1 - obj.running;
          
          % TODO: Implement.
          % Problem: If just doing a while-loop here
          % GUI would freeze
          % Solution: Run game on thread
          % Problem: Thats way to complicated for this project
          % Solution: Just press step several times? Hmmm...
          
       end
       
       % Returns the grid of strategies
       function out = getGrid(obj)
          % TODO: Implement
       end
       
       % Returns the set of alive strategies at the current generation
       function out = getPopulation(obj)
          % TODO: Implement (possibly as a function of getGrid()) 
       end
   end
end