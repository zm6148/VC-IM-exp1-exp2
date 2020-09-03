function handles=setPanels(handles)


tStatus= [num2str(get(handles.preToggle,'Value')) num2str(get(handles.suppToggle,'Value'))];

% possible combinations of precursor and suppressor
%   00 - no precursor or suppressor
%   10 - no suppressor
%   01 - precursor
%   11 - include both precursor and suppressor conditions

switch tStatus
    case '00'
        set(handles.precursorPanel,'Visible','off');
        set(handles.noStdToggle,'Visible','off');
        set(handles.noStdToggle,'Value',0);
        handles.excludeStdYN=0;
        
        set(handles.suppressorPanel,'Visible','off');
        set(handles.noCombToggle,'Value',0);
        set(handles.noCombToggle,'Visible','off');
        handles.excludeCombYN=1;
        
    case '10'
        set(handles.precursorPanel,'Visible','on');
        set(handles.noStdToggle,'Visible','on');
        set(handles.noStdToggle,'Value',0);
        handles.excludeStdYN=0;
        
        set(handles.suppressorPanel,'Visible','off');
        set(handles.noCombToggle,'Value',0);
        set(handles.noCombToggle,'Visible','off');
        handles.excludeCombYN=1;
        
    case '01'
        set(handles.precursorPanel,'Visible','off');
        set(handles.noStdToggle,'Visible','on');
        set(handles.noStdToggle,'Value',0);
        handles.excludeStdYN=0;
        
        set(handles.suppressorPanel,'Visible','on');
        set(handles.noCombToggle,'Visible','off');
        set(handles.noCombToggle,'Value',0);
        handles.excludeCombYN=1;
        set(handles.sNameDelay,'String','Time from masker onset');
    case '11'
        set(handles.precursorPanel,'Visible','on');
        set(handles.noStdToggle,'Visible','on');
        set(handles.noStdToggle,'Value',0);
        handles.excludeStdYN=0;
        
        set(handles.suppressorPanel,'Visible','on');
        set(handles.noCombToggle,'Visible','on');
        set(handles.noCombToggle,'Value',0);
        handles.excludeCombYN=0;
        set(handles.sNameDelay,'String','Time from precursor onset');
        
    otherwise
        error('Precursor/Suppressor option not recognized...');
end

