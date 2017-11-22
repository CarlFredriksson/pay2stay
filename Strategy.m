classdef Strategy < handle
    
    properties
        id
    end
    
    methods
        function obj = Strategy(id)
            obj.id = id;
        end

        function bid=nextBid(obj)
            bid = randi(4,1,1);
        end

    end
end