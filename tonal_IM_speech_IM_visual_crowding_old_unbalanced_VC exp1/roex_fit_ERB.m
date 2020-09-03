clear;
close all;
clc

%% define Roex function
roexfun = @(p,g)(1-p(1))*(1+p(2)*abs(g)).*(exp(-p(2)*abs(g)))+p(1);
%start parameters for search
p0 = [.001 25];%p(1)=r and p(2)=p in Patterson 1982 %[0.001 25 0.5 0.3];%
dg = 0.01;%resolution in delta f/f steps


%% load data matrix from summarized excel file
filename = 'summarized_results_old_unbalanced_VC.xlsx';
dat.T = xlsread(filename, 1, 'B4:I23');

%% fit roex function to tonal IM data
cf = 1000; 
which_cf = 1; 
want_indfigs = 1;
fh(which_cf) = figure; 
MSK = {'EM';'IM'};
symb = {'o'};
clr = colormap;
lw=1;
GlasbergMooreERB = 24.7*(4.37*cf*1e-3+1);
df = [0.3 0.5 1 1.5];
for ii = 1 : length(df)
    dat.g(ii) = 0.5*(cf*2^(df(ii)/2)-cf*2^(-df(ii)/2))/cf;
end

for which_SID = 1 : size(dat.T,1)
    for which_masker = 1 : 2
        
        y = dat.T(which_SID,(which_masker-1)*4+1:(which_masker-1)*4+4);
        y = y-max(abs(y));
        gs = dat.g(1):dg:dat.g(end);
        pp = lsqcurvefit(roexfun,p0,dat.g,y);
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

%% add ERB to summarized results excel sheet
filename = 'summarized_results_old_unbalanced_VC.xlsx';
sheet = 1;
xlRange_data = 'P4';
xlswrite(filename, ERBBWHz, sheet, xlRange_data);









