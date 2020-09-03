function  plot_threshold(handles, para_multi, all_results)

all_ax = [handles.axes2, handles.axes5, handles.axes6, handles.axes7];
all_text = [handles.t_03, handles.t_05, handles.t_1, handles.t_2];

for jj = 1: length(all_ax)
    
	m_dis = all_results(jj,5);
	switch m_dis
		case 0.3
			all_ax = handles.axes2;
			all_text = handles.t_03;
			color = 'b';
		case 0.5
			all_ax = handles.axes5;
			all_text = handles.t_05;
			color = 'g';
		case 1
			all_ax = handles.axes6;
			all_text = handles.t_1;
			color = 'r';
		case 1.5
			all_ax = handles.axes7;
			all_text = handles.t_2;
			color = 'y';
	end
    axes(all_ax);
    %select part of the matrix based on current m_dis
    
    if all_results(jj,1)==1
        
        for ii= all_results(jj,4)+1 : all_results(jj,2)
            if ((para_multi(ii,7)==para_multi(ii,13)))
                color=[0,1,0];
            else
                color=[1,0,0];
            end
            plot(all_ax, ii-all_results(jj,4),  para_multi(ii,6), '-x', 'markersize',10,'color',color)
            ylim(all_ax,[5,70])
            hold on;
        end
        
        last_12_index = all_results(jj,2)-11:all_results(jj,2);
        mean_12 = mean(para_multi(last_12_index, 6));%-para_multi(last_12_index, 4));
        
        hline = refline([0 mean_12]);
        hline.Color = color;
        
        set(all_text, 'String', ['Threshold is ', num2str(mean_12)]);
    else
        
        set(all_text, 'String', 'No Threshold Yet');
    end
end



end
