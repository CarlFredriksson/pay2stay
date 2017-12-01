clc;
clear;


% CONSTANTS
WIDTH = 32;
HEIGHT = 32;
N_GENERATION = 500; % Number of steps in the evolutionary process
N_ROUNDS = 5; % Number of times the game is played for some set of 5 players
              % (we take average score over this)
N_STRATEGIES = 4;

strategies = {Strategy(1);Strategy(2);Strategy(3);Strategy(4)};
              
grid = randi(N_STRATEGIES, HEIGHT, WIDTH);
fitness = grid;

wrapN = @(i, j) [1 + mod(i-1, HEIGHT), 1 + mod(j-1, WIDTH)];
wrapH = @(i) 1 + mod(i-1, HEIGHT);
wrapW = @(j) 1 + mod(j-1, WIDTH);

movie = zeros(HEIGHT, WIDTH, N_GENERATION+1);

game = @(strategies) [0, 1, 2, 3, 4]; % placeholder fcn

movie(:, :, 1) = grid;

for generation = 1:N_GENERATION
    fprintf('Running: %f%%\n', generation/N_GENERATION * 100);
    for j=1:WIDTH
        for i=1:HEIGHT
            cs = grid(i,j);
            ns = grid(wrapH(i-1),wrapW(j));
            es = grid(wrapH(i),wrapW(j+1));
            ss = grid(wrapH(i+1),wrapW(j));
            ws = grid(wrapH(i),wrapW(j-1));
            gameStrategies = {strategies{cs}; strategies{ns}; strategies{es}; strategies{ss}; strategies{ws}};

            for round = 1:N_ROUNDS
                results = runGame(gameStrategies);
                fitness(i, j) = fitness(i, j) + results(1);
                fitness(wrapH(i-1), wrapW(j)) = fitness(wrapH(i-1), wrapW(j)) + results(2);
                fitness(wrapH(i), wrapW(j+1)) = fitness(wrapH(i), wrapW(j+1)) + results(3);
                fitness(wrapH(i+1), wrapW(j)) = fitness(wrapH(i+1), wrapW(j)) + results(4);
                fitness(wrapH(i), wrapW(j-1)) = fitness(wrapH(i), wrapW(j-1)) + results(5);
            end
            
        end
    end
    
    for j=1:WIDTH
        for i=1:HEIGHT
            % Look at von Neumann neighbourhood for best fitness
            neighbours = [i, j; wrapN(i-1, j); wrapN(i, j+1); wrapN(i+1, j); wrapN(i, j-1)];
            [val, bestStrategyIndex1d] = max([...
                fitness(i, j), ...
                fitness(wrapH(i-1),wrapW(j)), ...
                fitness(wrapH(i), wrapW(j+1)), ...
                fitness(wrapH(i+1), wrapW(j)), ...
                fitness(wrapH(i), wrapW(j-1))]);

            bestStrategyIndex2d = neighbours(bestStrategyIndex1d,:);
            grid(i, j) = grid(bestStrategyIndex2d(1),bestStrategyIndex2d(2));
        end
    end
    
    movie(:, :, generation+1) = grid;
    
    fitness(:) = 0; % Reset the fitness (fitness doesnt carry over generations!)
end
movie = movie/max(movie(:));
implay(movie);
