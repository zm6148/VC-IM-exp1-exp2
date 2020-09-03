function plotStim_mod(handles,buffer)
%plot piece-wise stimulus in window

%set(handles.stimPlot, 'Visible', 'on'); 

axes(handles.stimPlot);
set(findall(0,'tag','stimPlot'),'Visible', 'on');
cla(findall(0,'tag','stimPlot'));

Fs=handles.Fs;
fm=handles.stimParams.fm;
fc=handles.stimParams.fc;
stim=handles.stim;
dur=handles.stimParams.dur;

stim=stim./max(stim);
t=linspace(0,dur,Fs*dur);
modulator=max(stim)*[1+0.5*cos(2*pi*t*fm-pi)]./max([1+cos(2*pi*t*fm-pi)]);modulator=[buffer modulator buffer];

totalDur=length(stim)/Fs;
t=0:1/Fs:totalDur-(1/Fs);

%normalized plots (i.e., amplitudes do not reflect actual stimulus levels)
h1=plot(1000*t,stim,'color',[1 0.6 0]);hold on; 
%h2=plot(1000*t,modulator,'r--','linewidth',2);
xlabel('Time (ms)');ylabel('Amplitude (a.u.)');
ylim([-3 3]);
axis tight;
set(gca,'yticklabel',{''},'box','off','xminortick','on','tickdir','out')
%h=legend([h1 h2],'carrier','modulator','orientation','horizontal');set(h,'fontsize',8)







