function plotEnvironment(x,y, Angle, XLim, YLim, t)

persistent f
if isempty(f) || ~isvalid(f)
    f = figure(...
        'Toolbar','auto',...
        'NumberTitle','off',...
        'Name','MultiAgent Deep Deterministic Policy Gradients Cooperative Pursuit',...
        'Visible','on'); %,...
        %'MenuBar','none');
    ha = gca(f);
    axis(ha,'equal');
    ha.XLim = [XLim(1) XLim(2)];
    ha.YLim = [YLim(1) YLim(2)];
    ha.Box = 'on';
    xlabel(ha,'X (ft)');
    ylabel(ha,'Y (ft)');
    
    hold(ha,'on');
end

% plot elements
ha = gca(f);
N = numel(x);
for i = 1:N
    if i == 1
        subplot(1,2,1)
        plot(x(i),y(i),'bo')
        xlabel('X (ft)');
        ylabel('Y (ft)');
        xlim([XLim(1) XLim(2)])
        ylim([YLim(1) YLim(2)])
        timestr = sprintf('Time: %0.1f s',t);
        hText = text(5,10,timestr,'Tag','time');
    
        hold on

        subplot(1,2,2)
        plot(t(i),Angle(i),'g.')
        ylabel('Angle (deg)');
        xlabel('time (s)');
        hold on
    else
        subplot(1,2,1)
        delete(hText)
        plot(x(i),y(i),'ro')
        hText = text(5,10,timestr,'Tag','time');
    end
end

% Display time string
% timestr = sprintf('Time: %0.1f s',t);
% time = findobj(ha,'Tag','time');
% if isempty(time)
%     text(ha,5,10,timestr,'Tag','time');
% else
%     time.String = timestr;
% end
% 
% end