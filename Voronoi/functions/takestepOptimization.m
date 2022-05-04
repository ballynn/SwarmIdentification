function [x,y,a] = takestepOptimization(Q,stepsize)
%The input is two functions: a of size 1xm and B of size 2xm. B contains x
%y coordinates 
xold = Q(2);
yold = Q(3);
x1 = Q(4);
y1 = Q(5);
x2 = Q(6);
y2 = Q(7);

midpoint = [(x1+x2)/2,(y1+y2)/2];

slope = (midpoint(2)-yold) ./ (midpoint(1) - xold);
a = atand(slope);
distance = sqrt((midpoint(2)-yold)^2 + (midpoint(1) - xold)^2);


%x = stepsize*(midpoint(1) - xold)  + xold;
%y = stepsize*(midpoint(2) - yold) + yold;

x = (1 - (stepsize/distance))*xold + (stepsize/distance)*midpoint(1);
y = (1 - (stepsize/distance))*yold + (stepsize/distance)*midpoint(2);

end