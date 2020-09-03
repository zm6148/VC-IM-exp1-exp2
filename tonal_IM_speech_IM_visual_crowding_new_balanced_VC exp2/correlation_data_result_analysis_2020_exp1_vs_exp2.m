clear;
close all;
clc

%Roex function
roexfun = @(p,g)(1-p(1))*(1+p(2)*abs(g)).*(exp(-p(2)*abs(g)))+p(1);
%start parameters for search
p0 = [.001 25];%p(1)=r and p(2)=p in Patterson 1982 %[0.001 25 0.5 0.3];%
dg = 0.01;%resolution in delta f/f steps

want_indfigs = 1;
%% subjects

keySet =   {'TMT','TMS','TME','TLZ','TMQ','TMB','TMD','TMV','TMW','TMX','TMO','TMY','TND','TNC','TNE','TNH','TNG','TNI','TNL', 'TNM'};
for ii = 1:length(keySet)
    color_code_set{ii} = rand(1,3);
end

%% data matrix
%  type in for now, change later

patterson = ...
    [49 40 25 18 % 500
    49 40 25 18  % 1000
    49 40 25 18];    % 2000

%% old unbalanced data
dat.T = [57.03125	52.31771	33.98438	26.79688	53.88021	61.27604	57.68229	55.572917
59.73958	58.125	41.51042	28.75	62.13542	63.69792	56.66667	31.067708
53.90625	45.75521	31.19792	26.45833	59.53125	47.23958	37.1875	27.96875
56.66667	52.47396	34.40104	31.14583	63.56771	64.08854	41.58854	26.015625
54.47917	45.46875	30.67708	27.05729	46.92708	50.98958	32.99479	27.1875
55.80729	45.46875	29.94792	28.64583	46.64063	50.15625	42.8125	42.34375
57.70833	54.01042	38.20313	26.90104	61.61458	66.66667	62.36979	55.885417
59.81771	52.70833	35.33854	24.73958	67.08333	69.19271	68.82813	69.921875
55.88542	49.63542	36.71875	30.49479	59.45313	65.91146	46.11979	57.604167
55.46875	49.58333	34.42708	28.85417	54.01042	61.58854	41.04167	34.583333
55.15625	47.8125	31.19792	24.0625	58.02083	59.32292	42.03125	40.15625
51.82292	45.67708	32.73438	26.09375	54.08854	48.61979	41.35417	28.645833
57.34375	50.26042	35.75521	25.36458	44.86979	64.92188	48.17708	69.791667
53.07292	48.54167	34.86979	24.76563	45.57292	58.69792	46.38021	64.53125
54.45313	48.75	35.23438	26.17188	51.77083	68.90625	58.125	69.427083
53.38542	47.29167	28.125	23.80208	56.97917	49.53125	36.58854	23.072917
56.53646	52.39583	37.60417	27.00521	59.24479	54.40104	42.03125	28.125
56.51042	54.08854	34.47917	27.29167	57.65625	69.79167	58.54167	51.223958
57.83854	50.26042	37.39583	27.73438	69.63542	69.21875	69.42708	65.625
52.31771	44.21875	27.65625	16.35417	53.33333	47.13542	48.38542	25.885417];

%% new balanced and new VC
% dat.T = [56.61458	45.78125	29.47917	27.60417	61.45833	62.29167	42.08333	50.625
% 63.125	58.75	39.58333	30	69.94792	69.94792	69.97396	65.755208
% 56.5625	50.52083	32.86458	27.13542	62.13542	66.40625	41.35417	27.5
% 58.90625	45.91146	32.10938	25.20833	53.98438	55.88542	50.15625	35.416667
% 55.13021	45.88542	33.77604	26.77083	59.71354	53.69792	46.43229	58.697917
% 57.03125	47.21354	34.14063	26.53646	58.77604	67.52604	42.10938	26.197917
% 56.14583	51.66667	33.85417	26.51042	54.81771	51.06771	42.96875	28.020833
% 51.61458	48.85417	30.26042	25.88542	65.36458	66.19792	39.6875	22.734375
% 58.90625	51.25	34.32292	25.67708	53.69792	55.23438	49.53125	43.307292
% 48.90625	40.26042	27.39583	24.45313	50.96354	62.31771	44.32292	51.822917
% 55.13021	47.91667	27.78646	25.83333	69.32292	69.40104	58.59375	42.838542
% 51.58854	44.47917	26.48438	23.64583	67.13542	61.77083	54.40104	30.833333
% 52.05729	47.86458	33.56771	23.61979	56.95313	50.88542	38.56771	28.098958
% 56.82292	47.26563	31.14583	27.65625	57.52604	66.51042	49.01042	33.854167
% 50.83333	46.45833	35.3125	25.10417	49.16667	56.06771	40.75521	30.026042
% 57.52604	50.3125	34.16667	22.94271	69.60938	53.59375	37.52604	28.072917
% 56.35417	48.77604	35.46875	25.83333	58.38542	60.23438	45.41667	34.84375
% 54.01042	51.64063	33.59375	24.32292	64.53125	69.63542	69.84375	59.84375
% 56.97917	51.64063	32.39583	25.72917	54.89583	58.67188	46.32813	35.390625
% 58.28125	51.74479	40.02604	31.69271	69.08854	69.94792	57.99479	54.739583];


