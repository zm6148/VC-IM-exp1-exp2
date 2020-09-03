function plotRespTrack(trial,levels,resps,thresh, stdThresh)

%--plot repsone track--------------------------------------
figure('name','Response Track');hold on;
set(gcf,'units','norm','Position',[.2 .15 .7 .4]);
x=1:trial;
plot(x(resps==1),levels(resps==1),'gs','markersize',10,'markerfacecolor','g'); %plots correct resps
plot(x(resps==0),levels(resps==0),'rs','markersize',10,'markerfacecolor','r'); %plots incorrect resps
ylimit=ylim;ylim([ylimit(1) max(levels)*1.5]);
xlim([0 trial+1]);ylabel('20*log10(m)');xlabel('Trial #');grid on;
title(['\bf\theta = ' num2str(thresh) ' dB ,  \sigma =' num2str(stdThresh) ' dB'])
set(gca,'LineWidth',0.5,'xtick',0:2:trial);
%----------------------------------------------------------

