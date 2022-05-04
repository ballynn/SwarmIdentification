classdef Environment_MovingEvader < rl.env.MATLABEnvironment
    % ENVIRONMENT simulates a game in MATLAB.
    
    % Copyright 2021, The MathWorks Inc.
    
    %% Properties (set properties' attributes accordingly)
    properties
        % X Limit for Design Space
        XLim = [0 10]
        
        % Y Limit for Design Space
        YLim = [0 10]
        maxangle_timestep = 3;
        
        %Starting Agent Position
        Pursuer1 = 10*rand(1,2);
        Pursuer2 = 10*rand(1,2);
        Pursuer3 = 10*rand(1,2);
        Evader = 10*rand(1,2);
       
        Rc = 0.3;
               
        % Sample time
        Ts = 0.01;
        
        %Final Possible Time
        T_final = 1000;
        
        %Initial Time
        T = 0;
        
        %Step Length
        StepLength = 0.1;
        
        %InitialEvaderpath
        DegA_0 = 0;
        i = 1;
        
        %Initialize System State
        State1 = [10*rand(1,1) 10*rand(1,1) 10*rand(1,1) 10*rand(1,1) 0 0 0 0 0]'
        State2 = [10*rand(1,1) 10*rand(1,1) 10*rand(1,1) 10*rand(1,1) 0 0 0 0 0]'
        State3 = [10*rand(1,1) 10*rand(1,1) 10*rand(1,1) 10*rand(1,1) 0 0 0 0 0]'
    end
    
    properties (Access = private, Transient)
        % Visualizer object for the game
        Visualizer = []
    end
    
    properties(Access = protected)
        % Initialize internal flag to indicate episode termination
        IsDone = false        
    end

    %% Necessary Methods
methods              
    function this = Environment_MovingEvader()
            % Initialize Observation settings - 3 pursuers
            ObservationInfo(1) = rlNumericSpec([9 1],'LowerLimit',-10,'UpperLimit',10);
            ObservationInfo(1).Name = 'State1';
            ObservationInfo(1).Description = 'Evader_x, Evader_y, Pursuer1_x, Pursuer1_y, Angle1Prev, DistEvaderPursuer1, DistEvaderPursuer2, DistEvaderPursuer3, Time';
            
            ObservationInfo(2) = rlNumericSpec([9 1],'LowerLimit',-10,'UpperLimit',10);
            ObservationInfo(2).Name = 'State2';
            ObservationInfo(2).Description = 'Evader_x, Evader_y, Pursuer2_x, Pursuer2_y, Angle2Prev, DistEvaderPursuer1, DistEvaderPursuer2, DistEvaderPursuer3, Time';
            
            ObservationInfo(3) = rlNumericSpec([9 1],'LowerLimit',-10,'UpperLimit',10);
            ObservationInfo(3).Name = 'State3';
            ObservationInfo(3).Description = 'Evader_x, Evader_y, Pursuer3_x, Pursuer3_y, Angle3Prev, DistEvaderPursuer1, DistEvaderPursuer2, DistEvaderPursuer3, Time';
            
            % Initialize Action settings - 3 pursuers
            ActionInfo(1) = rlNumericSpec([1 1],'LowerLimit',-3,'UpperLimit',3);
            ActionInfo(1).Name = 'Action1';
            ActionInfo(1).Description = 'Angle1';
            
            ActionInfo(2) = rlNumericSpec([1 1],'LowerLimit',-3,'UpperLimit',3);
            ActionInfo(2).Name = 'Action2';
            ActionInfo(2).Description = 'Angle2';
            
            ActionInfo(3) = rlNumericSpec([1 1],'LowerLimit',-3,'UpperLimit',3);
            ActionInfo(3).Name = 'Action3';
            ActionInfo(3).Description = 'Angle3';
           
            % The following line implements built-in functions of RL env
            this = this@rl.env.MATLABEnvironment(ObservationInfo,ActionInfo);
        end
        
        function [Observation1, Observation2, Observation3, Reward1, Reward2, Reward3, isDone, LoggedSignals] = step(this, Action1, Action2, Action3)
            % Apply system dynamics and simulates the environment with the 
            % given action for one step.
            this.IsDone = false;
            this.i = this.i+1;
            LoggedSignals = [];          
            
            % Unpack state vector
            Evader_x = this.State1(1);
            Evader_y = this.State1(2);
            Pursuer1x = this.State1(3);
            Pursuer1y = this.State1(4);
            Pursuer2x = this.State2(3);
            Pursuer2y = this.State2(4);
            Pursuer3x = this.State3(3);
            Pursuer3y = this.State3(4);
            Angle01 = this.State1(8);
            Angle02 = this.State2(8);
            Angle03 = this.State3(8);
            AngleE = this.State1(9);
            
            Angle1 = Action1(1);
            Angle2 = Action2(1);
            Angle3 = Action3(1);
            
            
            %% Dynamics of Points - Update States
            %Compute the max distance away from evader
            distmax1 = sqrt((Evader_x - this.XLim(1))^2 + (Evader_y - this.YLim(1))^2);
            distmax2 = sqrt((Evader_x - this.XLim(1))^2 + (Evader_y - this.YLim(2))^2);
            distmax3 = sqrt((Evader_x - this.XLim(2))^2 + (Evader_y - this.YLim(1))^2);
            distmax4 = sqrt((Evader_x - this.XLim(2))^2 + (Evader_y - this.YLim(2))^2);

            Distmax = max([distmax1, distmax2, distmax3, distmax4]);
            % Compute the next point assuming no angle change
            
            %compute the next point assuming no angle change
            Pursuer1x_temp = Pursuer1x + this.StepLength*cosd(Angle01);
            Pursuer1y_temp = Pursuer1y + this.StepLength*sind(Angle01);
            
            Pursuer2x_temp = Pursuer2x + this.StepLength*cosd(Angle02);
            Pursuer2y_temp = Pursuer2y + this.StepLength*sind(Angle02);
            
            Pursuer3x_temp = Pursuer3x + this.StepLength*cosd(Angle03);
            Pursuer3y_temp = Pursuer3y + this.StepLength*sind(Angle03);
            
           
            %Compute the rotated pursuer point
            temp = [cosd(wrapTo360(Angle01 + Angle1)), -sind(wrapTo360(Angle01 + Angle1)); sind(wrapTo360(Angle01 + Angle1)), cosd(wrapTo360(Angle01 + Angle1))]*[(Pursuer1x_temp - Pursuer1x);(Pursuer1y_temp - Pursuer1y)] + [Pursuer1x; Pursuer1y];
            temp1 = [cosd(wrapTo360(Angle02 + Angle2)), -sind(wrapTo360(Angle02 + Angle2)); sind(wrapTo360(Angle02 + Angle2)), cosd(wrapTo360(Angle02 + Angle2))]*[(Pursuer2x_temp - Pursuer2x);(Pursuer2y_temp - Pursuer2y)] + [Pursuer2x; Pursuer2y];
            temp2 = [cosd(wrapTo360(Angle03 + Angle3)), -sind(wrapTo360(Angle03 + Angle3)); sind(wrapTo360(Angle03 + Angle3)), cosd(wrapTo360(Angle03 + Angle3))]*[(Pursuer3x_temp - Pursuer3x);(Pursuer3y_temp - Pursuer3y)] + [Pursuer3x; Pursuer3y];
          
            
             %Distance computation for Reward
            Distance1 = sqrt((Evader_x - temp(1))^2 + (Evader_y - temp(2))^2);
            Distance2 = sqrt((Evader_x - temp1(1))^2 + (Evader_y - temp1(2))^2);
            Distance3 = sqrt((Evader_x - temp2(1))^2 + (Evader_y - temp2(2))^2);

            %Reward Counter Initialization
            RewardCounter1 = 0;
            RewardCounter2 = 0;
            RewardCounter3 = 0;

            %Determine if Termination Criteria has been Met
            if Distance1 <= this.Rc
                RewardCounter1 = 10;
                this.IsDone = true;
            elseif Distance2 <= this.Rc
                RewardCounter2 = 10;
                this.IsDone = true;
            elseif Distance3 <= this.Rc
                RewardCounter3 = 10;
                this.IsDone = true;
            end
            
           %If agent has gone outside design space, rotate 90 degrees and issue a Reward debit
            if temp(1) > this.XLim(2) || temp(1) < this.XLim(1) || temp(2) < this.YLim(1) || temp(2) > this.YLim(2)
              %  RewardCounter1 = -1;
                
                %Rotate the point 90 degrees
                Angle1 = 90;
                temp = [cosd(wrapTo360(Angle01 + Angle1)), -sind(wrapTo360(Angle01 + Angle1)); sind(wrapTo360(Angle01 + Angle1)), cosd(wrapTo360(Angle01 + Angle1))]*[(Pursuer1x_temp - Pursuer1x);(Pursuer1y_temp - Pursuer1y)] + [Pursuer1x; Pursuer1y];    
                this.IsDone = false;

            elseif temp1(1) > this.XLim(2) || temp1(1) < this.XLim(1) || temp1(2) < this.YLim(1) || temp1(2) > this.YLim(2)
              %  RewardCounter2 = -1;
                
                %Rotate the point 90 degrees
                Angle2 = 90;
                temp1 = [cosd(wrapTo360(Angle02 + Angle2)), -sind(wrapTo360(Angle02 + Angle2)); sind(wrapTo360(Angle02 + Angle2)), cosd(wrapTo360(Angle02 + Angle2))]*[(Pursuer2x_temp - Pursuer2x);(Pursuer2y_temp - Pursuer2y)] + [Pursuer2x; Pursuer2y];
                this.IsDone = false;
            
            elseif temp2(1) > this.XLim(2) || temp2(1) < this.XLim(1) || temp2(2) < this.YLim(1) || temp2(2) > this.YLim(2)
                %RewardCounter3 = -1;
                
                %Rotate the point 90 degrees
                Angle3 = 90;
                temp2 = [cosd(wrapTo360(Angle03 + Angle3)), -sind(wrapTo360(Angle03 + Angle3)); sind(wrapTo360(Angle03 + Angle3)), cosd(wrapTo360(Angle03 + Angle3))]*[(Pursuer3x_temp - Pursuer3x);(Pursuer3y_temp - Pursuer3y)] + [Pursuer3x; Pursuer3y];
                this.IsDone = false;
            
            else
               % this.IsDone = false;
            end


            Distance1 = sqrt((Evader_x - temp(1))^2 + (Evader_y - temp(2))^2);
            Distance2 = sqrt((Evader_x - temp1(1))^2 + (Evader_y - temp1(2))^2);
            Distance3 = sqrt((Evader_x - temp2(1))^2 + (Evader_y - temp2(2))^2);

            
            Pursuer1x = temp(1);
            Pursuer1y = temp(2);
            Pursuer2x = temp1(1);
            Pursuer2y = temp1(2);
            Pursuer3x = temp2(1);
            Pursuer3y = temp2(2);
            
            Angle = wrapTo360(Angle01 + Angle1);
            Angle0 = wrapTo360(Angle02 + Angle2);
            Angle00 = wrapTo360(Angle03 + Angle3);
            
          %  Reward1 = -(min([Distance1,Distance2, Distance3]))/Distmax;
          %  Reward2 = -(min([Distance1,Distance2, Distance3]))/Distmax;
          %  Reward3 = -(min([Distance1,Distance2, Distance3]))/Distmax;
            
            Reward1 = -Distance1/Distmax + RewardCounter1;
            Reward2 = -Distance2/Distmax + RewardCounter2;
            Reward3 = -Distance3/Distmax + RewardCounter3;
            
         %   [Evader_x,Evader_y, AngleE] = random_walk([Evader_x, Evader_y],AngleE, this.StepLength, this.maxangle_timestep, this.XLim, this.YLim);
            
            Observation1 = [Evader_x Evader_y Pursuer1x Pursuer1y Distance1 Distance2 Distance3 Angle AngleE];
            Observation2 = [Evader_x Evader_y Pursuer2x Pursuer2y Distance1 Distance2 Distance3 Angle0 AngleE];
            Observation3 = [Evader_x Evader_y Pursuer3x Pursuer3y Distance1 Distance2 Distance3 Angle00 AngleE];
            
            % Update system states
            this.State1 = Observation1;
            this.State2 = Observation2;
            this.State3 = Observation3;
           
            
            % Check terminal condition
            this.IsDone = this.IsDone;

            isDone = this.IsDone;
            
            % (optional) use notifyEnvUpdated to signal that the 
            % environment has been updated (e.g. to update visualization)
            notifyEnvUpdated(this);
        end

        end
 methods       
        function InitialObservation = reset(this)
           % Reset environment to initial state and output initial observation
            this.Pursuer1 = max(this.XLim)*rand(1,2);
            this.Pursuer2 = max(this.XLim)*rand(1,2);
            this.Pursuer3 = max(this.XLim)*rand(1,2);
            this.Evader = max(this.XLim)*rand(1,2);
            
            LoggedSignal.State1 = [this.Evader(1) this.Evader(2) this.Pursuer1(1) this.Pursuer1(2) (sqrt((this.Pursuer1(1) - this.Evader(1))^2 + (this.Pursuer2(2) - this.Evader(2))^2)) (sqrt((this.Pursuer2(1) - this.Evader(1))^2 + (this.Pursuer2(2) - this.Evader(2))^2)) (sqrt((this.Pursuer3(1) - this.Evader(1))^2 + (this.Pursuer3(2) - this.Evader(2))^2)) 0 0]';
            LoggedSignal.State2 = [this.Evader(1) this.Evader(2) this.Pursuer2(1) this.Pursuer2(2) (sqrt((this.Pursuer1(1) - this.Evader(1))^2 + (this.Pursuer2(2) - this.Evader(2))^2)) (sqrt((this.Pursuer2(1) - this.Evader(1))^2 + (this.Pursuer2(2) - this.Evader(2))^2)) (sqrt((this.Pursuer3(1) - this.Evader(1))^2 + (this.Pursuer3(2) - this.Evader(2))^2)) 0 0]';
            LoggedSignal.State3 = [this.Evader(1) this.Evader(2) this.Pursuer3(1) this.Pursuer3(2) (sqrt((this.Pursuer1(1) - this.Evader(1))^2 + (this.Pursuer2(2) - this.Evader(2))^2)) (sqrt((this.Pursuer2(1) - this.Evader(1))^2 + (this.Pursuer2(2) - this.Evader(2))^2)) (sqrt((this.Pursuer3(1) - this.Evader(1))^2 + (this.Pursuer3(2) - this.Evader(2))^2)) 0 0]';
            

            InitialObservation = [LoggedSignal.State1, LoggedSignal.State2, LoggedSignal.State3];
            this.State1 = InitialObservation(:,1);
            this.State2 = InitialObservation(:,2);
            this.State3 = InitialObservation(:,3);
            
            this.i = 1;
            
            % (optional) use notifyEnvUpdated to signal that the 
            % environment has been updated (e.g. to update visualization)
            notifyEnvUpdated(this);
        end
        
        
        end
        
    
         

    %% Optional Methods (set methods' attributes accordingly)
methods               
         
        function varargout = plot(this)
            % (optional) Visualization method
            if isempty(this.Visualizer) || ~isvalid(this.Visualizer)
                this.Visualizer = Visualizer(this);
            else
                bringToFront(this.Visualizer);
            end
            if nargout
                varargout{1} = this.Visualizer;
            end
            % Update the visualization
            envUpdatedCallback(this)
        end

        function [Ax, Ay, degA_0] = random_walk(Evader, degA_0, Steplength, maxangle_timestep, XLim, YLim)
            a = degA_0;

            delta_a = 2*maxangle_timestep*(rand - 0.5);
            disp(delta_a)
            a = a + delta_a;

            disp(a)
            Ax = Evader(1) + Steplength*cosd(a);
            Ay = Evader(2) + Steplength*sind(a);
            
            while Ax < XLim(1) || Ax > XLim(2) || Ay < YLim(1) || Ay > YLim(2)
                delta_a = 2*120*(rand - 0.5);
                a = a + delta_a;
                Ax = Evader(1) + Steplength*cosd(a);
                Ay = Evader(2) + Steplength*sind(a);
            end
            
          end
        
        %% (optional) Properties validation through set methods
        function set.State1(this,State1)
            validateattributes(State1,{'numeric'},{'finite','real','vector','numel',9},'','State1');
            this.State1 = double(State1(:));
            notifyEnvUpdated(this);
        end
        function set.State2(this,State2)
            validateattributes(State2,{'numeric'},{'finite','real','vector','numel',9},'','State2');
            this.State2 = double(State2(:));
            notifyEnvUpdated(this);
        end
        function set.State3(this,State3)
            validateattributes(State3,{'numeric'},{'finite','real','vector','numel',9},'','State3');
            this.State3 = double(State3(:));
            notifyEnvUpdated(this);
        end
        function set.XLim(this,val)
            validateattributes(val,{'numeric'},{'finite','real','vector','numel',2},'','XLim');
            this.XLim = val;
            notifyEnvUpdated(this);
        end
        function set.YLim(this,val)
            validateattributes(val,{'numeric'},{'finite','real','vector','numel',2},'','YLim');
            this.YLim = val;
        end
        function set.maxangle_timestep(this,val)
            validateattributes(val,{'numeric'},{'finite','real','positive','scalar'},'','maxangle_timestep');
            this.maxangle_timestep = val;
        end
        function set.Pursuer1(this,val)
            validateattributes(val,{'numeric'},{'finite','real','positive','vector','numel',2},'','Pursuer1');
            this.Pursuer1 = val;
        end
        function set.Pursuer2(this,val)
            validateattributes(val,{'numeric'},{'finite','real','positive','vector','numel',2},'','Pursuer2');
            this.Pursuer2 = val;
        end
        function set.Pursuer3(this,val)
            validateattributes(val,{'numeric'},{'finite','real','positive','vector','numel',2},'','Pursuer3');
            this.Pursuer3 = val;
        end
        function set.Evader(this,val)
            validateattributes(val,{'numeric'},{'finite','real','positive','vector','numel',2},'','Evader');
            this.Evader = val;
        end
        function set.Ts(this,val)
            validateattributes(val,{'numeric'},{'finite','real','positive','scalar'},'','Ts');
            this.Ts = val;
        end
        function set.i(this,val)
            validateattributes(val,{'numeric'},{'finite','real','positive','scalar'},'','i');
            this.i = val;
        end
        function set.T_final(this,val)
            validateattributes(val,{'numeric'},{'finite','real','positive','scalar'},'','T_final');
            this.T_final = val;
        end
        function set.Rc(this,val)
            validateattributes(val,{'numeric'},{'finite','real','positive','scalar'},'','R_c');
            this.R_c = val;
        end
        function set.T(this,val)
            validateattributes(val,{'numeric'},{'real','finite','scalar'},'','T');
            this.T = val;
        end
        function set.DegA_0(this,val)
            validateattributes(val,{'numeric'},{'real','finite','scalar'},'','degA_0');
            this.DegA_0 = val;
        end
        end
    
    methods (Access = protected)
        % (optional) update visualization everytime the environment is updated 
        % (notifyEnvUpdated is called)
        function envUpdatedCallback(this)
            
        end
    end
end
