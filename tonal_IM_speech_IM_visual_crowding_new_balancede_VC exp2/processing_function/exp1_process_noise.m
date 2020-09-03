function [exp1_results, tone_detection_threshold] = exp1_process_noise(exp1_data)

para_multi = exp1_data.para_multi;

% all notch width
all_m_dis = unique(para_multi(:,5));

exp1_results = [];

for ii = 1:length(all_m_dis)
    
    %current m_dis
    m_dis = all_m_dis(ii);
    
    %select part of the matrix based on current m_dis
    para_at_m_dis_index = para_multi(:,5) == m_dis;
    para_at_m_dis = para_multi(para_at_m_dis_index, :);
    t = find(para_multi(:,5)==m_dis, 1, 'first')-1;
    current=find(para_at_m_dis(:,13)==0, 1, 'first');
    
    
    last_12_index = current + t -11 : current + t;
    mean_12 = mean(para_multi(last_12_index, 6));
    
    %  notch witdh   threshold
    dummy = [m_dis,  mean_12];
    exp1_results = [exp1_results; dummy];
end

% pure tone detection threshold
tone_current = find(para_multi(:,17) == 0,1,'first');
tm_differnces=para_multi(:,16);
tone_detection_threshold = mean(tm_differnces(tone_current-5 : tone_current));

end








