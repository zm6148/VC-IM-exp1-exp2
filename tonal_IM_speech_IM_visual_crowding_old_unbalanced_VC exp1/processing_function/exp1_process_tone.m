function exp1_results= exp1_process_tone(exp1_data)

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
end








