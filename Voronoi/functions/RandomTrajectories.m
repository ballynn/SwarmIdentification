clear
clc
close all

addpath('functions')

%Initiate
n = 8; %Plane Size (units) x&y -> (0,n)
timestep = 0.1; %timesteps (s)
t_final = 20; %final simulation time (s)
time = 0:timestep:t_final;

%Generate Random starting location for Evader
A_init = n*rand(1,2);

%Generate Random Path for Evader
Xdot = randomwalk_4(t_final,timestep,A_init(1),A_init(2),n);

A = Xdot([1,2],:);

 %Reset the bounds to fit within an 8 by 8 block x&y -> (0,n)
 if min(A(1,:)) < 0
     A(1,:) = A(1,:) - min(A(1,:));
 end
 if min(A(2,:)) < 0
     A(2,:) = A(2,:) - min(A(2,:));
 end
 
 A(1,:) = n*A(1,:)/max(A(1,:));
 A(2,:) = n*A(2,:)/max(A(2,:));

%Plot
figure(1)
plot(A(1,:),A(2,:),'o-')
xlabel('Ax (m)')
ylabel('Ay (m)')
title('Random Path Taken by Evader Drone - Filtered')