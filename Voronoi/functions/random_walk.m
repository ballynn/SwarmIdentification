function [Ax2,Ay2] = random_walk(A,degA_0,steplength,t_final,timestep,maxangletimestep,n)

time = 0:timestep:t_final;
a = degA_0;
Ax = A(1);
Ay = A(2);

for i = 2:length(time)
    delta_a = 2*maxangletimestep*(rand - 0.5);
    a(i) = a(i-1) + delta_a;
    Ax(i) = Ax(i-1) + steplength*cosd(a(i));
    Ay(i) = Ay(i-1) + steplength*sind(a(i));
    
    while Ax(i) < 0 || Ax(i) > n || Ay(i) < 0 || Ay(i) > n 
        delta_a = 2*120*(rand - 0.5);
        a(i) = a(i-1) + delta_a;
        Ax(i) = Ax(i-1) + steplength*cosd(a(i));
        Ay(i) = Ay(i-1) + steplength*sind(a(i));
    end
    
end

Ax2 = Ax;
Ay2 = Ay;

plot(Ax,Ay,'o')
    xlabel('Horizontal Distance (units)')
    ylabel('Vertical Distance (units)')
    xlim([0,n])
    ylim([0,n])
    