classdef GameGrid < handle
    % GameGrid...
    
    % DEFINITIONS:
    % Turn - Each player bets a choosen amount and is either eliminated or
    %        recives a point.
    % Match - A match consists of N players and up to N-1 turns.
    %         Each player recives a score.
    % Round - A player plays 4 matches so that the player commpeats against
    %         all their neighburs (important in the case when N!=5)
    % Generation - All players plays their rounds and evolution occures
    
    
    properties
        nCoins
        width = 20
        height = 20
        nRounds = 3
        randomMutationRate = 0.01
        creepMutationRate = 0.02
        creepMutationLength = 0.1
        payoffType = 'linear'
        eliminationType = 'full'
        strategyGrid
        fitness
        startGeneration
        movie
    end
    
    methods
        function obj = GameGrid(nCoins)
            % Constructor
            obj.nCoins = nCoins;
            obj.initMovie();
        end
        
        function populateRandomly(obj)
            % Initiate the population with random strategies
            obj.strategyGrid = rand([obj.height, obj.width, obj.nCoins+1]);
            obj.strategyGrid = bsxfun(@rdivide, obj.strategyGrid, sum(obj.strategyGrid,3)); % Normalize propabilties
        end
        
        function initMovie(obj)
            obj.movie = zeros(obj.height, obj.width, 3, 1);
        end
        
        function run(obj, runNGenerations, shouldMutate)     
            obj.init(runNGenerations);
            for generation = 1:runNGenerations
                fprintf('Running: %.1f%%\n', generation/runNGenerations * 100);
                obj.step(generation, shouldMutate);
            end
        end
        
        function out = init(obj, runNGenerations)
            % Run the evolutionary grid
            
            %If initial generation record it
            obj.startGeneration = size(obj.movie,4);
            if obj.startGeneration == 1
                obj.movie(:,:,:,1) =  obj.strategyToColor();
            end
            
            % Allocate more space for movie
            obj.movie(:,:,:,end+1:end+runNGenerations) = zeros(obj.height, obj.width, 3, runNGenerations)
        end
        
        function out = step(obj, generation, shouldMutate)
            obj.fitness = zeros(obj.height, obj.width);
            
            % Play all rounds in this generation
            for j=1:obj.width
                for i=1:obj.height
                    obj.playRound(i,j);
                end
            end
            
            % Survival of the fittest
            for j=1:obj.width
                for i=1:obj.height
                    n = [i,j; obj.wrapV(i-1), obj.wrapH(j);...
                        obj.wrapV(i),   obj.wrapH(j+1); obj.wrapV(i+1), obj.wrapH(j);....
                        obj.wrapV(i),   obj.wrapH(j-1)];
                    [~,idx] = max([obj.fitness(n(1,1), n(1,2)), obj.fitness(n(2,1), n(2,2)),...
                        obj.fitness(n(3,1), n(3,2)), obj.fitness(n(4,1), n(4,2)),...
                        obj.fitness(n(5,1), n(5,2))]);
                    obj.strategyGrid(i, j, :) = obj.strategyGrid(n(idx, 1), n(idx, 2), :);
                end
            end
            
            % Mutation
            if shouldMutate
                for j=1:obj.width
                    for i=1:obj.height
                        for k=1:obj.nCoins
                            % Random mutation
                            if rand < obj.randomMutationRate
                                obj.strategyGrid(i,j,k) = rand;
                                obj.strategyGrid(i,j,:) = obj.strategyGrid(i,j,:)./sum(obj.strategyGrid(i,j,:));
                            end
                            % Creep Mutation
                            if rand < obj.creepMutationRate
                                obj.strategyGrid(i,j,k) = obj.strategyGrid(i,j,k) * (rand*2-1)*obj.creepMutationLength;
                                obj.strategyGrid(i,j,k) = min(1,max(0,obj.strategyGrid(i,j,k)));
                                obj.strategyGrid(i,j,:) = obj.strategyGrid(i,j,:)./sum(obj.strategyGrid(i,j,:));
                            end
                        end
                    end
                end
            end
            % Record movie
            obj.movie(:,:,:,obj.startGeneration+generation) = obj.strategyToColor();
        end
        
        function playRound(obj,ci,cj)
            % Play one round (see definition above)
            cp = [ci, cj];
            np = [obj.wrapV(ci-1), obj.wrapH(cj)];
            ep = [obj.wrapV(ci),   obj.wrapH(cj+1)];
            sp = [obj.wrapV(ci+1), obj.wrapH(cj)];
            wp = [obj.wrapV(ci),   obj.wrapH(cj-1)];
            
            for i=1:obj.nRounds
                obj.playMatch(cp, np, ep);
                obj.playMatch(cp, ep, sp);
                obj.playMatch(cp, sp, wp);
                obj.playMatch(cp, wp, np);
            end
        end
        
        function playMatch(obj, pos1, pos2, pos3)
            % Play one match and calculate scores (The payoff is alos defined here)
            % Store the score in the fitness matrix
            isAlive = [1, 1, 1];
            score = [0, 0, 0];
            bet1 = obj.drawBet(obj.strategyGrid(pos1(1), pos1(2), :));
            bet2 = obj.drawBet(obj.strategyGrid(pos2(1), pos2(2), :));
            bet3 = obj.drawBet(obj.strategyGrid(pos3(1), pos3(2), :));
            bets = [bet1, bet2, bet3];
            
            idx = ( find(bets == min(bets)) );
            isAlive(idx) = 0;
            score = score + isAlive;
            
            if sum(isAlive) == 2
                bets = obj.nCoins-bets;
                bets(isAlive==0) = inf;
                idx = ( find(bets == min(bets)) );
                isAlive(idx) = 0;
                score = score + isAlive;
            end
            
            %Store score in fitness matrix
            obj.fitness(pos1(1), pos1(2)) = obj.fitness(pos1(1), pos1(2)) + score(1);
            obj.fitness(pos2(1), pos2(2)) = obj.fitness(pos2(1), pos2(2)) + score(2);
            obj.fitness(pos3(1), pos3(2)) = obj.fitness(pos3(1), pos3(2)) + score(3);
        end
        
        function storePayoff(obj, pos1, pos2, pos3, outcome)
            % NOT IMPLEMENTED YET
            % Compute and acummulate payoff in the fitness matrix
            if obj.payoffType == 'simple'
                payoff = sum(outcome(2,:));
            elseif obj.payoffType == 'linear'
                payoff = sum(outcome);
            elseif obj.payoffType == 'non-linear'
                outcome(2,:) = 2*outcome(2,:);
                payoff = sum(outcome);
            end
            
            obj.fitness(pos1(1), pos1(2)) = obj.fitness(pos1(1), pos1(2)) + payoff(1);
            obj.fitness(pos2(1), pos2(2)) = obj.fitness(pos2(1), pos2(2)) + payoff(2);
            obj.fitness(pos3(1), pos3(2)) = obj.fitness(pos3(1), pos3(2)) + payoff(3);
        end
        
        function bet = drawBet(~, strategy)
            % Randomly select a bet based on the mixed strategy
            cdf = cumsum(strategy);
            r = rand;
            cdf(cdf<r) = 2;
            [~, bet] = min(cdf);
            bet = bet-1;
        end
        
        function i = wrapV(obj,i)
            % Cyclical indexes in vertical direction
            i = 1 + mod(i-1, obj.height);
        end
        function j = wrapH(obj,j)
            % Cyclical indexes in horisontal direction
            j = 1 + mod(j-1, obj.width);
        end
        
        function cg = strategyToColor(obj)
            % Map all colors to strategies
            cg = zeros(obj.height, obj.width, 3);
            split1 = ceil(size(obj.strategyGrid,3)/3);
            split2 = ceil(size(obj.strategyGrid,3)*2/3);
            cg(:,:,1) = sum(obj.strategyGrid(:,:,1:split1),3);
            cg(:,:,2) = sum(obj.strategyGrid(:,:,split1+1:split2),3);
            cg(:,:,3) = sum(obj.strategyGrid(:,:,split2+1:end),3);
        end
        
        % Payoff setter
        function out = setPayoff(obj, str)
            payoffType = lower(str);
        end
        
        % Elimination rule setter
        function out = setElimination(obj, str)
            eliminationType = lower(str);
        end
        
        % Coins setter
        function out = setCoins(obj, val)
            nCoins = max(1, val); % Only allow natural numbers wout zero
        end
    end
end