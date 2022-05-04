%% Environment Constants
% X Limit for Design Space
    XLim = [0 10];

    % Y Limit for Design Space
    YLim = [0 10];
    maxangle_timestep = 10;

    %Starting Agent Position
    Pursuer1 = 10*rand(1,2);
    Pursuer2 = 10*rand(1,2);
    Pursuer3 = 10*rand(1,2);
    Evader = [1.3607, 6.4931];

    DistR1 = sqrt((Evader(1) - Pursuer1(1))^2 + (Evader(2) - Pursuer1(2))^2);

    %Starting Agent Distance
    Distance1 = sqrt((Evader(1) - Pursuer1(1))^2 + (Evader(2) - Pursuer1(2))^2);
    Distance2 = sqrt((Evader(1) - Pursuer2(1))^2 + (Evader(2) - Pursuer2(2))^2);
    Distance3 = sqrt((Evader(1) - Pursuer3(1))^2 + (Evader(2) - Pursuer3(2))^2);

    Rc = 0.3;

    %Reward Counter
    RewardCounter1 = 0;
    RewardCounter2 = 0;
    RewardCounter3 = 0;

    % Sample time
    Ts = 0.1;

    %Final Possible Time
    T_final = 10;

    %Initial Time
    T = 0;

    %Step Length
    StepLength = 0.1;

    %InitialEvaderpath
    degA_0 = 0;
    i = 1;

    %Initialize System State
    observation1 = [Evader(1) Evader(2) Pursuer1(1) Pursuer1(2) Distance1 Distance2 Distance3 90 0];
    observation2 = [Evader(1) Evader(2) Pursuer2(1) Pursuer2(2) Distance1 Distance2 Distance3 90 0];
    observation3 = [Evader(1) Evader(2) Pursuer3(1) Pursuer3(2) Distance1 Distance2 Distance3 90 0];

    DistC1 = sqrt((Evader(1) - XLim(1))^2 + (Evader(2) - YLim(1))^2);
    DistC2 = sqrt((Evader(1) - XLim(1))^2 + (Evader(2) - YLim(2))^2);
    DistC3 = sqrt((Evader(1) - XLim(2))^2 + (Evader(2) - YLim(1))^2);
    DistC4 = sqrt((Evader(1) - XLim(2))^2 + (Evader(2) - YLim(2))^2);
    
    Distmax = max([DistC1, DistC2, DistC3, DistC4]);