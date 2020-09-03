function initialize_params_mod(handles)


%-Import intialized parameters--------------------------
set(handles.sigLevelEdit, 'String', num2str(handles.stimParams.sigLevel));
set(handles.sigDurEdit, 'String', num2str(1000*handles.stimParams.dur));
set(handles.carrierFreqEdit, 'String', num2str(handles.stimParams.fc));
set(handles.modFreqEdit, 'String', num2str(handles.stimParams.fm));
set(handles.rampEdit, 'String', num2str(1000*handles.stimParams.ramp));
set(handles.blockEdit, 'String', num2str(handles.stimParams.blockNum));
set(handles.preToggle,'Value',handles.stimParams.preToggle);
set(handles.preLevel,'String', num2str(handles.stimParams.preLevel));
set(handles.preDur,'String', num2str(1000*handles.stimParams.preDur));
set(handles.preDel,'String', num2str(1000*handles.stimParams.preDel));
set(handles.pmToggle,'Value',handles.stimParams.pmToggle);
set(handles.pmCF,'String', num2str(handles.stimParams.pmCF));
set(handles.pmBW,'String', num2str(handles.stimParams.pmBW));
set(handles.precursorLNNToggle,'Value',handles.stimParams.precursorLNNToggle);
set(handles.carrierLNNToggle,'Value',handles.stimParams.carrierLNNToggle);
set(handles.f1precursorEdit,'String',num2str(handles.stimParams.precursorCutoffs(1)));
set(handles.f2precursorEdit,'String',num2str(handles.stimParams.precursorCutoffs(2)));
set(handles.f3precursorEdit,'String',num2str(handles.stimParams.precursorCutoffs(3)));
set(handles.f4precursorEdit,'String',num2str(handles.stimParams.precursorCutoffs(4)));

if strcmp(handles.stimParams.carrierType,'noise')
    set(handles.noiseMod,'Value',1);
    set(handles.toneMod,'Value',0);
    set(handles.carrierFreqEdit,'Enable','off');
    set(handles.pmToggle,'Enable','on');
    set(handles.carrierLNNToggle,'Enable','on');
    
    if get(handles.pmToggle,'Value')
        set(handles.pm_panel,'Visible','on');
    else
        set(handles.pm_panel,'Visible','off');
    end
    
    
else %tone carrier
    set(handles.noiseMod,'Value',0);
    set(handles.toneMod,'Value',1);
    set(handles.carrierFreqEdit,'Enable','on');
    set(handles.pmToggle,'Value',0,'Enable','off');
    set(handles.pm_panel,'Visible','off');
    set(handles.carrierLNNToggle,'Enable','off');
end

if get(handles.preToggle,'Value')
    set(handles.precursor_panel,'Visible','on');
else
    set(handles.precursor_panel,'Visible','off');
end

if get(handles.pmToggle,'Value')
    set(handles.pm_panel,'Visible','on');
else
    set(handles.pm_panel,'Visible','off');
    
end
