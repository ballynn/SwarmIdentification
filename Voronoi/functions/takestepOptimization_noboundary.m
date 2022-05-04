function [x,y,a] = takestepOptimization_noboundary(Q,stepsize)
%The input is two functions: a of size 1xm and B of size 2xm. B contains x
%y coordinates 
xold = Q(2);
yold = Q(3);
x1 = Q(4);
y1 = Q(5);

slope = (y1 - yold) ./ (x1 - xold);
a = atand(slope);

distance = sqrt((y1-yold)^2 + (x1 - xold)^2);

% x = (stepsize)*(x1 - xold) + xold;
% y = (stepsize)*(y1 - yold) + yold;

x = (1 - (stepsize/distance))*xold + (stepsize/distance)*x1;
y = (1 - (stepsize/distance))*yold + (stepsize/distance)*y1;
end