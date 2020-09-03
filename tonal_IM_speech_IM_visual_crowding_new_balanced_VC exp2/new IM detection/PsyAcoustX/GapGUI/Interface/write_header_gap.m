function write_header_gap(handles,results_pathname)

fid = fopen(results_pathname,'a');
fseek(fid,0,'eof');
time = clock;

stimParams=handles.blocks{handles.run.currentBlockNum-1}; %update stim params to current block

fprintf (fid, '\n');
fprintf (fid, '*********************************************************************************\n');
fprintf (fid, 'GAP DETECTION EXPERIMENT\n');
fprintf (fid, '%d/%d/%d %2d:%2d:%2d\n',time(2),time(3),time(1),time(4),time(5),round(time(6)));
fprintf (fid, '*********************************************************************************\n');
fprintf (fid, 'Listener:                   %s\n', handles.subID);
fprintf (fid, 'Paradigm:                   %s\n', '3AFC (2down-1up)');
fprintf (fid, 'Sample Rate (Hz):           %s\n', num2str(handles.Fs));
fprintf(fid,'\n');
fprintf(fid,'background noise toggle:  %s\n',num2str(stimParams.bnoiseToggle));
fprintf(fid,'precursor toggle:  %s\n',num2str(stimParams.precursorToggle));
fprintf (fid, '\n');

makeStimYN=logical([1 stimParams.bnoiseToggle stimParams.precursorToggle]);
stimClass={'marker';'bnoise';'precursor'};
stimMake=stimClass(makeStimYN);
stimParams.markerRamp=stimParams.ramp;
stimParams.markerDur=handles.stimParams.dur;
stimFields=fields(stimParams);
startChar=size(char(stimFields),2);

for j=1:length(stimMake)
    fieldYNCell=strfind(stimFields,stimMake{j});
    fieldYNMat=logical(~cellfun(@isempty,fieldYNCell));
    fieldNames=cell(sum(fieldYNMat),1);
    fieldNames(:)=stimFields(fieldYNMat);
    durCase={[stimMake{j} 'Dur'] [stimMake{j} 'Ramp'] [stimMake{j} 'Gap'] [stimMake{j} 'GapRamp']};
    for k=1:length(fieldNames)
        nChar=length(fieldNames{k});
        wsp=repmat(' ',1,startChar-nChar+4);
        switch fieldNames{k}
            case durCase
                fprintf(fid,[fieldNames{k}  wsp(1:end-4) '(ms):  %s\n'],num2str(1000*stimParams.(fieldNames{k})));
            otherwise
                fprintf(fid,[fieldNames{k}  wsp ':  %s\n'],num2str(stimParams.(fieldNames{k})));
        end
    end
end

fprintf (fid, '\n');
fclose (fid);

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