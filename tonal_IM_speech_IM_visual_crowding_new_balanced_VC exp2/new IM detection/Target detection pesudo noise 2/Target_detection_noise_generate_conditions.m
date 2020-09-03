function condition_path = Target_detection_noise_generate_conditions(subject_ID)
close all;
clc;

%% subject to change

t_cf = [1000]; % 500 2000%target center frequence 3%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subject_test_order = 3;

%% build all posible combination of parameters
%pt_bw = [0.3]; %pattern bandwidth 1
pt_bw=[0.4];%pattern bandwidth in greenwood function 1 cloe to 1/12 octave
pt_dur = [150]; % pattern duration 2 in ms



spl=[40]; %desired mask or noise sound loudness level fixed at 70 for the mask 4

m_dis= [0.3 0.5 1 1.5]; %mask to target starting distance 5

% inital difference 25 db
tm_dif=[70]; %target target db spl start at 70 db spl 6

t_pt= [1 2]; %target pattern 7 1 yes or 2 no there or not there
m_pt= [1 2 3 4 5]; %mask pattern 8

t_es= [1]; %target element spacing 9
m_es= [1]; %mask element spacing 10

num_tone=[8]; % total number of tones 11

repetition = 20; %number of repetition 12


%    1     2      3    4   5     6      7   8     9    10   11       12
a = {pt_bw pt_dur t_cf spl m_dis tm_dif t_pt m_pt t_es m_es num_tone repetition};
% para = allcomb(a{:});
[a, b, c, d, e, f, g, h, i, j, k, l] = ndgrid(a{:});
para = [a(:) b(:) c(:) d(:) e(:) f(:) g(:) h(:) i(:) j(:) k(:) l(:)];
%para(para(:,7)==para(:,8),:)=[];

para_multi = para (ceil((1:repetition*size(para ,1))/repetition), :);%repeat each condition 3 times
para_multi=[para_multi zeros(size(para_multi,1),1)]; %add one colum for response 13
para_multi=[para_multi zeros(size(para_multi,1),1)]; %add one colum for targer phase 14
para_multi=[para_multi zeros(size(para_multi,1),1)]; %add one colum for masker phase 15
para_multi=[para_multi zeros(size(para_multi,1),1)]; %add one colum for target detection in quite 16 target spl diff
para_multi=[para_multi zeros(size(para_multi,1),1)]; %add one colum for target detection subject response in quite 17
para_multi(:,16) = spl;
para_multi = para_multi(randperm(size(para_multi,1)),:);%shullfle the conditions
[values, order] = sort(para_multi(:,5));
para_multi = para_multi(order,:);
para_multi=[para_multi zeros(size(para_multi,1),1)]; %add one more column for subject trainig order 18
para_multi(:,18) = subject_test_order;

% change the start of each run to be target present
para_multi(1,7) = 1;
para_multi(201,7) = 1;
para_multi(401,7) = 1;
para_multi(601,7) =1;

% change the start of each run to has the loudest target sound level

% change all mask pattern that is flat to be any of the other 4 patterns
% mask pattern 8
for ii = 1:size(para_multi,1)
    if para_multi(ii,8) == 3
        index = randi([1,4],1);
        array = [1,2,4,5];
        para_multi(ii,8) = array(index);
    end
end

% load user response UI to play sound built according to each para_multi condition
% [file,path] = uiputfile('*.mat','Save conditions as','conditions');
% disp(file);
% disp(path);
% save([path file],'para_multi');
path = [pwd, '\conditions\'];
file_name = subject_ID;
save([path, file_name],'para_multi');
%tracking_plot;

condition_path = [path, file_name];

end