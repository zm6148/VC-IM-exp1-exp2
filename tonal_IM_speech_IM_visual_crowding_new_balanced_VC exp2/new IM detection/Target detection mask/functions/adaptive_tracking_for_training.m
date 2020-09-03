function  output_handles  = adaptive_tracking_for_training( handles, handles_ex, ax ,hObject)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% find change direction

current = handles.current-1;

if isempty(current)
	change_direction= 12;
else
	%find this m_dis direction change
	tm_differnces=handles.para(:,16);
	%all separations change in direction
	indexes_valley = findpeaks(max(tm_differnces)-tm_differnces);
	
	if length(tm_differnces)>=3
		if current>=13 && isequal(tm_differnces(current-11:current),[-50,-50,-50,-50,-50,-50,-50,-50,-50,-50,-50,-50]')
			change_direction = 12;
		else
			change_direction=length(indexes_valley);
		end
	else
		change_direction=0;
	end
end


% lowest reliable db spl is 5 db
step_change=abs(floor(change_direction/2));

low = -45;
high = 20;

handles.step= 10;
if (handles.para(current,17) == handles.para(current,7))
    if handles.count==2
        
        handles.step= -1*handles.step/(2^step_change);
        handles.count=1;
        
        %change next target loudness based on response%
        tm_dif = handles.para(current,16)+handles.step;
        if tm_dif>=high
            tm_dif=high;
        elseif tm_dif<=-low
            tm_dif=-low;
        else
            tm_dif=handles.para(current,16)+handles.step;
        end
        
        %update next trial separation
        handles.para(current+1,16)=tm_dif;
        %disp(handles.para(current,5));
        guidata(hObject, handles);
        %disp(tm_dif);
    else
        handles.step= handles.step;
        handles.count=handles.count+1;
        
        %update next trial tm loudness diff 
        handles.para(current+1,16)=handles.para(current,16);
        guidata(hObject, handles);
        %disp(tm_dif);
    end
else
    handles.count= 1;
    handles.step= 1*handles.step/(2^step_change);
    %change next mask target loudness diff based on response%
    tm_dif = handles.para(current,6)+handles.step;
    if tm_dif>=25
        tm_dif=25;
    elseif tm_dif<=-50
        tm_dif=-50;
    else
        tm_dif=handles.para(current,16)+handles.step;
    end
    
    %update next trial separation
    handles.para(current+1,16)=tm_dif;
    guidata(hObject, handles);
    disp(tm_dif);
end

% plot data so far
%ax= handles_tracking.axes1;
axes(ax);
for ii=1:current
    if ((handles.para(ii,17)==handles.para(ii,7)))
        color=[0,1,0];
    else
        color=[1,0,0];
    end
    hold on;
    plot(ax, ii, handles.para(ii,16), '-x', 'markersize',10,'color',color)
    ylim(ax,[-50,25])
end

%save results to file
handles.change_direction = change_direction;
output_handles = handles;
%handles_tracking=guidata(handles.tracking);
selected=get(handles_ex.conditions,'value');
filename=handles_ex.listofnames{selected};
para_multi=handles.para;
save([pwd '\conditions\' filename],'para_multi');
%save('handle_data.mat','handles');


end

