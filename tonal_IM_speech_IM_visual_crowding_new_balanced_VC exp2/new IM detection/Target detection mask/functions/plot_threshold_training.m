function  plot_threshold_training(para_multi, ax)



current = find(para_multi(:,17) == 0,1,'first');

high = 50;
low = 5;

if (current == size(para_multi,1))
    change_direction= 12;
else
    %find this m_dis direction change
    tm_differnces=para_multi(:,16);
    %all separations change in direction
    indexes_valley = findpeaks(max(tm_differnces)-tm_differnces);
    
    if length(tm_differnces)>=3
        if current>=13 && isequal(tm_differnces(current-12:current-1),[low,low,low,low,low,low,low,low,low,low,low,low]')
            change_direction = 12;
        else
            change_direction=length(indexes_valley);
        end
    else
        change_direction=0;
    end
end

if change_direction >= 12
	
	%h = msgbox('Sensation Threshold done, Do target detection next');

	axes(ax);
	color=[0,0,1];
	plot(ax, para_multi(1:current,16), '-x', 'markersize',10,'color',color)
	
	if current > 6
		mu = mean(tm_differnces(current-5 : current));
		hline = refline([0 mu]);
		hline.Color = 'r';
	end
	
	%ylim(ax,[-25,50])
	
	
	
else
	
	h = msgbox('No Sensation Threshold Yet');
	
end


end
