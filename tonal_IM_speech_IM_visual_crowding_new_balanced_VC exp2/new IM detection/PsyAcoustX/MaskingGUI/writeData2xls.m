function []=writeData2xls(runExptInfo)

% define the ExptInfo path and get the ExptInfo file
ExptInfoPath=[runExptInfo.SubjDir runExptInfo.MatFile];
cExptInfo=load(ExptInfoPath);
xlsPath=[runExptInfo.SubjDir cExptInfo.ExptInfo.subID 'Data'];

% retrieve table, thresholds and stddev from structure
exptTable=cExptInfo.ExptInfo.Table;
exptThresh=cExptInfo.ExptInfo.Thresholds;
exptSTD=cExptInfo.ExptInfo.StdDev;

% Check to see if condition needs to be rerun
tolSTD=5;

%%%%% March 2013, for the overshoot experiment we removed the rule of
%%%%% repeating a condition if the STD of an individual run was greater
%%%%% than 5 dB.  This resulted in the two commented lines below.  
% nSTDgtTOL=sum(exptSTD(:,runExptInfo.CondNum)>tolSTD);

saveIndx=find(strcmp(cExptInfo.ExptInfo.fnames,[runExptInfo.SaveFile '.txt'])==1);
STDxTHRESH=std(exptThresh(:,saveIndx));
rerunYN=STDxTHRESH>tolSTD;

%if nSTDgtTOL || rerunYN % need to rerun conditions
if rerunYN % need to rerun conditions
    %%% check to see if Runs2Repeat directory exists
    repeatDir=[runExptInfo.SubjDir 'Runs2Repeat'];
    dirYN=exist(repeatDir,'dir');
    if dirYN
    else
        mkdirYN=mkdir(repeatDir);
    end
    
    %%% check to see if a repeat directory exits for today's date
    dateDir=[repeatDir '\' date];
    dirYN=exist(dateDir,'dir');
    if dirYN
    else
        mkdirYN=mkdir(dateDir);
    end
    
    %%% copy the condition to be repeated to directory dated today
    origFile=[runExptInfo.SubjDir 'TestFiles\' runExptInfo.SaveFile '.txt'];
    copyYN=copyfile(origFile,dateDir);
    
    hmsg = msgbox('The subject has at least one condition to re-run before the end of the session',...
        'Re-run conditions prompt','warn');
    set(hmsg,'Visible','off','CloseRequestFcn','');
    hchild=get(hmsg,'Children');
    set(hchild(3),'Visible','off');
    set(hmsg,'Visible','on');
    pause(3);
    delete(hmsg);
    
else
end


%%% change masker notchwidths to strings in order to write to xls
charYN=cellfun(@ischar,exptTable);
scalarYN=cellfun(@isscalar,exptTable);
mNtchIndx=logical(~scalarYN-charYN);
exptTable(mNtchIndx)=cellfun(@num2str,exptTable(mNtchIndx),'UniformOutput',0);

% find unique rows in the Table
incRows=zeros(size(exptTable,1),1);
for i=1:size(exptTable,1)
    val=unique([exptTable{i,:}]);
    if (length(val)*isnumeric(val))>1 && ~any(isnan(val));
        incRows(i)=1;
    else
        incRows(i)=0;
    end
end

% create extra columns to display the thresholds and stddev values
nThresh=size(exptThresh,1);
threshIndx=repmat(num2str([1:nThresh]'),2,1);
suffixHeader=[[repmat('Threshold',nThresh,1); repmat('StdDev   ',nThresh,1)] threshIndx];

% define the table and header to be exported.  Only include rows that have
% more than one unique value (i.e. have more than one value).  For example, if an
% experiment had all parameters the same except the signal level, then
% only the row corresponding to signal level would have more than one
% unique value.
fullHeader=cellstr([cExptInfo.ExptInfo.tblheader(logical(incRows)) cellstr(suffixHeader)']);
fullTable=[fullHeader' [exptTable(logical(incRows),:); num2cell(exptThresh); num2cell(exptSTD)]];

xlsarg=['A1:' char('A'+size(fullTable',2)) num2str(size(fullTable',1))];
rownames=['Condition';cellstr(cExptInfo.ExptInfo.tblcolnames)];
xlsOtherParams=['A' num2str(size(fullTable',1)+2) ':B' num2str(length(incRows==0))];

% write to the xls file...
wbxls=waitbar(0,'Saving data to .xls file, please wait...');
if exist([xlsPath '.xls'],'file')
    delete([xlsPath '.xls']);
    xlswrite(xlsPath,[rownames fullTable'],xlsarg);
    waitbar(.5,wbxls);
    xlswrite(xlsPath,[cExptInfo.ExptInfo.tblheader(~logical(incRows))' exptTable(~logical(incRows),1)],xlsOtherParams);
    waitbar(1,wbxls);
else
    xlswrite(xlsPath,[rownames fullTable'],xlsarg);
    waitbar(.5,wbxls);
    xlswrite(xlsPath,[cExptInfo.ExptInfo.tblheader(~logical(incRows))' exptTable(~logical(incRows),1)],xlsOtherParams);
    waitbar(1,wbxls);
end
close(wbxls);