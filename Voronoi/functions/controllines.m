function [final] = controllines(vx,vy,x,y,gameSize)

dt = delaunayTriangulation(x',y');
[q,R] = voronoiDiagram(dt);
V = voronoineighbor([x;y]',gameSize);

for i = 2:(size(q,1)-1)
    [q(i,1),q((i+1),1),q(i,2),q((i+1),2)] =  voronoidesignspace(q(i,1),q((i+1),1),q(i,2),q((i+1),2),gameSize);
end

checker = q;
checker([R{1}],:) = [];


control = [];
linetoCheck = [];
distancePursuer = [];


for i  = 2:length(x)
    
    %If the evader and pursuer share a boundary
    if V(1,i) == 1
        
        %determine if there is an internal intersection of points
        intersection = intersect(R{i}(2:end),R{1}(2:end));
        
        %if two vertices are shared as a boundary we have the control line
        if length(intersection) == 2
            
            control = [control; i, x(i), y(i), q(intersection(1),:), q(intersection(2),:)];
        %if one vertex is shared determine control line by figuring out the
        %closest line to the evader
        elseif length(intersection) == 1
            
            for j = 1:length(vx)
                %determine lines that contain the shared vertex
                if vx(1,j) == q(intersection(1),1) || vx(2,j) == q(intersection(1),1)
                    
                    %if the second vertex is a a vertex that does not belong to the
                    %evader do nothing
                    check1 = ismember([vx(1,j),vy(1,j)],checker);
                    check2 = ismember([vx(2,j),vy(2,j)],checker);
                    if check1(1) == 1 || check2(1) == 1
                    else
                        linetoCheck = [linetoCheck; vx(1,j), vy(1,j),vx(2,j),vy(2,j)];
                    end
                end
            end
          
            if isempty(linetoCheck) == 1
            else
                for k = 1:size(linetoCheck,1)
                    %deteremine the midpoints of the lines
                    midpoint(k,:) = [(linetoCheck(k,1) + linetoCheck(k,3))/2, (linetoCheck(k,2) + linetoCheck(k,4))/2];
                    %determine the distance from the midpoint to the
                    %evader
                    %distanceEvader(k) = [sqrt((midpoint(k,1) - x(1))^2 + (midpoint(k,2) - y(1))^2)];
                    distancePursuer(k) = [sqrt((midpoint(k,1) - x(i))^2 + (midpoint(k,2) - y(i))^2)];
                end

                %[~,lineEvader] = find(min(distanceEvader) == distanceEvader);
                [~,lineEvader] = find(min(distancePursuer) == distancePursuer);
                control = [control; i,x(i),y(i), linetoCheck(lineEvader,:)]; 
      
        
                 linetoCheck = [];
                 distancePursuer = [];
            end
    %   clear distancePursuer
                
      end
    end


final = control;
        

end