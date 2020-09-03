function plotStim_gap(handles,buffer)
%plot piece-wise stimulus in window

%set(handles.stimPlot, 'Visible', 'on'); 

axes(handles.stimPlot);
set(findall(0,'tag','stimPlot'),'Visible', 'on');
cla(findall(0,'tag','stimPlot'));

Fs=handles.Fs;
stim=handles.stim;
ttldur=length(handles.stim).*(1/handles.Fs);
stim=stim./max(stim);
t=linspace(0,ttldur,Fs*ttldur);

%normalized plots (i.e., amplitudes do not reflect actual stimulus levels)
h1=plot(1000*t,stim,'color',[1 0.6 0]);hold on; 
xlabel('Time (ms)');ylabel('Amplitude (a.u.)');
ylim([-3 3]);
axis tight;
set(gca,'yticklabel',{''},'box','off','xminortick','on','tickdir','out');







