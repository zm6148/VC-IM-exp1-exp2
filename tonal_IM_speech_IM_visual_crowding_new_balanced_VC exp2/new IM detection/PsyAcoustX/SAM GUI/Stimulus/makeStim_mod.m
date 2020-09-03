function [handles,  buffer]=makeStim_mod(handles)


FrozenYN=0;
backFringeYN=1;
%----read in stored parameters----------------------------------------
sigLevel=handles.stimParams.sigLevel; %dB
fc=handles.stimParams.fc;
fm=handles.stimParams.fm;
dur=handles.stimParams.dur;
ramp=handles.stimParams.ramp*1000;
carrierType=handles.stimParams.carrierType;
noiseBW=handles.stimParams.noiseBW;
M=handles.stimParams.M; %modulation depth
pzshft=pi;
ttldur=dur+2*(ramp/1000);
nptsSig=fix(ttldur/(1/handles.Fs));

preDur=handles.stimParams.preDur;
preToggle=handles.stimParams.preToggle;
preLevel=handles.stimParams.preLevel;
preDel=handles.stimParams.preDel;
preType=handles.stimParams.preType;
preFreq=4000;
preRamp=handles.stimParams.preRamp*1000;

pmToggle=handles.stimParams.pmToggle;
pmCF=handles.stimParams.pmCF;
pmBW=handles.stimParams.pmBW;

hpMaskerToggle=handles.stimParams.hpMaskerToggle;
hpMaskerLevel=handles.stimParams.hpMaskerLevel;
hpMaskerRamp=ramp;
hpBW=handles.stimParams.hpCuttoff;

%----------------------------------------------------------------------

buffer=zeros(1,fix(handles.Fs*0.050)); %short buffer before & after stim turns on

%create stimulus in pieces----------------------------------------
%precursor----
t_pre=linspace(0,preDur,fix(handles.Fs*preDur));
if strcmp(preType,'Tone at Probe Hz'); %tone precursor
    precursor=sin(2*pi*preFreq*t_pre);  %noise precursor
else %noise
    if FrozenYN
        randn('state',0);
    else
    end
    
    a_stim=randn(1,length(t_pre));
    switch preType
        case 'BBN/NBN'
            [stimFilt, LNN_stim]=makeLNN_gap(a_stim,handles.stimParams.precursorCutoffs(1:2),handles.Fs);
        otherwise % notched noise
            [stimFilt1, LNN_stim1]=makeLNN_gap(a_stim,handles.stimParams.precursorCutoffs(1:2),handles.Fs);
            [stimFilt2, LNN_stim2]=makeLNN_gap(a_stim,handles.stimParams.precursorCutoffs(3:4),handles.Fs);
            
            % correct for differences in spectrum level
            BW1=handles.stimParams.precursorCutoffs(2)-handles.stimParams.precursorCutoffs(1);
            BW2=handles.stimParams.precursorCutoffs(4)-handles.stimParams.precursorCutoffs(3);
            BWdiff=BW2/BW1;
            stim2Offset=10^((10*(log10(BWdiff)))/20);
            stimFilt2=stimFilt2.*stim2Offset;
            LNN_stim2=LNN_stim2.*stim2Offset;
            
            % add the bands of noise together
            stimFilt=stimFilt1+stimFilt2;
            LNN_stim=LNN_stim1+LNN_stim2;
            
            % scale to rms = 1;
            stimFilt=stimFilt./rms(stimFilt);
            LNN_stim=LNN_stim./rms(LNN_stim);
    end
    
    
    if handles.stimParams.precursorLNNToggle
        precursor = LNN_stim;
    else
        precursor = stimFilt;
    end
end
%------------

if preToggle==1 %precursor turned on
    % handles.precursor=[rampstim(scale2db_mod(precursor,preLevel),preRamp/1000,handles.Fs) preMaskerDelay];
    handles.precursor=[rampstim(scale2db_mod(precursor,preLevel,handles.phones,handles.Fs),preRamp,handles.Fs)];
    preDelBuff=zeros(1,round(preDel./(1/handles.Fs)));
else
    handles.precursor=zeros(1,length(t_pre)); %turn off precursor
    handles.preDel=0;
    preDelBuff=[];
end

%--highpass masker to mimimize off-frequency listening-----
if hpMaskerToggle==1
    % hpMasker=randn(1,nptsSig+length(buffer));  %BBN
    
    if backFringeYN
        fringeLenRESig=2;
        hpMasker=randn(1,nptsSig.*fringeLenRESig);  %BBN
        sigBackFringe=zeros(1,nptsSig.*fringeLenRESig-nptsSig);
    else
        hpMasker=randn(1,nptsSig);  %BBN
    end
    hpMasker_Low = fft_rect_filt(hpMasker,hpBW(1),hpBW(2),handles.Fs,0,0);
    hpMasker_High = fft_rect_filt(hpMasker,hpBW(3),hpBW(4),handles.Fs,0,0);
    
    % correct for differences in spectrum level
    hpBW1=hpBW(2)-hpBW(1);
    hpBW2=hpBW(4)-hpBW(3);
    hpBWdiff=hpBW2/hpBW1;
    stim2Offset=10^((10*(log10(hpBWdiff)))/20);
    hpMasker_High=hpMasker_High.*stim2Offset;
    
    % add the bands of noise together
    hpMasker_Sum = hpMasker_Low+hpMasker_High;
    
    % scale to rms = 1;
    hpMasker_Sum=hpMasker_Sum./rms(hpMasker_Sum);
    handles.hpMasker=rampstim(scale2db_mod(hpMasker_Sum,hpMaskerLevel,handles.phones,handles.Fs),hpMaskerRamp,handles.Fs); %ms ramping
    %handles.stim = handles.stim + handles.hpMasker;
