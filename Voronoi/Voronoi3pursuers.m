clear
clc
close all

%% Files

functionpath = '/Users/lynnsargent/Documents/University of Miami/DARPA_Polyplexus/Optimization/functions';
userpath(functionpath)
csvpath = '/Users/lynnsargent/Documents/University of Miami/DARPA_Polyplexus/Optimization/results/singleevader';
Filename = sprintf('optimization_3pursuers_%s.csv', datestr(now,'mm-dd-yyyy HH-MM'));

fullFileName = fullfile(csvpath, Filename);
csvtitle = {'time', 'Evader_x', 'Evader_y', 'Pursuer1_x', 'Pursuer1_y', 'Pursuer2_x', 'Pursuer2_y', 'Puruser3_x', 'Pursuer3_y'};
commaHeader = [csvtitle;repmat({','},1,numel(csvtitle))];

commaHeader = commaHeader(:)';
textHeader = cell2mat(commaHeader); %cHeader in text with commas

%write header to file
fid = fopen(fullFileName,'w'); 
fprintf(fid,'%s\n',textHeader)
fclose(fid)

%% Initialization
%Initiate
n = 10; %Plane Size (units)
timestep = 0.1; %timesteps (s)
t_final = 200; %final simulation time (s)
stepLength = 0.1; %length of each step taken
time = 0;
dc = 0.1;
maxangle_timestep = 10;

%Generate Random starting location for Evader & Pursuers
B1 = n*rand(1,2);
B2 = n*rand(1,2);
B3 = n*rand(1,2);

%Generate Random Walk for A
A = n*rand(1,2);
degA_0 = 360*rand;

[a1,a2] = random_walk(A,degA_0,stepLength,t_final,timestep,maxangle_timestep,n);

%Testing Parameters
a = [90 90 90 90];
a_new = [];
f=1;
rc = 50;
dist = [];

%Compute the Voronoi Diagram
x = [A(1) B1(1) B2(1) B3(1)];
y = [A(2) B1(2) B2(2) B3(2)];

[vx,vy] = voronoi(x,y);
%Limit the voronoi points to the design space
     for k=1:length(vx)
        [vx2(1,k),vx2(2,k),vy2(1,k),vy2(2,k)] = voronoidesignspace(vx(1,k),vx(2,k),vy(1,k),vy(2,k),n);
     end
%  figure(1)
%      plot(vx2,vy2,A(1),A(2),'bo',B1(1),B1(2),'ro',B2(1),B2(2),'ro',B3(1),B3(2),'ro')
%      xlim([0,n])
%      ylim([0,n])
%      text(A(1),A(2), 'Evader 1')
%      text(B1(1),B1(2), 'Pursuer 2')
%      text(B2(1),B2(2), 'Pursuer 3')
%      text(B3(1),B3(2), 'Pursuer 4')
%          xlabel('Horizontal Distance (units)')
%     ylabel('Vertical Distance (units)')


%% Optimization Algorithm
while rc > dc
     %Compute the Voronoi Diagram
     [vx,vy] = voronoi(x,y);
        
     %Limit the voronoi points to the design space
     for k=1:length(vx)
        [vx2(1,k),vx2(2,k),vy2(1,k),vy2(2,k)] = voronoidesignspace(vx(1,k),vx(2,k),vy(1,k),vy(2,k),n);
     end
      
     %Determine which pursuers are Voronoi Neighbors to the evader
     V = voronoineighbor([x;y]',n);
    
    %Determine the control line for each pursuer
    Q = controllines(vx2,vy2,x,y,n);
    
    %to be removed later
%     figure(2)
%     hold on
%     plot(x(1),y(1),'b-o')
%     plot(x(2),y(2), 'r-o')
%     plot(x(3),y(3), 'r-*')
%     plot(x(4),y(4),'r-^')
%     xlabel('Horizontal Distance (units)')
%     ylabel('Vertical Distance (units)')
    
    %Take a step in the direction of the midpoint or evader 
    for i = 2:length(x)
       if isempty(Q) == 0
            if ismember(i,Q(:,1)) == 1
                [~,locb] = ismember(i,Q(:,1));
                [x(i),y(i),~] = takestepOptimization(Q(locb,:),stepLength);
                dist(i) = norm([x(i),y(i)]-[x(1),y(1)]);
            else
                F = [i,x(i),y(i),x(1),y(1)];
                [x(i),y(i),~] = takestepOptimization_noboundary(F,stepLength);
                dist(i) = norm([x(i),y(i)]-[x(1),y(1)]);
            end
       else
           F = [i,x(i),y(i),x(1),y(1)];
           [x(i),y(i),~] = takestepOptimization_noboundary(F,stepLength);
            dist(i) = norm([x(i),y(i)]-[x(1),y(1)]);
       end
    end
    
      
        disttoEvader(i) = sqrt((x(i) - x(1))^2 + (y(i) - y(1))^2);
       
        
    
    rc = min(disttoEvader((disttoEvader > 0)));
    disp(rc)
    
    %Compute the distance between the evader and pursuers
    
    x(1) = a1(f);
    y(1) = a2(f);
    
    time = time + timestep;
    f = f+1;
    

  %  figure(2)
  
  %% Plotting
    figure(2)
    hold on
    plot(x(1),y(1),'bo')
    plot(x(2),y(2), 'yo')
    plot(x(3),y(3), 'y*')
    plot(x(4),y(4),'y^')
   % plot(vx2,vy2)
    xlabel('Horizontal Distance (units)')
    ylabel('Vertical Distance (units)')
    xlim([0,n])
    ylim([0,n])
    
    
    %% csv save
    data = [time,x(1),y(1),x(2),y(2),x(3),y(3),x(4),y(4)];
    dlmwrite(fullFileName,data,'-append');
    
end
legend('Evader', 'Pursuer1', 'Pursuer2', 'Pursuer3')

disp('time')

