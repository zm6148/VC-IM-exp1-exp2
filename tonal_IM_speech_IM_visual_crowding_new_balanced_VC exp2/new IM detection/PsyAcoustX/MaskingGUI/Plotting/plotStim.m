function plotStim(handles,buffer,maskerTargetDelay)
%plot piece-wise stimulus in window

%set(handles.stimPlot, 'Visible', 'on'); 

axes(handles.stimPlot);
set(findall(0,'tag','stimPlot'),'Visible', 'on');
cla(findall(0,'tag','stimPlot'));

Fs=handles.Fs;
masker=handles.masker;
suppressor=handles.suppressor;
preSupDelay=zeros(1,fix(Fs*handles.stimParams.supDelay)); 
precursor=handles.precursor;
target=handles.target;
maskerType=handles.stimParams.maskerType;
hpMasker=handles.hpMasker;
stim=handles.stim;
   


s3=[nan(1,length(buffer)) precursor nan(1,length(stim)-length(precursor)-length(buffer))]; %precursor segment
s4=hpMasker;
s5=[nan(1,length(buffer)+length(preSupDelay)) suppressor nan(1,length(stim)-length(suppressor)-length(preSupDelay)-length(buffer))];

%construct segments to plot----------
if strcmp(maskerType,'simultaneous')
    delayedTarget=[maskerTargetDelay target];
    s2=[zeros(1,length(buffer)+length(precursor)) masker zeros(1,length(buffer))]; %masker segment
    temp=[nan(1,length(buffer)+length(precursor)) delayedTarget]; %stim segment
    s1=[temp nan(1,length(s2)-length(temp))];
else %forward masking (default)
    s1=[nan(1,length(buffer)+length(masker)+length(precursor)+length(maskerTargetDelay)) target nan(1,length(buffer))]; %stim segment
    s1=[s1 nan(1,length(stim)-length(s1))];
    s2=[zeros(1,length(buffer)+length(precursor)) masker zeros(1,length(maskerTargetDelay)) zeros(1,length(target)+length(buffer))]; %masker segment
    s2=[s2 nan(1,length(stim)-length(s2))];
end

totalDur=length(stim)/Fs;
t=linspace(0,totalDur,length(stim));

%normalized plots (i.e., amplitudes do not reflect actual stimulus levels)
h2=plot(1000*t,s2./max(s2),'b');hold on;           %plot masker
h1=plot(1000*t,0.5*s3./max(s3),'color',[1 0.6 0]); %plot precursor
h4=plot(1000*t,0.5*s1./max(s1),'r');               %plot target
h5=plot(1000*t,0.1*s4./max(s4),'m');               %plot hp Masker
h3=plot(1000*t,0.3*s5./max(s5),'g');               %plot supressor
xlabel('Time (ms)');ylabel('Amplitude (a.u.)');
ylim([-3 3]);
axis tight;
set(gca,'yticklabel',{''},'box','off','xminortick','on','tickdir','out')
h=legend([h1 h2 h3 h4 h5],'Pre.','Masker','Supp.','Target','HP masker','orientation','horizontal');set(h,'fontsize',8)







