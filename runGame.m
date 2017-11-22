% Every row in strategies is for 1 player.
% Players receive 1 point per survived round.
% 0 rows in alivePlayers denote dead players.
function payouts=runGame(strategies)
    numPlayers = size(strategies, 1);
    maxNumRounds = numPlayers;
    payouts = zeros(numPlayers, 1);
    alivePlayers = 1:numPlayers;
    
    for i=1:maxNumRounds
        % Find lowest bidders
        minVal = inf;
        minIndices = [];
        for j=1:length(alivePlayers)
            currentPlayer = alivePlayers(j);
            if (currentPlayer ~= 0)
                currentVal = strategies{j}.nextBid();
                if (currentVal < minVal)
                    minVal = currentVal;
                    minIndices = currentPlayer;
                elseif (currentVal == minVal)
                    minIndices = [minIndices; currentPlayer];
                end
            end
        end
        
        % Remove lowest bidders
        alivePlayers(minIndices) = 0;

        % Break if no players left
        if (sum(alivePlayers) == 0)
            break;
        end
        
        % Add 1 point for each surviving player
        for j=1:length(alivePlayers)
            currentPlayer = alivePlayers(j);
            if (currentPlayer ~= 0)
                payouts(currentPlayer) = payouts(currentPlayer) + 1;
            end
        end
    end
end