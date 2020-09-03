clear all;
close all;

%% subjects

keySet =   {'TEZ', 'TFA','TFB', 'TFC','TFD','TFE','TFF','TEY', 'TFH', 'TFK'};
color_code_set={[1 1 0],[0.251 0 0.502],[0 0 1],[0 1 0],[0 1 1],[0.9412 0.4706 0],[0.502 0.251 0], [0.502 0.502 1],[0.502 0 0], [0 0.5 0]}; %,[0.5 0 0.5],[0 0 0.5]};
%color_code_all = containers.Map(keySet,color_code_set);

%% data matrix
%  type in for now, change later

patterson = ...
	[49 40 25 18 % 500
	49 40 25 18  % 1000
	49 40 25 18];    % 2000


all_500_cf = ...
	[50	45	32	14	56	56	34	25
	53	48	33	24	57	58	52	30
	54	48	34	27	54	63	38	30
	53	46	31	21	61	57	57	50
	52	45	33	21	69	69	69	66
	56	48	34	25	62	62	52	59
	53	46	33	23	65	69	67	69
	52	47	30	20	65	63	51	34
	47	40	32	23	59	49	49	24
	47	41	29	18	42	39	31	27];

all_1000_cf = ...
	[56	51	30	26	60	47	34	27
	57	53	34	28	57	63	48	34
	56	51	30	27	60	55	53	38
	52	36	31	25	63	50	50	25
	54	44	29	25	69	68	69	69
	51	37	26	21	51	53	42	25
	53	48	29	23	68	69	69	55
	56	52	37	25	65	69	60	39
	47	42	30	24	63	46	41	27
	54	49	33	22	53	52	49	37];

all_2000_cf = ...
	[60	54	44	35	69	62	49	34
	60	52	41	32	61	66	52	54
	59	53	39	35	64	63	52	44
	59	49	36	31	68	69	68	69
	58	56	42	32	69	68	69	69
	58	51	34	30	61	61	43	41
	59	57	43	36	69	69	67	69
	62	56	45	33	69	66	52	49
	48	45	40	34	52	62	46	36
	57	55	46	39	55	62	60	52];

x1 = ((2^(0.15)-2^(-0.15))/2); %0.3
x2 = ((2^(0.25)-2^(-0.25))/2); %0.5
x3 = ((2^(0.5)-2^(-0.5))/2);   %1
x4 = ((2^(0.75)-2^(-0.75))/2); %1.5

x= [x1, x2, x3, x4];



%% plot individual

% all subject plot
figure;
% nothced noise conditon left 4 columns
subplot(1,2,1);
hold on;
legendInfo = {};

which_cf  = all_2000_cf;


for ii = 1:size(which_cf,1)
	%plot(x, all_500_cf(ii,1:4));
	legendInfo=[legendInfo,keySet{ii}];
	plot(x,which_cf(ii,1:4),'-gs',...
		'LineWidth',2,...
		'MarkerSize',10,...
		'MarkerEdgeColor',color_code_set{ii},...
		'color',color_code_set{ii});
end
ylim([1,70]);
legend(legendInfo,'Location','southwest','Orientation','vertical');

% toanl mask conditon
subplot(1,2,2);
hold on;
for ii = 1:size(which_cf,1)
	plot(x,which_cf(ii,5:8),'-gs',...
		'LineWidth',2,...
		'MarkerSize',10,...
		'MarkerEdgeColor',color_code_set{ii},...
		'color',color_code_set{ii});
end
ylim([1,70]);
title('target threshold with tonal mask');
legend(legendInfo,'Location','southwest','Orientation','vertical');

%% plot average at 500 1000 2000

mean_err = [];

mean_err_500= [];
for ii = 1:size(all_500_cf,2)
	% calculate average and e
	at_each_separation = all_500_cf(:,ii);
	at_each_separation(at_each_separation==0) = [];
	average = mean(at_each_separation);
	error=std(at_each_separation)/sqrt((length(at_each_separation)-1));
	entry = [average, error];
	% firt 4 notched noise
	mean_err_500= [mean_err_500; entry];
end

