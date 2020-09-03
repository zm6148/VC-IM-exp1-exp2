function updateExptInfo(hFIG,eventdata,updateType)

switch updateType
    case 'delete' % executes when the table is closed after deleting conditions
        %%% get the original experiment information (before deletions were
        %%% made) and get the log of modifications made by the user
        origExptInfo=get(hFIG,'UserData'); % original ExptInfo
        origExptNames=cellstr(origExptInfo.ExptInfo.tblcolnames);
        guiTable=findall(hFIG,'tag','exptTable');
        modLog=getappdata(guiTable,'modLog'); % log of modifications
        
        %%% Initialize the new ExptInfo file to be the same as the original
        ExptInfo=origExptInfo.ExptInfo;
        
        %%% use the modification log to find out what conditions were
        %%% deleted and their corresponding indices
        [rmvNames,irmvNamesOrig,imodLog]=intersect(origExptNames,modLog.deleteNames);
        
        % create a logical to index items in ExptInfo.  This will index all
        % items except the items that were deleted.  
        initLogical=ones(1,length(origExptNames));
        initLogical(irmvNamesOrig)=0;
        irmvCond=logical(initLogical);
        
        % remove the deleted items from fields in ExptInfo
        ExptInfo.tblcolnames=origExptInfo.ExptInfo.tblcolnames(irmvCond,:);
        ExptInfo.fnames=origExptInfo.ExptInfo.fnames(irmvCond);
        ExptInfo.fcompleteYN=origExptInfo.ExptInfo.fcompleteYN(irmvCond);
        ExptInfo.Thresholds=origExptInfo.ExptInfo.Thresholds(irmvCond);
        ExptInfo.StdDev=origExptInfo.ExptInfo.StdDev(irmvCond);
        ExptInfo.Table=origExptInfo.ExptInfo.Table(:,irmvCond);
        
        % find where the deleted items occured in the order of condiions to
        % be run
        [rmvVals,irmvValsOrig,indx]=intersect(origExptInfo.ExptInfo.forder,irmvNamesOrig);
        
        % create a logical to index the list order (ExptInfo.forder) and
        % remove the conditions that were deleted
        initLogical=ones(1,length(origExptNames));
        initLogical(irmvValsOrig)=0;
        irmvOrder=logical(initLogical);
        
        % update the order of conditions to be run
        ExptInfo.forder=origExptInfo.ExptInfo.forder(irmvOrder);
 
        % get a list of the filenames of the deleted conditions
        fNames2Move=origExptInfo.ExptInfo.fnames(~irmvCond);
        
        % find out if the deleted conditions were already run
        deletedCompleteYN=origExptInfo.ExptInfo.fcompleteYN(~irmvCond);
        
        % define the paths in preparation for moving the files of the
        % deleted conditions to the 'deleted' folder
        SubjDir=dir(ExptInfo.SubjPath);
        subDirNames={SubjDir.name};
        deletedDirYN=strcmp(subDirNames,'deleted');
        origTestDir=[ExptInfo.SubjPath 'TestFiles\'];
        origDataDir=[ExptInfo.SubjPath 'DataDir\'];
        deletedTestDir=[ExptInfo.SubjPath 'deleted\TestFiles\'];
        deletedDataDir=[ExptInfo.SubjPath 'deleted\DataDir\'];
        
        if any(deletedDirYN)
        else
            %%% create a 'deleted' directory if this is the first time
            %%% conditions have been removed from the experiment.  Also,
            %%% save the original ExptInfo file in the deleted directory.
            mkdir(ExptInfo.SubjPath,'deleted');
            mkdir([ExptInfo.SubjPath 'deleted\'],'TestFiles');
            mkdir([ExptInfo.SubjPath 'deleted\'],'DataFiles');
            save([ExptInfo.SubjPath '\deleted\' origExptInfo.ExptInfo.Name '.mat'],'origExptInfo');
        end
        
        wb1=waitbar(0,'moving deleted conditions to the ''deleted'' folder...');
        
        %%% move the files to the deleted folder
        for nfiles=1:length(fNames2Move)
            movefile([origTestDir fNames2Move{nfiles}],[deletedTestDir fNames2Move{nfiles}],'f');
            if deletedCompleteYN(nfiles)
                movefile([origDataDir fNames2Move{nfiles}],[deletedDataDir fNames2Move{nfiles}],'f');
            else
            end
            waitbar(nfiles/length(fNames2Move),wb1);
        end
        
        %%% save the updated ExptInfo
        save([ExptInfo.SubjPath ExptInfo.Name '.mat'],'ExptInfo');
        pause(1);
        close(wb1);
        delete(gcf);        
    otherwise
        %%% get the stimulus parameters for the condition being added
        stim2Add=getappdata(hFIG,'stim2Add'); % get handles.stimParams
        stimFieldNames=fieldnames(stim2Add); % get fields of stimParams structure
        DataPath=[cd '\Data\']; % define path where experimental data/info is saved
        [ExptInfoFile, ExptInfoDir]=uigetfile([DataPath '*.mat'], 'Open subject folder and select ExptInfo.mat file...');
        cExpt=load([ExptInfoDir '\' ExptInfoFile]); % load the Experiment for the selected subject
        ExptInfo=cExpt.ExptInfo;
        
        %%% add the new condition to the ExptInfo structure
        nOrigConds=size(cExpt.ExptInfo.Table,2);
        newCondName=['cond #' num2str(nOrigConds+1)];
        ExptInfo.tblcolnames=[ExptInfo.tblcolnames; newCondName];
        ExptInfo.fnames=[ExptInfo.fnames(:); [ExptInfo.subID '_' num2str(nOrigConds+1) '.txt']];
        ExptInfo.fcompleteYN=[ExptInfo.fcompleteYN; 0];
        ExptInfo.Thresholds=[ExptInfo.Thresholds zeros(ExptInfo.nStoreBlocks,1)];
        ExptInfo.StdDev=[ExptInfo.StdDev zeros(ExptInfo.nStoreBlocks,1)];
        ExptInfo.forder=[nOrigConds+1; ExptInfo.forder]; % added condition is next to be run
        
        %%% update the table in ExptInfo
        blankCell=cell(size(ExptInfo.Table,1),1);
        ExptInfo.Table=[ExptInfo.Table blankCell];
        
        for nflds=1:length(stimFieldNames)
            cfldname=stimFieldNames{nflds};
            fldindx=logical(strcmp(cfldname,ExptInfo.tblheader));
            if any(fldindx)
                ExptInfo.Table{fldindx,end}=stim2Add.(cfldname);
            else
            end
        end
        h.stimParams=stim2Add;
        h.paramsFile=ExptInfo.fnames{end};
      
        % update maskerFreq and maskerCutoffs cells if masker is a notched
        % noise.  
        if stim2Add.notchToggle
            mFreqRow=~logical(cellfun('isempty',strfind(ExptInfo.tblheader,'maskerFreq')));
            mCutoffsRow=~logical(cellfun('isempty',strfind(ExptInfo.tblheader,'tempMaskerCutoffs')));
            ExptInfo.Table{mFreqRow,end}=unique(abs(stim2Add.maskerCutoffs(2:3)-stim2Add.targetFreq)./stim2Add.targetFreq);
            ExptInfo.Table{mCutoffsRow,end}=stim2Add.maskerCutoffs;
        else
        end
        
        if exist([ExptInfo.SubjPath 'added'],'dir')
        else % if this is the first time adding a condition, make a directory called 'added'
            origExptInfo=cExpt.ExptInfo;
            mkdir(ExptInfo.SubjPath,'added');
            save([ExptInfo.SubjPath 'added\origExptInfo.mat'],'origExptInfo'); % save the original experimental setup information in ExptInfo
        end
                
        %%% write the added condition to a .txt file and save the new
        %%% experimental information in ExptInfo.
        write_parameters(h, [ExptInfo.SubjPath 'TestFiles\']);
        write_parameters(h, [ExptInfo.SubjPath 'added\']);
        save([ExptInfo.SubjPath ExptInfo.Name '.mat'],'ExptInfo');
        
end
