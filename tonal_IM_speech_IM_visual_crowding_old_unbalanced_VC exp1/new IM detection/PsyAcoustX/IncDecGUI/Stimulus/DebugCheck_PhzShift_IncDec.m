%DebugCheck_PhzShift_IncDec.m

Fs=44100;
sp=1/Fs;
dur=0.2;
t_stim=linspace(0,dur,fix(Fs*dur));
gapCenterLoc=.50+22*2.5000e-04:2.5000e-04/10:0.6;
stimCutoff=2000;

for i=1:length(gapCenterLoc)
    nsamp=length(t_stim);
    startSamp=round(nsamp*gapCente rLoc(i));
    aStartIncDec=sin(2*pi*stimCutoff*t_stim(startSamp));
    SignStartIncDec=sin(2*pi*(2*stimCutoff)*t_stim(startSamp));
    addPIYN=(sign(aStartIncDec)*sign(SignStartIncDec))*-1;
    phz=asin(aStartIncDec)*-1;
    
    if addPIYN==1
        stimFilt=sin(2*pi*stimCutoff*t_stim+(pi-phz));  %tone
    else
        stimFilt=sin(2*pi*stimCutoff*t_stim+phz);  %tone
    end
    
    f1=figure(10);
    plot(t_stim,stimFilt); hold on;
    plot(t_stim,sin(2*pi*stimCutoff*t_stim),'r'); hold on;
    plot([t_stim(startSamp) t_stim(startSamp)],[min(stimFilt) max(stimFilt)],'k--');
    xlim([[-1/stimCutoff 1/stimCutoff]+gapCenterLoc(i)*dur]);
    xlabel('time');
    ylabel('amplitude');
    pause(.250);
    clf;
end