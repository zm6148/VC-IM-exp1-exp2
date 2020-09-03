%CheckDecrement.m
%Usage: make plots of decrement creation to verify that ramps and levels
%are set correctly.

load('CheckDecrement.mat');
setappdata(0,'caldB',100);
gapDur=[15 15 15 15 15 15]./1000;
prgmMode='listen'; % choose 'listen' or 'checkLevel'
markerLevel=65;
handles.stimParams.bnoiseToggle=0;
handles.stimParams.bnoiseLNNToggle=0;
% handles.stimParams.bnoiseLevel=80;

nsamp=handles.stimParams.dur./(1/handles.Fs);
startSamp=round(nsamp*handles.stimParams.gapCenterLoc);
nsigsamp=round(handles.stimParams.initialGapDur/(1/handles.Fs));
endSamp=startSamp+nsigsamp-1;
innerRampSamps=round((0.002/(1/handles.Fs)*2));
startSamp=round(startSamp+innerRampSamps/2);
endSamp=round(endSamp-innerRampSamps/2);

handles.stimParams.DecrementYN=1;

for i=1:length(markerLevel)
    % initialIncDec=[0:3:markerLevel(i)];
    initialIncDec=15;
    for k=1:length(initialIncDec)
        handles.stimParams.markerLevel=markerLevel(i);
        handles.stimParams.initialIncDec=initialIncDec(k);
        
        switch prgmMode
            case 'listen'
                figure;
                for nstim=1:length(gapDur)
                    handles.stimParams.initialGapDur=gapDur(nstim);
                    [gapStim, refStim, handles]=makeStim_IncDec_CheckDecrement(handles,handles.stimParams.DecrementYN);
                    sound(handles.stim,handles.Fs);
                    pause(1);
                    plot(handles.stim);
                    xlim([17654 19000]);
                    plotStimSpectrogam(handles);
                    xlim([200 600]);
                    waitfor(gcf);
                end
            case 'checkLevel'
                
                if handles.stimParams.DecrementYN
                    decdB=20*log10(rms(refStim(startSamp:endSamp))/rms(gapStim(startSamp:endSamp)));
                else
                    decdB=20*log10(rms(gapStim(startSamp:endSamp))/rms(refStim(startSamp:endSamp)));
                end
                display(['desired decrement = ' num2str(initialIncDec(k)) ', measured decrement = ' num2str(decdB)]);
                
                plot(gapStim,'r','LineWidth',3); hold on;
                plot(refStim);
                xlim([1 endSamp+450])
                waitfor(gcf);
            otherwise
                error('program mode not recognized...');
        end
    end
    
end