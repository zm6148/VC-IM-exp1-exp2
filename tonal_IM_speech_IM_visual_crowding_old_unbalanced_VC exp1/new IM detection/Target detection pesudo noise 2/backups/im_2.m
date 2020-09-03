
close all;
clc;

%% build all posible combination of parameters
pt_bw = [0.3]; %pattern bandwidth 1
pt_dur = [150]; % pattern duration 2 in ms
t_cf = [1000]; %target center frequence 3
spl=[50]; %desired sound loudness level 4
m_dis= [2,2,2,2]; %mask to target starting distance 5
tm_dif=[0]; %target mask loudness diff (target_loundness-mask_loudness) 6

t_pt= [1 2 3 4 5]; %target pattern 7
m_pt= [1 2 3 4 5]; %mask pattern 8

t_es= [1]; %target element spacing 9
m_es= [1]; %mask element spacing 10

num_tone=[8]; % total number of tones 11

repetition = 3; %number of repetition 12



a = {pt_bw pt_dur t_cf spl m_dis tm_dif t_pt m_pt t_es m_es num_tone repetition};
% para = allcomb(a{:});
[a, b, c, d, e, f, g, h, i, j, k, l] = ndgrid(a{:});
para = [a(:) b(:) c(:) d(:) e(:) f(:) g(:) h(:) i(:) j(:) k(:) l(:)];
para(para(:,7)==para(:,8),:)=[];

para_multi = para (ceil((1:repetition*size(para ,1))/repetition), :);%repeat each condition 3 times
para_multi=[para_multi zeros(size(para_multi,1),1)]; %add one colum for response 13
para_multi=[para_multi zeros(size(para_multi,1),1)]; %add one colum for targer phase 14
para_multi=[para_multi zeros(size(para_multi,1),1)]; %add one colum for masker phase 15
para_multi = para_multi(randperm(size(para_multi,1)),:);%shullfle the conditions

%% load user response UI to play sound built according to each para_multi condition
[file,path] = uiputfile('*.mat','Save conditions as','conditions');
disp(file);
disp(path);
save([path file],'para_multi');
im_2_ex;

