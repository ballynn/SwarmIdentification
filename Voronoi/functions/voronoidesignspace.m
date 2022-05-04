function [vx1_new,vx2_new,vy1_new,vy2_new] = voronoidesignspace(vx1,vx2,vy1,vy2,n)
%Computes the voronoi boundary point on the edge of the design space (0,n)
    m = (vy2 - vy1)/(vx2 - vx1);
    
    if (vx1 > n)
        vx1 = n;
        vy1 = m*(vx1 - vx2) + vy2;
    end
    
    if (vx1 < 0)
        vx1 = 0;
        vy1 = m*(vx1 - vx2) + vy2;
    end
    
    if (vx2 > n)
        vx2 = n;
        vy2 = m*(vx2 - vx1) + vy1;
    end
    
    if (vx2 < 0)
        vx2 = 0;
        vy2 = m*(vx2 - vx1) + vy1;
    end
    
    if (vy1 > n)
        vy1 = n;
        vx1 = (vy1 - vy2)/m + vx2;
    end
    
    if (vy1 < 0)
        vy1 = 0;
        vx1 = (vy1 - vy2)/m + vx2;
    end
    
    if (vy2 > n)
        vy2 = n;
        vx2 = (vy2 - vy1)/m + vx1;
    end
    
     if (vy2 < 0)
        vy2 = 0;
        vx2 = (vy2 - vy1)/m + vx1;
     end
    
     vx1_new = vx1;
     vy1_new = vy1;
     vx2_new = vx2;
     vy2_new = vy2;
end

