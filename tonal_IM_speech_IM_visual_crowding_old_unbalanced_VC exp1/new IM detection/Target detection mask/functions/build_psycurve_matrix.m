function output_psy_para_multi = build_psycurve_matrix( para_multi, output_threshold )
% build all posible combination of parameters
%pt_bw = [0.3]; %pattern bandwidth 1
pt_bw = para_multi(1,1);%pattern bandwidth in greenwood function 1 cloe to 1/12 octave
pt_dur = para_multi(1,2); % pattern duration 2 in ms

t_cf = para_multi(1,3); %target center frequence 3

spl = para_multi(1,4); %desired sound loudness level 4

all_m_dis = unique(para_multi(:,5));

t_pt = [1 2]; %target pattern 7 1 yes or 2 no there or not there
m_pt = [1 2 3 4 5]; %mask pattern 8

t_es = [1]; %target element spacing 9
m_es = [1]; %mask element spacing 10

num_tone = [8]; % total number of tones 11

repetition = 2; %number of repetition 12

% based on threshold
output_psy_para_multi = [];
for ii = 1:length(output_threshold)
    
    m_dis = all_m_dis(ii); %mask to target starting distance 5
    tm_dif = linspace(output_threshold(ii) - 15, output_threshold(ii) + 15, 5); %target mask loudness diff (target_loundness-mask_loudness) 6
    
    %    1     2      3    4   5     6      7   8     9    10   11       12
    a = {pt_bw pt_dur t_cf spl m_dis tm_dif t_pt m_pt t_es m_es num_tone repetition};
    [a, b, c, d, e, f, g, h, i, j, k, l] = ndgrid(a{:});
    para = [a(:) b(:) c(:) d(:) e(:) f(:) g(:) h(:) i(:) j(:) k(:) l(:)];
    
    psy_para_multi = para (ceil((1:repetition*size(para ,1))/repetition), :);%repeat each condition 2 times
    psy_para_multi=[psy_para_multi zeros(size(psy_para_multi,1),1)]; %add one colum for response 13
    psy_para_multi=[psy_para_multi zeros(size(psy_para_multi,1),1)]; %add one colum for targer phase 14
    psy_para_multi=[psy_para_multi zeros(size(psy_para_multi,1),1)]; %add one colum for masker phase 15
    
    
    output_psy_para_multi = [output_psy_para_multi; psy_para_multi ];
end


output_psy_para_multi = output_psy_para_multi(randperm(size(output_psy_para_multi,1)),:);%shullfle the conditions


end

