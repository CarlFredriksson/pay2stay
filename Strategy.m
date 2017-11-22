classdef Strategy < handle
    
    methods
        function obj = Strategy()
        end

        function bid=nextBid(obj)
            bid = randi(4,1,1);
        end

    end
end