mean_err_1000= [];
for ii = 1:size(all_1000_cf,2)
	% calculate average and e
	at_each_separation = all_1000_cf(:,ii);
	at_each_separation(at_each_separation==0) = [];
	average = mean(at_each_separation);
	error=std(at_each_separation)/sqrt((length(at_each_separation)-1));
	entry = [average, error];
	% firt 4 notched noise
	mean_err_1000= [mean_err_1000; entry];
end

mean_err_2000= [];
for ii = 1:size(all_2000_cf,2)
	% calculate average and e
	at_each_separation = all_2000_cf(:,ii);
	at_each_separation(at_each_separation==0) = [];
	average = mean(at_each_separation);
	error=std(at_each_separation)/sqrt((length(at_each_separation)-1));
	entry = [average, error];
	% firt 4 notched noise
	mean_err_2000= [mean_err_2000; entry];
end

% correction at 2000 center by substracting 3.8
mean_err_2000_2 = mean_err_2000;
mean_err_2000_2(:,1) = mean_err_2000(:,1)-3.8;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mean_err = cat(3,mean_err_500, mean_err_1000, mean_err_2000_2);

figure; %average across subject plot
color = {[1,0,0], [0,1,0], [0,0,1]};

subplot(1,2,1);
hold on;

plot(x,patterson(1,:),'-gs',...
	'LineWidth',2,...
	'MarkerSize',10,...
	'MarkerEdgeColor',[0 0 0],...
	'color',[0 0 0]);
for ii = 1:size(mean_err,3)
	
	subplot(1,2,1);
	% notched noise from 1 to 4
	mean_err_each = mean_err(:,:,ii);
	average = mean_err_each(1:4,1);
	error = mean_err_each(1:4,2);
	errorbar(x,average,error,'-gs',...
		'LineWidth',2,...
		'MarkerSize',10,...
		'MarkerEdgeColor',color{ii},...
		'color',color{ii});
	hold on;
	ylim([1,70]);
	set(gca,'XTick',x);
	xlabel('delta f/f');
	ylabel('dB SPL');
	legend('patterson data','500cf','1000cf','2000cf','Location','northoutside','Orientation','horizontal');
	
	% tonal mask from 5 to 8
	subplot(1,2,2);
	hold on;
	mean_err_each = mean_err(:,:,ii);
	average = mean_err_each(5:8,1);
	error = mean_err_each(5:8,2);
	errorbar(x,average,error,'-gs',...
		'LineWidth',2,...
		'MarkerSize',10,...
		'MarkerEdgeColor',color{ii},...
		'color',color{ii});
	ylim([1,70]);
	xlabel('delta f/f');
	ylabel('dB SPL');
	set(gca,'XTick',x);
	legend('500cf','1000cf','2000cf','Location','northoutside','Orientation','horizontal');
end

%% do curve fitting

% the x axis
% x= [x1, x2, x3, x4];

% the y axis
% mean_err = cat(3,mean_err_500, mean_err_1000, mean_err_2000_2);
% mean_err(:,1,1) 500;
% mean_err(:,1,2) 1000;
% mean_err(:,1,3) 2000;

figure;
roex = '-(1-r) * p^(-1) * (2 + p * x) * exp(-p * x) + r * x';
color_oreder = ['r', 'g', 'b'];
for ii = 1:3
	
	% noise masker
	y_noise = mean_err(1:4,1,ii);
	
	f = fittype(roex,'dependent',{'y_noise'},'independent',{'x'},...
		'coefficients',{'r','p'});
	
	[c_noise, gof_noise] = fit(x', y_noise, f);
	
	% tonal masker
	y_tone = mean_err(5:8,1,ii);
	
	f = fittype(roex,'dependent',{'y_tone'},'independent',{'x'},...
		'coefficients',{'r','p'});
	
	[c_tone ,gof_tone] = fit(x', y_tone, f);
	
	subplot(1,2,1);
	hold on;
	plot(c_noise,color_oreder(ii));
	
	
	% tonal mask from 5 to 8
	subplot(1,2,2);
	hold on;
	plot(c_tone, color_oreder(ii));
end




