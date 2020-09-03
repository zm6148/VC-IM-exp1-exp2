function  output_handles  = adaptive_tracking( handles, handles_tracking, ax ,hObject)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

step_change=abs(floor(handles.change_direction/2));
handles.step= 10;

high = 70;
low = 5;


% correct answer do down in db spl
if (handles.para(handles.current,7)==handles.para(handles.current,13))
    if handles.count==2 % change here for 3 down or 2 down
        
        handles.step= -1*handles.step/(2^step_change);
        handles.count=1;
        
        % change next target mask loudness difference based on response%
        tm_dif = handles.para(handles.current,6)+handles.step;
		
		% change next mask noise loudness based on response%
% 		if tm_dif <= low
% 			m_spl = handles.para(handles.current,4) - handles.step;
% 			if m_spl >= high
% 				m_spl = high;
% 			end
% 		else
% 			m_spl = handles.para(handles.current,4);
% 		end
        
        if tm_dif>=high
            
            tm_dif=high;       
            %update next trial separation
            handles.para(handles.current+1,6)=tm_dif;
            guidata(hObject, handles);
            
        elseif tm_dif<=low
            
            % if target = mask (50) - tm_dif is smaller than 5 db spl
            % increase mask level instead.
            % change the spl column insteas

            %update next trial separation
            handles.para(handles.current+1,6)=low;
            %handles.para(handles.current+1,4)=m_spl;
            %disp(handles.para(handles.current,5));
            guidata(hObject, handles);
            %disp(tm_dif);
            
        else
            
            %update next trial separation
			%handles.para(handles.current+1,4)=m_spl;
            handles.para(handles.current+1,6)=tm_dif;
            %disp(handles.para(handles.current,5));
            guidata(hObject, handles);
            %disp(tm_dif);
            
        end
        
    else
        handles.step= handles.step;
        handles.count=handles.count+1;
        
        %update next trial tm loudness diff
        handles.para(handles.current+1,6)=handles.para(handles.current,6);
        handles.para(handles.current+1,4)=handles.para(handles.current,4);
        guidata(hObject, handles);
        %disp(tm_dif);
    end
    
% wrong answer to up in db spl    
else
    handles.count= 1;
    handles.step= 1*handles.step/(2^step_change);
	
    %change next mask target loudness diff based on response%
    tm_dif = handles.para(handles.current,6)+handles.step;
	
	% change next mask noise loudness based on response%
% 	if tm_dif <= low
% 		m_spl = handles.para(handles.current,4) - handles.step;
% 		if m_spl >= high
% 			m_spl = high;
% 		end
% 	else
% 		m_spl = handles.para(handles.current,4);
% 	end

    
    if tm_dif>=high
        
        tm_dif=high;
        %update next trial separation
        handles.para(handles.current+1,6)=tm_dif;
        guidata(hObject, handles);
        
    elseif tm_dif<=low
        
        % if target = mask (50) - tm_dif is smaller than 5 db spl
        % increase mask level instead.
        % change the spl column insteas
        %update next trial separation
        handles.para(handles.current+1,6)=low;
        %handles.para(handles.current+1,4)=m_spl;
        %disp(handles.para(handles.current,5));
        guidata(hObject, handles);
        %disp(tm_dif);
        
    else
        %handles.para(handles.current+1,4)=m_spl;
        handles.para(handles.current+1,6)=tm_dif;
        %disp(handles.para(handles.current,5));
        guidata(hObject, handles);
        %disp(tm_dif);
        
    end
    
end

% plot data so far
%ax= handles_tracking.axes1;
axes(ax);
for ii=handles.plot_start+1:handles.current
    if ((handles.para(ii,7)==handles.para(ii,13)))
        color=[0,1,0];
    else
        color=[1,0,0];
    end
    hold on;
    plot(ax, ii-handles.plot_start,  handles.para(ii,6), '-x', 'markersize',10,'color',color)
    ylim(ax,[5,70])
end

%save results to file
output_handles = handles;
selected=get(handles_tracking.conditions,'value');
filename=handles_tracking.listofnames{selected};
para_multi=handles.para;
save([pwd '\conditions\' filename],'para_multi');
%save('handle_data.mat','handles');

guidata(hObject, handles);
end

