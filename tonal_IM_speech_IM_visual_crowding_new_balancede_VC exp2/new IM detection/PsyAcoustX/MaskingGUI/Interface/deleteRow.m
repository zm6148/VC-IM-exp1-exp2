function [t1]=deleteRow(t1, eventdata,handles)
%%% get the selected cell
selectedCell=get(t1,'UserData');

if isempty(selectedCell) % executes if a cell is right-clicked before being left-clicked
    %%% remind the user that the cell must be left-clicked first
    errordlg('you must left-click a cell before right clicking','deleting conditions');
else    
    
    % get the original conditions from the table and then remove the
    % selected condition and display the change in the table
    origTable=get(t1,'Data');
    
    % create a logical for indexing the column to be deleted [i.e. selectedCell(:,2)]
    tblIndex=ones(1,size(origTable,2));
    tblIndex(unique(selectedCell(:,2)))=0;
    tblIndex=logical(tblIndex);
    
    % update the table
    newTable=origTable(:,tblIndex);
    set(t1,'Data',newTable);
    
    % store a log of the modifications made to the table (this will be used
    % to update the ExptInfo.mat file when the figure is closed by the
    % user).
    modLog=getappdata(t1,'modLog');
    modLog.deleteNames=[modLog.deleteNames{:} origTable(1,unique(selectedCell(:,2)))];
    setappdata(t1,'modLog',modLog);
    drawnow; % display the updated table.  
end