else
    %     handles.hpMasker=zeros(1,length(handles.stim));
    %     %handles.stim = handles.stim + handles.hpMasker;
end
%-------------------------------------------------------------
t=linspace(0,ttldur,fix(handles.Fs*ttldur));
onrampsamp=fix(handles.Fs*(ramp/1000));
offrampsamp=length(t)-onrampsamp;
lastmodsamp=(offrampsamp-onrampsamp)+1;

if strcmp(carrierType,'noise')
    
    if FrozenYN
        randn('state',0);
    else
    end
    
    % [NZ, LNN]= fft_rect_filt(randn(1,length(t)),noiseBW(1),noiseBW(2),handles.Fs,0,0) ;%filter spectrally
    [NZ, LNN] = makeLNN_gap(randn(1,length(t)),noiseBW,handles.Fs);
    if handles.stimParams.carrierLNNToggle
        noise=LNN;
    else
        noise=NZ;
    end
    
    if pmToggle==1
        
        % setup parameters to insert a notch in the noise
        % define cutoff frequencies for HP and LP noise
        HP_HighCutOff=noiseBW(2);
        HP_LowCutOff=pmCF+.5*pmBW;
        LP_HighCutOff=pmCF-.5*pmBW;
        LP_LowCutOff=noiseBW(1);
        Npts=length(noise);
        
        % highpass band
        ScaledHighCutOff=round((HP_HighCutOff/handles.Fs)*Npts);
        ScaledLowCutOff=round((HP_LowCutOff/handles.Fs)*Npts);
        MirrorHighCutOff=Npts-ScaledLowCutOff;
        MirrorLowCutOff=Npts-ScaledHighCutOff;
        X_HP=fft(noise);
        Y_HP=zeros(size(X_HP));
        Y_HP(:,ScaledLowCutOff:ScaledHighCutOff)=X_HP(:,ScaledLowCutOff:ScaledHighCutOff);
        Y_HP(:,MirrorLowCutOff:MirrorHighCutOff)=X_HP(:,MirrorLowCutOff:MirrorHighCutOff);
        % lowpass band
        ScaledHighCutOff=round((LP_HighCutOff/handles.Fs)*Npts);
        ScaledLowCutOff=round((LP_LowCutOff/handles.Fs)*Npts);
        MirrorHighCutOff=Npts-ScaledLowCutOff;
        MirrorLowCutOff=Npts-ScaledHighCutOff;
        X_LP=fft(noise);
        Y_LP=zeros(size(X_LP));
        Y_LP(:,ScaledLowCutOff:ScaledHighCutOff)=X_LP(:,ScaledLowCutOff:ScaledHighCutOff);
        Y_LP(:,MirrorLowCutOff:MirrorHighCutOff)=X_LP(:,MirrorLowCutOff:MirrorHighCutOff);
        Z=real(ifft(Y_HP+Y_LP));
        %  Z=Z./(mean(sqrt(mean(Z.^2))));
        notched_noise=2*Z;
        
        if FrozenYN
            randn('state',0);
        else
        end
        
        NBnoise = fft_rect_filt(randn(1,length(t)),LP_HighCutOff,HP_LowCutOff,handles.Fs,0,0) ;%filter spectrally
        modsig=[1+M*cos(2*pi*fm*t(1:lastmodsamp)-pi+pzshft)].*NBnoise(onrampsamp:offrampsamp);  %modulated noise
        sig=(1+M).*NBnoise;
        sig(onrampsamp:offrampsamp)=modsig;
        filtered_sig=fft_rect_filt(sig,LP_HighCutOff,HP_LowCutOff,handles.Fs,0,0) ;%filter spectrally
        %sig=NBnoise;
        sig=filtered_sig+notched_noise;
    else
        % only modulation portion outside of ramps
        
        modsig=[1+M*cos(2*pi*fm*t(1:lastmodsamp)-pi+pzshft)].*noise(onrampsamp:offrampsamp);  %modulated noise
        sig=(1+M).*noise;
        sig(onrampsamp:offrampsamp)=modsig;
    end
else %tonal carrier
    modsig=[1+M*cos(2*pi*fm*t(1:lastmodsamp)-pi+pzshft)].*sin(2*pi*fc*t(onrampsamp:offrampsamp));  %SAM tone
    sig=(1+M).*sin(2*pi*fc*t);
    sig(onrampsamp:offrampsamp)=modsig;
end

%sig=[buffer sig buffer];
handles.modstim=rampstim(scale2db_mod(sig,sigLevel,handles.phones,handles.Fs),ramp,handles.Fs);

if hpMaskerToggle
    if backFringeYN
        handles.modstim=[handles.modstim sigBackFringe];
    else
    end
    
    stimPlusHP=[handles.modstim]+handles.hpMasker;
else
    stimPlusHP=[handles.modstim];
end

handles.stim=[buffer handles.precursor preDelBuff stimPlusHP buffer];

end