cf = 1000; which_cf = 1; fh(which_cf) = figure; MSK = {'EM';'IM'};symb = {'o'};clr = colormap;lw=1;
GlasbergMooreERB = 24.7*(4.37*cf*1e-3+1);
df = [0.3 0.5 1 1.5];
for ii = 1 : length(df)
    dat.g(ii) = 0.5*(cf*2^(df(ii)/2)-cf*2^(-df(ii)/2))/cf;
end

for which_SID = 1 : size(dat.T,1)
    for which_masker = 1 : 2
        
        y = dat.T(which_SID,(which_masker-1)*4+1:(which_masker-1)*4+4);
        % also try y = squeeze(patterson(2,:))
        y = y-max(abs(y));
        
        gs = dat.g(1):dg:dat.g(end);
        
        
        
        pp = lsqcurvefit(roexfun,p0,dat.g,y);%,'MaxIterations',1500);
        pu = (pp(2));
        
        ERB(which_SID,which_masker) = 1/11.4770*4*cf/pu;%from the fits we calculate the equivalent rectangular bandwidth
        PUs(which_SID,which_masker) = pu;
        
        fitted_filter = roexfun(pp,gs);
        
        if want_indfigs == 1
            figure(fh(which_cf)); set(gcf,'name',['1000 Hz CF']);
            subplot(1,2,which_masker)
            title(MSK{which_masker})
            hold on
            y = dat.T(which_SID,(which_masker-1)*4+1:(which_masker-1)*4+4);
            
            plot(dat.g,y,symb{1},'color',clr(which_SID*3,:),'markerfacecolor',clr(which_SID*3,:))
            hold on;plot(gs,fitted_filter+max(abs(y)),'color',clr(which_SID*3,:),'linewidth',lw)
            xlabel('\Delta f / cf')
            ylabel('Filter Attenuation [dB]')
            ylim([10, 80])
            axis square
            
          
        end
        
        % try this code by plugging in the Patterson numbers, you'll get
        % ERBHz = 147.0497 Hz 
        gs2 = 0 : 0.001 : 2;
        fitted_filter2 = roexfun(pp,gs2);
        mm = min(fitted_filter2);
        fitted_filter2 = fitted_filter2 - min(fitted_filter2);
        Q20amp = max(fitted_filter2) - 3;
        ind = min(find(abs(fitted_filter2-Q20amp)==min(abs(fitted_filter2-Q20amp))));
        fitted_filter2 = fitted_filter2(1:ind);
        gs2 = gs2(1:ind);
        new_f = [fliplr(fitted_filter2) fitted_filter2(2:end)];
        new_g = [-fliplr(gs2) gs2(2:end)];
        a = trapz(new_g,new_f);
        ERBBW(which_SID,which_masker) = a/max(new_f);
        ERBBWHz(which_SID,which_masker) = cf*a/max(new_f);

    end
end

