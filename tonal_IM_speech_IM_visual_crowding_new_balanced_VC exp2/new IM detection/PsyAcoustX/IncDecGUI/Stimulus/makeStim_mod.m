function [handles  buffer]=makeStim_mod(handles)


FrozenYN=1;
%----read in stored parameters----------------------------------------
sigLevel=handles.stimParams.sigLevel; %dB
fc=handles.stimParams.fc;
fm=handles.stimParams.fm;
dur=handles.stimParams.dur;
ramp=handles.stimParams.ramp;
carrierType=handles.stimParams.carrierType;
noiseBW=handles.stimParams.noiseBW;
M=handles.stimParams.M; %modulation depth
pzshft=pi;

preDur=handles.stimParams.preDur;
preToggle=handles.stimParams.preToggle;
preType='noise';
preRamp=0.00;
preLevel=handles.stimParams.preLevel;
preFreq=4000;

pmToggle=handles.stimParams.pmToggle;
pmCF=handles.stimParams.pmCF;
pmBW=handles.stimParams.pmBW;

%----------------------------------------------------------------------


%create stimulus in pieces----------------------------------------
%precursor----
t_pre=linspace(0,preDur,fix(handles.Fs*preDur));
if strcmp(preType,'noise'); %noise precursor
    if FrozenYN
        randn('state',0);
    else
    end
    
    precursor=randn(1,length(t_pre));
    precursor = fft_rect_filt(precursor,noiseBW(1),noiseBW(2),handles.Fs,0,0) ;%filter spectrally
else %tone
    precursor=sin(2*pi*preFreq*t_pre);  %tone precursor
end
%------------

if preToggle==1 %precursor turned on
    % handles.precursor=[rampstim(scale2db_mod(precursor,preLevel),preRamp*1000,handles.Fs) preMaskerDelay];
    handles.precursor=[rampstim(scale2db_mod(precursor,preLevel,'noise'),preRamp*1000,handles.Fs)];
else
    handles.precursor=zeros(1,length(t_pre)); %turn off precursor
end


buffer=zeros(1,fix(handles.Fs*0.050)); %short buffer before & after stim turns on
t=linspace(0,dur,fix(handles.Fs*dur));

if strcmp(carrierType,'noise')
    
    if FrozenYN
        randn('state',0);
    else
    end
    
    noise= fft_rect_filt(randn(1,length(t)),noiseBW(1),noiseBW(2),handles.Fs,0,0) ;%filter spectrally

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
        sig=[1+M*cos(2*pi*fm*t-pi+pzshft)].*NBnoise;  %modulated noise
        filtered_sig=fft_rect_filt(sig,LP_HighCutOff,HP_LowCutOff,handles.Fs,0,0) ;%filter spectrally
        %sig=NBnoise;
        sig=filtered_sig+notched_noise;
    else
        sig=[1+M*cos(2*pi*fm*t-pi+pzshft)].*noise;  %modulated noise
    end
else %tonal carrier
    sig=[1+M*cos(2*pi*fm*t-pi+pzshft)].*sin(2*pi*fc*t);  %SAM tone
end

%sig=[buffer sig buffer];
handles.modstim=rampstim(scale2db_mod(sig,sigLevel,carrierType),ramp*1000,handles.Fs);
handles.stim=[buffer handles.precursor handles.modstim buffer];

end

