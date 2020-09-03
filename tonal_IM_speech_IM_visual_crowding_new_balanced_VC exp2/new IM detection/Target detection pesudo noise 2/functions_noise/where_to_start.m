function [output_current, output_change_direction, output_finished, output_plot_start, output_threshold, all_results] = where_to_start( para_multi )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%   finished 1: yes finshed threshold, 0: not finished thresholding

all_m_dis = unique(para_multi(:,5));
all_m_dis_P = perms(all_m_dis);
whichorder = para_multi(1,18);
all_m_dis_to_use = all_m_dis_P(whichorder,:);

all_results = [];

for ii = 1:length(all_m_dis_to_use)
    
    %current m_dis
    m_dis = all_m_dis_to_use(ii);
    
    
    %select part of the matrix based on current m_dis
    para_at_m_dis_index = para_multi(:,5) == m_dis;
    para_at_m_dis = para_multi(para_at_m_dis_index, :);
    t = find(para_multi(:,5)==m_dis, 1, 'first')-1;
    current=find(para_at_m_dis(:,13)==0, 1, 'first');
    
    if isempty(current)
        change_direction= 12;
    else
        %find this m_dis direction change
        tm_differnces=para_at_m_dis(:,6);
        %all separations change in direction
        indexes_valley = findpeaks(max(tm_differnces)-tm_differnces);
        
        if length(tm_differnces)>=3
            if current>=13 && isequal(tm_differnces(current-11:current),[5,5,5,5,5,5,5,5,5,5,5,5]')
                change_direction = 12;
            else
                change_direction=length(indexes_valley);
            end
        else
            change_direction=0;
        end
    end
    
        
    if change_direction>=12
        % begin new test
        % disp('begin new ocatave separation test');
        finished = 1;
        current=find(para_at_m_dis(:,13)==0, 1, 'first')+t;
    else
        current=find(para_at_m_dis(:,13)==0, 1, 'first')+t;
        finished = 0;
    end
    
    % save all_results
    result = [finished, current, change_direction, t, m_dis];
    all_results = [all_results; result];
end

% first 0 in all_results
unfinished_index = find(all_results(:,1)==0, 1, 'first');
output_current = all_results(unfinished_index, 2);
output_change_direction = all_results(unfinished_index, 3);
output_plot_start = all_results(unfinished_index, 4);

if isequal(all_results(:,1),[1,1,1,1]')
    output_finished = 1;
    % calculate 4 treshold
    threshold = [];
    for ii =  1:length(all_m_dis)
        last_12_index = all_results(ii,2)-11:all_results(ii,2);
        mean_12 = mean(para_multi(last_12_index, 6));
        threshold = [threshold, mean_12];
    end
else
    threshold = [];
    output_finished = 0;
end

output_threshold = threshold;

end