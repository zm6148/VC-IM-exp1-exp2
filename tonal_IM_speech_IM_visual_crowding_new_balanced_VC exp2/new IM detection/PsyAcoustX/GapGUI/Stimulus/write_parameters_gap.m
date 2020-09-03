function write_parameters_gap(handles,pathname)
%saves stimulus parameters from GUI for easy re-loading
set(handles.selectStimParams_FIG,'UserData',handles.stimParams);
hgsave(handles.selectStimParams_FIG,[pathname handles.paramsFile]);
set(handles.selectStimParams_FIG,'UserData',[]);


