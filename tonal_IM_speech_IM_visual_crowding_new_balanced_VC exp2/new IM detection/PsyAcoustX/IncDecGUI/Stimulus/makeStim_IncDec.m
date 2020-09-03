function [handles,  buffer]=makeStim_IncDec(handles,makeGapYN)

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
% if makeGapYN
%     t_marker=linspace(0,dur,fix(handles.Fs*dur));
% else
%     pregap=length(linspace(0,dur,fix(handles.Fs*dur)));
%     nGapPts=floor(initialGapDur/(1/handles.Fs));
%     totlen=pregap+nGapPts;
%     t_marker=[0:1:totlen-1].*(1/handles.Fs);
%     %    t_marker=linspace(0,dur+initialGapDur,fix(handles.Fs*(dur+initialGapDur)));
% end
t_marker=linspace(0,dur,fix(handles.Fs*dur));
t_bnoise=t_marker;
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
                
                % correct for differences in spectrum level
                BW1=stimCutoff(2)-stimCutoff(1);
                BW2=stimCutoff(4)-stimCutoff(3);
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
                
            else
                [stimFilt, LNN_stim]=makeLNN_gap(a_stim,stimCutoff,handles.Fs);
            end
            
            if exist(LLNStr,'var') && eval([LLNStr '==1'])
                eval([stimj '= LNN_stim;']);
            else
                eval([stimj '= stimFilt;']);
            end
        case 'Tone'
            % calculate phase change to line up with increment / decrement
            switch stimj
                case 'marker' % adjust the phase of the pedestal to add constructively or destructively with the signal
                    nsamp=length(t_stim);
                    startSamp=round(nsamp*gapCenterLoc);
                    aStartIncDec=sin(2*pi*stimCutoff*t_stim(startSamp));
                    SignStartIncDec=sin(2*pi*(2*stimCutoff)*t_stim(startSamp));
                    addPIYN=(sign(aStartIncDec)*sign(SignStartIncDec))*-1;
                    phz=asin(aStartIncDec)*-1;
                    
                    if addPIYN==1
                        stimFilt=sin(2*pi*stimCutoff*t_stim+(pi-phz));  %tone
                    else
                        stimFilt=sin(2*pi*stimCutoff*t_stim+phz);  %tone
                    end
                    
                otherwise
                    stimFilt=sin(2*pi*stimCutoff*t_stim);  %tone
            end
            stimFilt=stimFilt./rms(stimFilt);
            eval([stimj '= stimFilt;']);
        otherwise
    end
    
    % insert the gap if stimulus is the marker and a gap is called for
    switch stimj
        case 'marker'
            if makeGapYN
                [gapStim, refStim]=insertIncDec(eval(stimj),gapCenterLoc,initialGapDur,...
                    handles.Fs,stimCutoff,initialIncDec,DecrementYN,stimType);
                eval([stimj '= gapStim;']);
                
                handles.(stimj)=[rampstim(scale2db_gap(eval(stimj),stimLevel,handles.phones,handles.Fs,refStim),stimRamp*1000,handles.Fs)];
            else
                eval([stimj '= eval(stimj);']);
                handles.(stimj)=[rampstim(scale2db_gap(eval(stimj),stimLevel,handles.phones,handles.Fs),stimRamp*1000,handles.Fs)];
            end
        otherwise
            handles.(stimj)=[rampstim(scale2db_gap(eval(stimj),stimLevel,handles.phones,handles.Fs),stimRamp*1000,handles.Fs)];
    end
    
end

%------------ put the stimuli together
buffer=zeros(1,fix(handles.Fs*0.050)); %short buffer before & after stim turns on
if precursorToggle==0
    handles.precursor=[]; % create an empty vector to serve as a place holder for the precursor if no precursor has been selected
else
end

if bnoiseToggle
    calNoiseCheck=0;
    if calNoiseCheck
        handles.stim=[buffer handles.precursor handles.bnoise buffer];
    else
        handles.stim=[buffer handles.precursor handles.marker+handles.bnoise buffer];
    end
else
    handles.stim=[buffer handles.precursor handles.marker buffer];
end