%% find off ERBs exp1
% for exp2 the off one is number 1 8 13 14 15
% new balanced and new VC
% old unbalanced data
dat.T = [57.03125	52.31771	33.98438	26.79688	53.88021	61.27604	57.68229	55.572917
59.73958	58.125	41.51042	28.75	62.13542	63.69792	56.66667	31.067708
53.90625	45.75521	31.19792	26.45833	59.53125	47.23958	37.1875	27.96875
56.66667	52.47396	34.40104	31.14583	63.56771	64.08854	41.58854	26.015625
54.47917	45.46875	30.67708	27.05729	46.92708	50.98958	32.99479	27.1875
55.80729	45.46875	29.94792	28.64583	46.64063	50.15625	42.8125	42.34375
57.70833	54.01042	38.20313	26.90104	61.61458	66.66667	62.36979	55.885417
59.81771	52.70833	35.33854	24.73958	67.08333	69.19271	68.82813	69.921875
55.88542	49.63542	36.71875	30.49479	59.45313	65.91146	46.11979	57.604167
55.46875	49.58333	34.42708	28.85417	54.01042	61.58854	41.04167	34.583333
55.15625	47.8125	31.19792	24.0625	58.02083	59.32292	42.03125	40.15625
51.82292	45.67708	32.73438	26.09375	54.08854	48.61979	41.35417	28.645833
57.34375	50.26042	35.75521	25.36458	44.86979	64.92188	48.17708	69.791667
53.07292	48.54167	34.86979	24.76563	45.57292	58.69792	46.38021	64.53125
54.45313	48.75	35.23438	26.17188	51.77083	68.90625	58.125	69.427083
53.38542	47.29167	28.125	23.80208	56.97917	49.53125	36.58854	23.072917
56.53646	52.39583	37.60417	27.00521	59.24479	54.40104	42.03125	28.125
56.51042	54.08854	34.47917	27.29167	57.65625	69.79167	58.54167	51.223958
57.83854	50.26042	37.39583	27.73438	69.63542	69.21875	69.42708	65.625
52.31771	44.21875	27.65625	16.35417	53.33333	47.13542	48.38542	25.885417];

dat.T = dat.T([1,8,13,14,15], :);

cf = 1000; which_cf = 1; fh(which_cf) = figure; MSK = {'EM';'IM'};symb = {'o'};clr = colormap;lw=1;
GlasbergMooreERB = 24.7*(4.37*cf*1e-3+1);
df = [0.3 0.5 1 1.5];
for ii = 1 : length(df)
    dat.g(ii) = 0.5*(cf*2^(df(ii)/2)-cf*2^(-df(ii)/2))/cf;
end

for which_SID = 1 : size(dat.T,1)
    for which_masker = 1 : 2
        
        y = dat.T(which_SID,(which_masker-1)*4+1:(which_masker-1)*4+4);
        % also try y = squeeze(patterson(2,:))
        y = y-max(abs(y));
        
        gs = dat.g(1):dg:dat.g(end);
        
        
        
        pp = lsqcurvefit(roexfun,p0,dat.g,y);%,'MaxIterations',1500);
        pu = (pp(2));
        
        ERB(which_SID,which_masker) = 1/11.4770*4*cf/pu;%from the fits we calculate the equivalent rectangular bandwidth
        PUs(which_SID,which_masker) = pu;
        
        fitted_filter = roexfun(pp,gs);
        
        if want_indfigs == 1
            figure(fh(which_cf)); set(gcf,'name',['1000 Hz CF']);
            subplot(1,2,which_masker)
            title(MSK{which_masker})
            hold on
            y = dat.T(which_SID,(which_masker-1)*4+1:(which_masker-1)*4+4);
            
            plot(dat.g,y,symb{1},'color',clr(which_SID*3,:),'markerfacecolor',clr(which_SID*3,:))
            hold on;plot(gs,fitted_filter+max(abs(y)),'color',clr(which_SID*3,:),'linewidth',lw)
            xlabel('\Delta f / cf')
            ylabel('Filter Attenuation [dB]')
            ylim([10, 80])
            axis square
            
          
        end
        
        % try this code by plugging in the Patterson numbers, you'll get
        % ERBHz = 147.0497 Hz 
        gs2 = 0 : 0.001 : 2;
        fitted_filter2 = roexfun(pp,gs2);
        mm = min(fitted_filter2);
        fitted_filter2 = fitted_filter2 - min(fitted_filter2);
        Q20amp = max(fitted_filter2) - 3;
        ind = min(find(abs(fitted_filter2-Q20amp)==min(abs(fitted_filter2-Q20amp))));
        fitted_filter2 = fitted_filter2(1:ind);
        gs2 = gs2(1:ind);
        new_f = [fliplr(fitted_filter2) fitted_filter2(2:end)];
        new_g = [-fliplr(gs2) gs2(2:end)];
        a = trapz(new_g,new_f);
        ERBBW(which_SID,which_masker) = a/max(new_f);
        ERBBWHz(which_SID,which_masker) = cf*a/max(new_f);

    end
end

