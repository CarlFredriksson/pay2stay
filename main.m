clc;
clear;


% CONSTANTS
WIDTH = 16;
HEIGHT = 16;
N_GENERATION = 100; % Number of steps in the evolutionary process
N_ROUNDS = 5; % Number of times the game is played for some set of 5 players
              % (we take average score over this)
N_STRATEGIES = 10;
              
grid = randi(N_STRATEGIES, HEIGHT, WIDTH);
fitness = grid;

wrapN = @(i, j) [1 + mod(i-1, HEIGHT), 1 + mod(j-1, WIDTH)];

movie = zeros(HEIGHT, WIDTH, N_GENERATION);

game = @(strategies) [0, 1, 2, 3, 4]; % placeholder fcn

for generation = 1:N_GENERATION
    for j=1:WIDTH
        for i=1:HEIGHT
            cs = grid(i,j);
            ns = grid(wrapN(i-1, j));
            es = grid(wrapN(i, j+1));
            ss = grid(wrapN(i+1, j));
            ws = grid(wrapN(i, j-1));

            for round = 1:N_ROUNDS
                results = game([cs, ns, es, ss, ws]);
                fitness(i, j) = fitness(i, j) + results(1);
                fitness(wrapN(i-1, j)) = fitness(wrapN(i-1, j)) + results(2);
                fitness(wrapN(i, j+1)) = fitness(wrapN(i, i+1)) + results(3);
                fitness(wrapN(i+1, j)) = fitness(wrapN(i+1, j)) + results(4);
                fitness(wrapN(i, j-1)) = fitness(wrapN(i, j-1)) + results(5);
            end
            
        end
    end
    
    for j=1:WIDTH
        for i=1:HEIGHT
            % Look at von Neumann neighbourhood for best fitness
            neighbours = [i, j; wrapN(i-1, j); wrapN(i, j+1); wrapN(i+1, j); wrapN(i, j-1)];
            [val, bestStrategyIndex1d] = max([...
                fitness(i, j), ...
                fitness(wrapN(i-1, j)), ...
                fitness(wrapN(i, j+1)), ...
                fitness(wrapN(i+1, j)), ...
                fitness(wrapN(i, j-1))]);
            
            bestStrategyIndex2d = neighbours(bestStrategyIndex1d);
            grid(i, j) = grid(bestStrategyIndex2d);
        end
    end
    
    movie(:, :, generation) = grid;
    
    fitness(:) = 0; % Reset the fitness (fitness doesnt carry over generations!)
end
movie = movie/max(movie(:));
implay(movie);
