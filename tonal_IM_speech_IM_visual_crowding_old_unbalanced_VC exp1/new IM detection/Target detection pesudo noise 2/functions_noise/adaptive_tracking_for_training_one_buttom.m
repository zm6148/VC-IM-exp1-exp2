function  output_handles  = adaptive_tracking_for_training_one_buttom( i, handles, handles_ex, ax ,hObject, how_to_change)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% find change direction

current = i;
high = 50;
low = 5;

if (current == size(handles.para,1))
    change_direction= 12;
else
    %find this m_dis direction change
    tm_differnces=handles.para(:,16);
    %all separations change in direction
    indexes_valley = findpeaks(max(tm_differnces)-tm_differnces);
    
    if length(tm_differnces)>=3
        if current>=13 && isequal(tm_differnces(current-11:current),[low,low,low,low,low,low,low,low,low,low,low,low]')
            change_direction = 12;
        else
            change_direction=length(indexes_valley);
        end
    else
        change_direction=0;
    end
end

%disp(change_direction);

%step_change=abs(floor(change_direction/2));

handles.step= 5;
if (how_to_change == 1)
    
    
    handles.step= -1*handles.step;
%     handles.count=1;
    
    %change next target loudness based on response%
    tm_dif = handles.para(current,16)+handles.step;
    if tm_dif>=high
        tm_dif=high;
    elseif tm_dif<=low
        tm_dif=low;
    else
        tm_dif=handles.para(current,16)+handles.step;
    end
    
    %update next trial separation
    handles.para(current+1,16)=tm_dif;
    %disp(handles.para(current,5));
    guidata(hObject, handles);
    %disp(tm_dif);
else
%     handles.count= 1;
    handles.step= 2*handles.step;
    %change next mask target loudness diff based on response%
    tm_dif = handles.para(current,16)+handles.step;
    if tm_dif>=high
        tm_dif=high;
    elseif tm_dif<=low
        tm_dif=low;
    else
        tm_dif=handles.para(current,16)+handles.step;
    end
    
    %update next trial separation
    handles.para(current+1,16)=tm_dif;
    guidata(hObject, handles);
    %disp(tm_dif);
end

% plot data so far
%ax= handles_tracking.axes1;

axes(ax);
color=[0,0,1];
plot(ax, handles.para(1:current,16), '-x', 'markersize',10,'color',color)

if current > 6
	mu = mean(tm_differnces(current-5 : current));
	hline = refline([0 mu]);
	hline.Color = 'r';
end

ylim(ax,[low,high])

%save results to file
handles.change_direction = change_direction;
output_handles = handles;
%handles_tracking=guidata(handles.tracking);
selected=get(handles_ex.conditions,'value');
filename=handles_ex.listofnames{selected};
para_multi=handles.para;
save([pwd '\conditions\' filename],'para_multi');
%save('handle_data.mat','handles');

guidata(hObject, handles);
end

