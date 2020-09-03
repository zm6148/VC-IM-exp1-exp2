function handles=load_parameters_gap(handles,pathname)
%load set of saved stimulus parameters to GUI

[newGUI]=hgload([pathname handles.paramsFile]);
allobj=findall(newGUI);

% get the fields of all children of newGUI and match with the fields of
% handles
hfields=fields(handles);

for i=1:length(allobj)
    % see if the current object is a field in handles
    objTag=get(allobj(i),'Tag');
    objYN=strcmp(objTag,hfields);
    if any(objYN)
        currobj=get(allobj(i),'Type');
        if strcmp(currobj,'uicontrol')
            currsty=get(allobj(i),'Style');
            switch currsty
                case {'radiobutton' 'checkbox'}
                    newV=get(allobj(i),'Value');
                    set(handles.(hfields{objYN}),'Value',newV);
                case 'String'
                    newS=get(allobj(i),'String');
                    set(handles.(hfields{objYN}),'String',newS);
                otherwise
            end
        else
        end
    else
    end
end
handles.stimParams=get(newGUI,'UserData');
delete(newGUI);