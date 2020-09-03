function initialize_params_gap(handles)

%-Import intialized parameters--------------------------
% marker parameters %
set(handles.markerLevelEdit, 'String', num2str(handles.stimParams.markerLevel));
set(handles.markerDurEdit, 'String', num2str(1000*handles.stimParams.dur));
set(handles.markerRampEdit, 'String', num2str(1000*handles.stimParams.ramp));
set(handles.gapRampEdit,'String',num2str(1000*handles.stimParams.markerGapRamp));


for mi=1:length(handles.stimParams.markerCutoffs) % set marker cutoffs
    ffield=['f' num2str(mi) 'MarkerEdit'];
    set(handles.(ffield),'String',num2str(handles.stimParams.markerCutoffs(mi)));
end

% background noise parameters %
set(handles.bnoiseToggle,'Value',handles.stimParams.bnoiseToggle);
set(handles.bnoiseLevelEdit,'String',num2str(handles.stimParams.bnoiseOffset));
set(handles.bnoiseDurEdit,'String',num2str(1000*handles.stimParams.bnoiseDur));
set(handles.bnoiseRampEdit,'String',num2str(1000*handles.stimParams.bnoiseRamp));

for bi=1:length(handles.stimParams.bnoiseCutoffs) % set bnoise cutoffs
    ffield=['f' num2str(bi) 'bnoiseEdit'];
    set(handles.(ffield),'String',num2str(handles.stimParams.bnoiseCutoffs(bi)));
end

% precursor parameters %
set(handles.preToggle,'Value',handles.stimParams.precursorToggle);
set(handles.precursorLevelEdit,'String',num2str(handles.stimParams.precursorLevel));
set(handles.precursorDurEdit,'String',num2str(1000*handles.stimParams.precursorDur));
set(handles.precursorRampEdit,'String',num2str(1000*handles.stimParams.precursorRamp));
set(handles.preGapEdit,'String',num2str(1000*handles.stimParams.precursorGap));

for pi=1:length(handles.stimParams.precursorCutoffs) % set precursor cutoffs
    ffield=['f' num2str(pi) 'precursorEdit'];
    set(handles.(ffield),'String',num2str(handles.stimParams.precursorCutoffs(pi)));
end

% other parameters %
set(handles.blockEdit, 'String', num2str(handles.stimParams.blockNum));
set(handles.gapLocEdit,'String',num2str(100*handles.stimParams.gapCenterLoc));
set(handles.initialGapDurEdit,'String',num2str(1000*handles.stimParams.initialGapDur));

% Set visibility of panels
if handles.stimParams.precursorToggle % precursor panel
    set(handles.precursorMainPanel,'visible','on');
else
    set(handles.precursorMainPanel,'visible','off');
end

if handles.stimParams.bnoiseToggle % noise panel
    set(handles.bnoiseMainPanel,'visible','on');
else
    set(handles.bnoiseMainPanel,'visible','off');
end

% determine the type of marker, precursor and bnoise
switch handles.stimParams.markerType % update marker type panel
    case 'NBN'
        set(handles.markerSpectrumPanel,'visible','on');
        set(handles.f3MarkerStr,'visible','off');
        set(handles.f3MarkerEdit,'visible','off');
        set(handles.f4MarkerStr,'visible','off');
        set(handles.f4MarkerEdit,'visible','off');
        set(handles.markerTypePanel,'SelectedObject',handles.markerNBNSelect);
    case 'NtchN'
        set(handles.markerSpectrumPanel,'visible','on');
        set(handles.f3MarkerStr,'visible','on');
        set(handles.f3MarkerEdit,'visible','on');
        set(handles.f4MarkerStr,'visible','on');
        set(handles.f4MarkerEdit,'visible','on');
        set(handles.markerTypePanel,'SelectedObject',handles.markerNtchNSelect);
    case 'Tone'
        set(handles.markerTypePanel,'SelectedObject',handles.markerToneSelect);
        set(handles.markerSpectrumPanel,'visible','on');
    case 'BBN'
        set(handles.markerTypePanel,'SelectedObject',handles.markerBBNSelect);
        set(handles.markerSpectrumPanel,'visible','off');
    otherwise
        error('masker type not recognized...');
end

switch handles.stimParams.precursorType % update precursor type panel
    case 'NBN'
        set(handles.precursorSpectrumPanel,'visible','on');
        set(handles.f3precursorStr,'visible','off');
        set(handles.f3precursorEdit,'visible','off');
        set(handles.f4precursorStr,'visible','off');
        set(handles.f4precursorEdit,'visible','off');
        set(handles.precursorTypePanel,'SelectedObject',handles.precursorNBNSelect);
    case 'NtchN'
        set(handles.precursorSpectrumPanel,'visible','on');
        set(handles.f3precursorStr,'visible','on');
        set(handles.f3precursorEdit,'visible','on');
        set(handles.f4precursorStr,'visible','on');
        set(handles.f4precursorEdit,'visible','on');
        set(handles.precursorTypePanel,'SelectedObject',handles.precursorNtchNSelect);
    case 'Tone'
        set(handles.precursorTypePanel,'SelectedObject',handles.precursorToneSelect);
        set(handles.precursorSpectrumPanel,'visible','on');
    case 'BBN'
        set(handles.precursorTypePanel,'SelectedObject',handles.precursorBBNSelect);
        set(handles.precursorSpectrumPanel,'visible','off');
    otherwise
        error('masker type not recognized...');
end

switch handles.stimParams.bnoiseType % update bnoise type panel
    case 'NBN'
        set(handles.bnoiseSpectrumPanel,'visible','on');
        set(handles.f3bnoiseStr,'visible','off');
        set(handles.f3bnoiseEdit,'visible','off');
        set(handles.f4bnoiseStr,'visible','off');
        set(handles.f4bnoiseEdit,'visible','off');
        set(handles.bnoiseTypePanel,'SelectedObject',handles.bnoiseNBNSelect);
    case 'NtchN'
        set(handles.bnoiseSpectrumPanel,'visible','on');
        set(handles.f3bnoiseStr,'visible','on');
        set(handles.f3bnoiseEdit,'visible','on');
        set(handles.f4bnoiseStr,'visible','on');
        set(handles.f4bnoiseEdit,'visible','on');
        set(handles.bnoiseTypePanel,'SelectedObject',handles.bnoiseNtchNSelect);
    case 'Tone'
        set(handles.bnoiseTypePanel,'SelectedObject',handles.bnoiseToneSelect);
        set(handles.bnoiseSpectrumPanel,'visible','on');
    case 'BBN'
        set(handles.bnoiseTypePanel,'SelectedObject',handles.bnoiseBBNSelect);
        set(handles.bnoiseSpectrumPanel,'visible','off');
    otherwise
        error('masker type not recognized...');
end