function [handles maskerTargetDelay buffer]=makeStim(handles)

%----read in stored parameters----------------------------------------
targetLevel=handles.stimParams.targetLevel; %dB
targetFreq=handles.stimParams.targetFreq;
targetRamp=handles.stimParams.targetRamp;
targetDur=handles.stimParams.targetDur;

maskerLevel=handles.stimParams.maskerLevel; %dB
maskerRamp=handles.stimParams.maskerRamp;
maskerDur=handles.stimParams.maskerDur;
maskerFreq=handles.stimParams.maskerFreq;
fc=handles.stimParams.maskerCutoffs;
notchToggle=handles.stimParams.notchToggle;
fmask=handles.stimParams.maskerBW;

preDur=handles.stimParams.preDur;
preToggle=handles.stimParams.preToggle;
supToggle=handles.stimParams.supToggle;
supDur=handles.stimParams.supDur;
supRamp=handles.stimParams.supRamp;
supDelay=handles.stimParams.supDelay;
supFreq=handles.stimParams.supFreq;
supLevel=handles.stimParams.supLevel;
preType=handles.stimParams.preType;
preRamp=handles.stimParams.preRamp;
preLevel=handles.stimParams.preLevel;
preFreq=handles.stimParams.preFreq;

targetAlone=handles.stimParams.targetAlone;
hpMaskerToggle=handles.stimParams.hpMaskerToggle;
hpMaskerLevel=handles.stimParams.hpMaskerLevel;
hpMaskerRamp=handles.stimParams.hpMaskerRamp;
hpNtchNrmlz=handles.stimParams.hpMaskerCutoffNrmlz;
hpCutUpper=handles.stimParams.hpCutUpper;

%----------------------------------------------------------------------

%create stimulus in pieces----------------------------------------
%precursor----
t_pre=linspace(0,preDur,fix(handles.Fs*preDur));
if strcmp(preType,'noise'); %noise precursor
    precursor=randn(1,length(t_pre));
    precursor = fft_rect_filt(precursor,fmask(1),fmask(2),handles.Fs,0,0) ;%filter spectrally
else %tone
    precursor=sin(2*pi*preFreq*t_pre);  %tone precursor
end
%------------

%suppressor---------
t_sup=linspace(0,supDur,fix(handles.Fs*supDur));
suppressor=sin(2*pi*supFreq*t_sup);  %tonal suppressor
%------------------

%--create noise or tonal masker------------
t_masker=linspace(0,maskerDur,fix(handles.Fs*maskerDur));
if strcmp(handles.stimParams.maskerSig,'tone');
    masker=sin(2*pi*maskerFreq*t_masker);  %tone masker
else %noise
    masker=randn(1,length(t_masker));  %BB noise masker (default)
    masker = fft_rect_filt(masker,fmask(1),fmask(2),handles.Fs,0,0) ;%filter spectrally
    
    if notchToggle==1 %notched masker
        masker=createNotchedNoise(masker,fc,handles.Fs); %notched noise masker
    end
end
%-------------------------------------------

%target--------------------------------
t_target=linspace(0,targetDur,fix(handles.Fs*targetDur));
target=sin(2*pi*targetFreq*t_target);      %target signal
%--------------------------------------

%combine precursor, masker,suppressor, & target-----------------------------------
buffer=zeros(1,fix(handles.Fs*0.050)); %short buffer before & after stim turns on
maskerTargetDelay=zeros(1,fix(handles.Fs*handles.stimParams.delay));
preMaskerDelay=zeros(1,fix(handles.Fs*handles.stimParams.preDelay)); %delay btw precursor & masker
preSupDelay=zeros(1,fix(handles.Fs*handles.stimParams.supDelay));   %delay from stim onset (after buffer) to start of suppressor

%ramped & scaled to proper level
handles.target=rampstim(scale2db(target,targetLevel,handles.phones,handles.Fs),targetRamp*1000,handles.Fs); %ramp after scaling
handles.masker=rampstim(scale2db(masker,maskerLevel,handles.phones,handles.Fs),maskerRamp*1000,handles.Fs);


if preToggle==1 %precursor turned on
    handles.precursor=[rampstim(scale2db(precursor,preLevel,handles.phones,handles.Fs),preRamp*1000,handles.Fs) preMaskerDelay];
else
    handles.precursor=[]; %turn off precursor
end

if supToggle==1 %suppressor turned on
    handles.suppressor=rampstim(scale2db(suppressor,supLevel,handles.phones,handles.Fs),supRamp*1000,handles.Fs);
else
    handles.suppressor=[]; %turn off suppressor
end

if targetAlone==1 %target alone checked
    handles.masker=[]; %turn off masker
    handles.precursor=[]; %turn off precursor
end


if strcmp(handles.stimParams.maskerType,'simultaneous')
    delayedTarget=[maskerTargetDelay handles.target];
    maskerPlusTarget=handles.masker+[delayedTarget zeros(1,length(handles.masker)-length(delayedTarget))]; %add target to masker after specified delay
    
    delayedSup=[zeros(1,length(buffer)) preSupDelay handles.suppressor];
    
    handles.stim=[buffer handles.precursor maskerPlusTarget buffer];
    handles.stim=handles.stim+[delayedSup zeros(1,length(handles.stim)-length(delayedSup))]; %add suppressor
    
else %forward masking (default)
    handles.stim=[buffer  handles.precursor handles.masker maskerTargetDelay handles.target buffer]; %concatenate noise & target
    
    %delayedSup=[zeros(1,length(buffer)) preSupDelay handles.suppressor];
    delayedSup=[zeros(1,length(buffer)) preSupDelay handles.suppressor];
    handles.stim=handles.stim+[delayedSup zeros(1,length(handles.stim)-length(delayedSup))]; %add suppressor
end
%----------------------------------------------------------

%--highpass masker to mimimize off-frequency listening-----
if (hpMaskerToggle==1) && (targetAlone~=1)
    hpMasker=randn(1,length(handles.stim));  %BBN
    hpMasker = fft_rect_filt(hpMasker,hpNtchNrmlz*targetFreq,hpCutUpper,handles.Fs,0,0) ;%highpass cutoff is 1.2x target frequency
    handles.hpMasker=rampstim(scale2db(hpMasker,hpMaskerLevel,handles.phones,handles.Fs),hpMaskerRamp*1000,handles.Fs); %ms ramping
    %handles.stim = handles.stim + handles.hpMasker;
else
    handles.hpMasker=zeros(1,length(handles.stim));
    %handles.stim = handles.stim + handles.hpMasker;
end
handles.stim = handles.stim + handles.hpMasker;
%-------------------------------------------------------------

end


