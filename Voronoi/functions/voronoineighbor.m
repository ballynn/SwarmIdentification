function [vn] = voronoineighbor(x,gameSize)
[ n, dim ] = size ( x );
%
% V contains the Voronoi vertices,
% C contains indices of Voronoi vertices that form the (finite sides of the)
% Voronoi cells.
%
[ V, C ] = voronoin (x);
%
% Two nodes are neighbors if they share an edge, that is, two Voronoi
% vertices.
%


for i = 2: size(V,1)
    if V(i,1) > gameSize || V(i,2) > gameSize
  %      dummyV(i,:) = [];
        for j = 1:length(C)
            r = C{j};
            r(find(C{1} == i)) = [];
            C{j} = r;
        end
    end
end
            
            
vn = sparse ( n, n );
for i = 1 : n
    for j = i + 1 : n
        s = size ( intersect ( C{i}, C{j} ) );
        if ( 1 < s(2) )
            vn(i,j) = 1;
            vn(j,i) = 1;
        end
    end
end

end

