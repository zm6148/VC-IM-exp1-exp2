function [ current, all_results ] = where( para_multi )
% for random order adaptive tracking
% all unique m_dis
all_m_dis = unique(para_multi(:,5));

% % find what is the m_dis for this current
% current_m_dis = para_multi(current,5);

% initial all results
all_results = [];


for ii = 1:length(all_m_dis)
	
	%current m_dis
	m_dis = all_m_dis(ii);
	
	%select part of the matrix based on current m_dis
	para_at_m_dis_index = para_multi(:,5) == m_dis;
	para_at_m_dis = para_multi(para_at_m_dis_index, :);
	
	
	
	sub_current=find(para_at_m_dis(:,13)==0, 1, 'first');
	
	if isempty(sub_current)
		change_direction= 12;
	else
		%find this m_dis direction change
		tm_differnces=para_at_m_dis(:,6);
		%all separations change in direction
		indexes_valley = findpeaks(max(tm_differnces)-tm_differnces);
		
		if length(tm_differnces)>=3
			if sub_current>=13 && isequal(tm_differnces(sub_current-11:sub_current),[-25,-25,-25,-25,-25,-25,-25,-25,-25,-25,-25,-25]')
				change_direction = 12;
			else
				change_direction=length(indexes_valley);
			end
		else
			change_direction=0;
		end
	end
	
	
	if change_direction>=12
		% this m_dis finished next
		% disp('begin new ocatave separation test');
		finished = 1;
		last_12_index = sub_current-11:sub_current;
		mean_12 = mean(para_at_m_dis(last_12_index, 6));
		
	else
		% index in the small matrrix is current
		% the row in the small matrix is current
		finished = 0;
		mean_12 = 0;
	end
	
	
	
	
	% index in the small matrrix is sub current
	% the row in the big matrix is current
	row_small = para_at_m_dis(sub_current,:);
	% translate that to row number in big matrix
	[~,current]=ismember(row_small,para_multi,'rows');
	
	result = [finished, current, change_direction, m_dis, mean_12];
	all_results = [all_results; result];
	
end
end

