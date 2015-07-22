function [ varargsout ] = findnearmaxpoint( x, width )
%FINDNEARMAXPOINT Summary of this function goes here
%   Detailed explanation goes here
len = length(x);

varargsout = [];

container = [x(1,:)];

for i = 2 : len

    if abs( x(i-1,1) - x(i,1) ) <= width
        container = [ container ; x(i,:) ];
        if i == len
            [~, idx] = max(container(:,2));
            varargsout = [ varargsout ; container(idx,:)];
            container = [];    
        end
    else
        [~, idx] = max(container(:,2));
        varargsout = [ varargsout ; container(idx,:)];
        container = [x(i,:)];
    end
    
end

end

