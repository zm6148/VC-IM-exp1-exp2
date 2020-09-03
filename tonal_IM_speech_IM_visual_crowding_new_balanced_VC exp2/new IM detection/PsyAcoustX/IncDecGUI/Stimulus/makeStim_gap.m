function [handles,  buffer]=makeStim_gap(handles,makeGapYN)

%----read in stored parameters----------------------------------------
%     'markerLevel'
%     'dur' --> marker duration
%     'ramp' --> marker ramp
%     'markerGapRamp'
%     'markerLNNToggle'
%     'markerType'
%     'markerCutoffs'
%     'gapCenterLoc'
%     'bnoiseToggle'
%     'bnoiseType'
%     'bnoiseDur'
%     'bnoiseRamp'
%     'bnoiseOffset'
%     'bnoiseLevel'
%     'bnoiseCutoffs'
%     'precursorToggle'
%     'precursorLevel'
%     'precursorDur'
%     'precursorType'
%     'precursorGap'
%     'precursorRamp'
%     'precursorCutoffs'
%     'blockNum'
%     'noiseBW'
%     'GUIpath'
pNames=fields(handles.stimParams);
for i=1:length(pNames)
    eval([pNames{i} '=handles.stimParams.' pNames{i} ';']);
end
%----------------------------------------------------------------------
%%%%% create the stimuli
% time vectors
if makeGapYN
    t_marker=linspace(0,dur,fix(handles.Fs*dur));
else
    pregap=length(linspace(0,dur,fix(handles.Fs*dur)));
    nGapPts=floor(initialGapDur/(1/handles.Fs));
    totlen=pregap+nGapPts;
    t_marker=[0:1:totlen-1].*(1/handles.Fs);
    %    t_marker=linspace(0,dur+initialGapDur,fix(handles.Fs*(dur+initialGapDur)));
end

t_bnoise=linspace(0,bnoiseDur+initialGapDur,fix(handles.Fs*(bnoiseDur+initialGapDur)));
t_precursor=linspace(0,precursorDur,fix(handles.Fs*precursorDur));

% toggle status
makeStimYN=logical([1 bnoiseToggle precursorToggle]);
stimClass={'marker';'bnoise';'precursor'};
stimMake=stimClass(makeStimYN);
markerRamp=handles.stimParams.ramp;

% amplitdue vectors
for j=1:length(stimMake)
    stimj=stimMake{j};
    t_stim=eval(['t_' stimj]);
    a_stim=randn(1,length(t_stim));
    stimType=eval([stimj 'Type']);
    stimCutoff=eval([stimj 'Cutoffs']);
    stimLevel=eval([stimj 'Level']);
    stimRamp=eval([stimj 'Ramp']);
    LLNStr=[stimj 'LNNToggle'];
    
    % make the noise or tone
    switch stimType
        case {'BBN'; 'NBN'; 'NtchN'}
            
            if length(stimCutoff)==4
                [stimFilt1, LNN_stim1]=makeLNN_gap(a_stim,stimCutoff(1:2),handles.Fs);
                [stimFilt2, LNN_stim2]=makeLNN_gap(a_stim,stimCutoff(3:4),handles.Fs);
                stimFilt=(stimFilt1+stimFilt2)./sqrt(2);
                LNN_stim=(LNN_stim1+LNN_stim2)./sqrt(2);
            else
                [stimFilt, LNN_stim]=makeLNN_gap(a_stim,stimCutoff,handles.Fs);
            end
            
            if exist(LLNStr,'var') && eval([LLNStr '==1'])
                eval([stimj '= LNN_stim;']);
            else
                eval([stimj '= stimFilt;']);
            end
        case 'Tone'           
            stimFilt=sin(2*pi*stimCutoff*t_stim);  %tone            
            eval([stimj '= stimFilt;']);
        otherwise
    end
    
    % insert the gap if stimulus is the marker and a gap is called for
    switch stimj
        case 'marker'
            if makeGapYN
                gapStim=insertGap(eval(stimj),gapCenterLoc,initialGapDur,markerGapRamp,handles.Fs,stimType);
                eval([stimj '= gapStim;']);
            else
                eval([stimj '= eval(stimj);']);
            end
        otherwise
    end
    handles.(stimj)=[rampstim(scale2db_gap(eval(stimj),stimLevel,'no_correct'),stimRamp*1000,handles.Fs)];
end

%------------ put the stimuli together
buffer=zeros(1,fix(handles.Fs*0.050)); %short buffer before & after stim turns on
if precursorToggle==0
    handles.precursor=[]; % create an empty vector to serve as a place holder for the precursor if no precursor has been selected
else
end

if bnoiseToggle
    handles.stim=[buffer handles.precursor handles.marker+handles.bnoise buffer];
else
    handles.stim=[buffer handles.precursor handles.marker buffer];
end