%% find off ERBs exp2
% for exp2 the off one is number 18
% new balanced and new VC
dat.T = [56.61458	45.78125	29.47917	27.60417	61.45833	62.29167	42.08333	50.625
63.125	58.75	39.58333	30	69.94792	69.94792	69.97396	65.755208
56.5625	50.52083	32.86458	27.13542	62.13542	66.40625	41.35417	27.5
58.90625	45.91146	32.10938	25.20833	53.98438	55.88542	50.15625	35.416667
55.13021	45.88542	33.77604	26.77083	59.71354	53.69792	46.43229	58.697917
57.03125	47.21354	34.14063	26.53646	58.77604	67.52604	42.10938	26.197917
56.14583	51.66667	33.85417	26.51042	54.81771	51.06771	42.96875	28.020833
51.61458	48.85417	30.26042	25.88542	65.36458	66.19792	39.6875	22.734375
58.90625	51.25	34.32292	25.67708	53.69792	55.23438	49.53125	43.307292
48.90625	40.26042	27.39583	24.45313	50.96354	62.31771	44.32292	51.822917
55.13021	47.91667	27.78646	25.83333	69.32292	69.40104	58.59375	42.838542
51.58854	44.47917	26.48438	23.64583	67.13542	61.77083	54.40104	30.833333
52.05729	47.86458	33.56771	23.61979	56.95313	50.88542	38.56771	28.098958
56.82292	47.26563	31.14583	27.65625	57.52604	66.51042	49.01042	33.854167
50.83333	46.45833	35.3125	25.10417	49.16667	56.06771	40.75521	30.026042
57.52604	50.3125	34.16667	22.94271	69.60938	53.59375	37.52604	28.072917
56.35417	48.77604	35.46875	25.83333	58.38542	60.23438	45.41667	34.84375
54.01042	51.64063	33.59375	24.32292	64.53125	69.63542	69.84375	59.84375
56.97917	51.64063	32.39583	25.72917	54.89583	58.67188	46.32813	35.390625
58.28125	51.74479	40.02604	31.69271	69.08854	69.94792	57.99479	54.739583];

dat.T = dat.T(18, :);

cf = 1000; which_cf = 1; fh(which_cf) = figure; MSK = {'EM';'IM'};symb = {'o'};clr = colormap;lw=1;
GlasbergMooreERB = 24.7*(4.37*cf*1e-3+1);
df = [0.3 0.5 1 1.5];
for ii = 1 : length(df)
    dat.g(ii) = 0.5*(cf*2^(df(ii)/2)-cf*2^(-df(ii)/2))/cf;
end

for which_SID = 1 : size(dat.T,1)
    for which_masker = 1 : 2
        
        y = dat.T(which_SID,(which_masker-1)*4+1:(which_masker-1)*4+4);
        % also try y = squeeze(patterson(2,:))
        y = y-max(abs(y));
        
        gs = dat.g(1):dg:dat.g(end);
        
        
        
        pp = lsqcurvefit(roexfun,p0,dat.g,y);%,'MaxIterations',1500);
        pu = (pp(2));
        
        ERB(which_SID,which_masker) = 1/11.4770*4*cf/pu;%from the fits we calculate the equivalent rectangular bandwidth
        PUs(which_SID,which_masker) = pu;
        
        fitted_filter = roexfun(pp,gs);
        
        if want_indfigs == 1
            figure(fh(which_cf)); set(gcf,'name',['1000 Hz CF']);
            subplot(1,2,which_masker)
            title(MSK{which_masker})
            hold on
            y = dat.T(which_SID,(which_masker-1)*4+1:(which_masker-1)*4+4);
            
            plot(dat.g,y,symb{1},'color',clr(which_SID*3,:),'markerfacecolor',clr(which_SID*3,:))
            hold on;plot(gs,fitted_filter+max(abs(y)),'color',clr(which_SID*3,:),'linewidth',lw)
            xlabel('\Delta f / cf')
            ylabel('Filter Attenuation [dB]')
            ylim([10, 80])
            axis square
            
          
        end
        
        % try this code by plugging in the Patterson numbers, you'll get
        % ERBHz = 147.0497 Hz 
        gs2 = 0 : 0.001 : 2;
        fitted_filter2 = roexfun(pp,gs2);
        mm = min(fitted_filter2);
        fitted_filter2 = fitted_filter2 - min(fitted_filter2);
        Q20amp = max(fitted_filter2) - 3;
        ind = min(find(abs(fitted_filter2-Q20amp)==min(abs(fitted_filter2-Q20amp))));
        fitted_filter2 = fitted_filter2(1:ind);
        gs2 = gs2(1:ind);
        new_f = [fliplr(fitted_filter2) fitted_filter2(2:end)];
        new_g = [-fliplr(gs2) gs2(2:end)];
        a = trapz(new_g,new_f);
        ERBBW(which_SID,which_masker) = a/max(new_f);
        ERBBWHz(which_SID,which_masker) = cf*a/max(new_f);

    end
end





