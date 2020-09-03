function varargout = registerSubject(varargin)
% REGISTERSUBJECT M-file for registerSubject.fig
%      REGISTERSUBJECT, by itself, creates a new REGISTERSUBJECT or raises the existing
%      singleton*.
%
%      H = REGISTERSUBJECT returns the handle to a new REGISTERSUBJECT or the handle to
%      the existing singleton*.
%
%      REGISTERSUBJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REGISTERSUBJECT.M with the given input arguments.
%
%      REGISTERSUBJECT('Property','Value',...) creates a new REGISTERSUBJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before registerSubject_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to registerSubject_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help registerSubject

% Last Modified by GUIDE v2.5 20-Jul-2015 15:00:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @registerSubject_OpeningFcn, ...
    'gui_OutputFcn',  @registerSubject_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before registerSubject is made visible.
function registerSubject_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to registerSubject (see VARARGIN)

% Choose default command line output for registerSubject
handles.output = hObject;

defaultSettings=varargin{1};
handles.subID = defaultSettings.subID;
handles.stimParams=defaultSettings.stimParams;
set(handles.subjectEdit, 'String', handles.subID);

movegui(hObject,'center')

%------------------------------------------------------------------------%
%%% set default values --------------------------------------------------%
%------------------------------------------------------------------------%

% general options--------------------------------------------------------%
set(handles.setupExptBox,'Value',1);  % assume the experimenter wants to define expt parameters
handles.setupExptYN=1;
h_simMskButton=handles.simMaskYN;
h_fMskButton=handles.fMaskYN;
set(handles.mskOptionPanel,'SelectedObject',h_simMskButton);
handles.nReps=2; % default number of repetitions is 2

preToggle=0;
suppToggle=0;
hpToggle=0;
trackTargetYN=0;

set(findall(0,'tag','displayReps'),'String',{'# reps'; num2str(handles.nReps)});
set(handles.preToggle,'Value',preToggle);
set(handles.suppToggle,'Value',suppToggle);
set(handles.hpToggle,'Value',hpToggle);
set(handles.trackTargetYN,'Value',trackTargetYN);
handles.stimParams.preToggle=get(handles.preToggle,'Value');
handles.stimParams.supToggle=get(handles.suppToggle,'Value');
handles.stimParams.hpMaskerToggle=get(handles.hpToggle,'Value');
handles.stimParams.trackTarget=get(handles.trackTargetYN,'Value');

if get(handles.mskOptionPanel,'SelectedObject')==h_simMskButton
    handles.stimParams.maskerType='simultaneous';
else
    handles.stimParams.maskerType='forward';
end

handles.startSNR=-15;

% target options --------------------------------------------------------%

targetDuration='6';
targetFrequency='2000,4000';
targetRamp='3';
targetDelay='2,198';

if get(handles.trackTargetYN,'Value')
    targetLevel='50';
    set(handles.tNameLevel,'String','Start Level');
else
    targetLevel='30,40,50,60,70,80,90';
end

set(handles.targetLevel,'String',targetLevel);
set(handles.targetDuration,'String',targetDuration);
set(handles.targetFrequency,'String',targetFrequency);
set(handles.targetRamp,'String',targetRamp);
set(handles.targetDelay,'String',targetDelay);
handles.stimParams.targetLevel=setStimParam(targetLevel);
handles.stimParams.targetDur=setStimParam(targetDuration);
handles.stimParams.targetFreq=setStimParam(targetFrequency);
handles.stimParams.targetRamp=setStimParam(targetRamp);
handles.stimParams.delay=setStimParam(targetDelay);
handles.stimParams.targetAlone=0;

handles.stimParams.hpMaskerLevel=NaN; % set to NaN until after comvec is called.

% masker options --------------------------------------------------------%

maskerDuration='400';
maskerRamp='3';

h_noiseButton=handles.mNoiseButton;
h_NNoiseButton=handles.mNNoiseButton;
h_toneButton=handles.mToneButton;
set(handles.mTypePanel,'SelectedObject',h_noiseButton);

if get(handles.trackTargetYN,'Value')
    maskerLevel='30,40,50,60';
    set(handles.maskerLevel,'String',maskerLevel);
else
    maskLvlNUM=str2num(targetLevel)+handles.startSNR;
    maskLvlSTR=[num2str(maskLvlNUM') repmat(',',length(maskLvlNUM),1)];
    maskLvlSTR=reshape(maskLvlSTR',1,numel(maskLvlSTR));
    maskerLevel=maskLvlSTR(1:end-1);
    set(handles.mNameLevel,'String','InitLvl SNR');
    set(handles.maskerLevel,'String',num2str(handles.startSNR));
    % original code below...
    %     maskerLevel='50';
end

% set masker frequency and notchToggle based on the status of the masker
% radio button
if get(handles.mTypePanel,'SelectedObject')==h_NNoiseButton % masker is a notched noise
    maskerFrequency='0.0';
    set(handles.maskerFrequency,'String',maskerFrequency);
    set(handles.mNameFrequency,'String','Notch Width');
    set(handles.mUnitsFrequency,'String','nrmlzd');
    handles.stimParams.maskerSig='noise';
    handles.stimParams.notchToggle=1;
elseif get(handles.mTypePanel,'SelectedObject')==h_noiseButton % masker is a braodband noise
    maskerFrequency='0.0';
    set(handles.maskerFrequency,'String','BB noise');
    set(handles.mNameFrequency,'String',' ');
    set(handles.mUnitsFrequency,'String',' ');
    set(handles.maskerFrequency,'Enable','off');
    handles.stimParams.maskerSig='noise';
    handles.stimParams.notchToggle=0;
else % masker is a tone
    maskerFrequency=['' targetFrequency ',' num2str(str2num((targetFrequency/2)))];
    set(handles.maskerFrequency,'String',maskerFrequency);
    handles.stimParams.maskerSig='tone';
    handles.stimParams.notchToggle=0;
end

handles.stimParams.tempMaskerCutoffs=NaN; % set dummy masker cutoff and then replace with real masker cutoffs after combvec is called
% this is done because if multiple notches are selected, maskerCutoffs becomes a matrix and combvec
% only works on vectors.

set(handles.maskerDuration,'String',maskerDuration);
set(handles.maskerRamp,'String',maskerRamp);
handles.stimParams.maskerLevel=setStimParam(maskerLevel);
handles.stimParams.maskerDur=setStimParam(maskerDuration);
handles.stimParams.maskerFreq=setStimParam(maskerFrequency);
handles.stimParams.maskerRamp=setStimParam(maskerRamp);

% precursor options -----------------------------------------------------%

precursorLevel='50';
precursorDuration='200';
precursorRamp='5';
precursorDelay='0';

set(handles.precursorLevel,'String',precursorLevel);
set(handles.precursorDuration,'String',precursorDuration);
set(handles.precursorRamp,'String',precursorRamp);
set(handles.precursorDelay,'String',precursorDelay);
handles=setPanels(handles);

h_pNoiseButton=handles.pNoiseButton;
set(handles.pTypePanel,'SelectedObject',h_pNoiseButton);

if get(handles.pTypePanel,'SelectedObject')==h_pNoiseButton % precursor is a noise
    precursorFrequency='0.0';
    set(handles.precursorFrequency,'Enable','off');
    set(handles.precursorFrequency,'String','BB Noise');
    set(handles.pNameFrequency,'String',' ');
    set(handles.pUnitsFrequency,'String',' ');
    handles.stimParams.preType='noise';
else
    precursorFrequency=targetFrequency; % precursor is a tone
    set(handles.maskerFrequency,'String',precursorFrequency);
    handles.stimParams.preType='tone';
end

handles.stimParams.preLevel=setStimParam(precursorLevel);
handles.stimParams.preDur=setStimParam(precursorDuration);
handles.stimParams.preFreq=setStimParam(precursorFrequency);
handles.stimParams.preRamp=setStimParam(precursorRamp);
handles.stimParams.preDelay=setStimParam(precursorDelay);

% suppressor options ----------------------------------------------------%

suppressorDuration='200';
suppressorFrequency=['' num2str(str2num(targetFrequency(1))*1.2) ''];
suppressorRamp='5';
suppressorDelay='0';
suppressorLevel='50';

set(handles.suppressorLevel,'String',suppressorLevel);
set(handles.suppressorDuration,'String',suppressorDuration);
set(handles.suppressorFrequency,'String',suppressorFrequency);
set(handles.suppressorRamp,'String',suppressorRamp);
set(handles.suppressorDelay,'String',suppressorDelay);
handles.stimParams.supLevel=setStimParam(suppressorLevel);
handles.stimParams.supDur=setStimParam(suppressorDuration);
handles.stimParams.supFreq=setStimParam(suppressorFrequency);
handles.stimParams.supRamp=setStimParam(suppressorRamp);
handles.stimParams.supDelay=setStimParam(suppressorDelay);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes registerSubject wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = registerSubject_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

if ~isfield(handles,'subID')
    varargout{1} = [];
    varargout{2} = [];
    delete(gcf);
else
    varargout{1} = handles.output;
    varargout{2} = handles.subID;
    delete(handles.figure1);
end



function subjectEdit_Callback(hObject, eventdata, handles)
% hObject    handle to subjectEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subjectEdit as text
%        str2double(get(hObject,'String')) returns contents of subjectEdit as a double

handles.subID = get(hObject, 'String');
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function subjectEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subjectEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in subject_pushbutton1.
function subject_pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to subject_pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.setupExptYN
    % change all durations to sec units (this is what maskingGUI uses when
    % loading files)
    handles.stimParams.maskerDur=handles.stimParams.maskerDur/1000;
    handles.stimParams.maskerRamp=handles.stimParams.maskerRamp/1000;
    handles.stimParams.delay=handles.stimParams.delay/1000;
    handles.stimParams.targetDur=handles.stimParams.targetDur/1000;
    handles.stimParams.targetRamp=handles.stimParams.targetRamp/1000;
    handles.stimParams.preDur=handles.stimParams.preDur/1000;
    handles.stimParams.preDelay=handles.stimParams.preDelay/1000;
    handles.stimParams.preRamp=handles.stimParams.preRamp/1000;
    handles.stimParams.supDur=handles.stimParams.supDur/1000;
    handles.stimParams.supDelay=handles.stimParams.supDelay/1000;
    handles.stimParams.supRamp=handles.stimParams.supRamp/1000;
    
    % column labels for a table that will show all conditions in experiment
    tblheader={'delay' 'preToggle' 'preType' 'preFreq' 'preDur'...
        'preLevel' 'preRamp' 'preDelay' 'maskerType' 'maskerSig' 'maskerFreq'...
        'maskerDur' 'notchToggle' 'hpMaskerToggle' 'hpMaskerLevel' 'tempMaskerCutoffs'...
        'maskerLevel' 'maskerRamp' 'targetLevel' 'targetFreq' 'targetDur'...
        'targetAlone' 'trackTarget' 'targetRamp' 'supToggle' 'supFreq' 'supDur'...
        'supDelay' 'supLevel' 'supRamp'};
    
    paramToggle=ones(length(tblheader),1); % initialize all parameters as 'TRUE' and then remove the ones that the user does not want
    
    % specify general items to exclude when creating the condition list
    if handles.stimParams.trackTarget
        genExclude={'preType','maskerType','maskerSig','targetLevel'}; % this (and the GUI) would need to be changed for an experiment that includes noise and tone precursors
    else
        genExclude={'preType','maskerType','maskerSig','maskerLevel'};
    end
    % original code before implementing SNR to initialize start values.
    % genExclude={'preType','maskerType','maskerSig'};
    [cmmnNames indxV1 indxV2]=intersect(genExclude,tblheader);
    genExcludeIndx=indxV2;
    paramToggle(genExcludeIndx)=0; % set these parameters to 'FALSE'
    
    
    flds2include=tblheader(logical(paramToggle)); % update the list of parameters names to include
    
    % build a string to pass into combvec. This string will contain the
    % values of each parameter in the experiment, separated by commas.
    fnarg_prefix=repmat('handles.stimParams.',length(flds2include),1);
    fnarg_suffix=char(flds2include');
    fnarg_comma=repmat(''',',length(flds2include),1);
    fnarg_combvec=cellstr([fnarg_prefix fnarg_suffix fnarg_comma]);
    fnarg_combvec=[fnarg_combvec'];
    fnarg_combvec=[fnarg_combvec{:}];
    fnarg_combvec=fnarg_combvec(~logical(isspace(fnarg_combvec))); % remove whitespace
    fnarg_combvec=fnarg_combvec(1:end-1);% remove final comma
    
    %%% basicList contains conditions according to the toggle status of the
    %%% precursor and suppressor.  If the precursor and suppressor toggles
    %%% are off, then basic list contains ONLY combinations of the signal
    %%% and masker parameters (i.e. standard conditions).  If only the precursor (or suppressor) toggle is on,
    %%% basicList contains only combinations of precursor (or suppressor), masker and
    %%% signal parameters. If both precursor and suppressor toggles are on, basicList
    %%% contains combintations of precursor, suppressor, signal and masker
    %%% parameters.
    basicList=eval(['CombVec(' fnarg_combvec ')']); % pass argument string into combvec to obtain all combinations of paramters
    
    % if the highpass masker is to be included, define the level of the
    % masker relative to the signal level (in this case 50 dB/Hz below the
    % signal level).
    if handles.stimParams.hpMaskerToggle
        % get the indicies for the signal level row
        hpLevelRow=~logical(cellfun('isempty',strfind(flds2include,'hpMaskerLevel')));
        sLevelRow=~logical(cellfun('isempty',strfind(flds2include,'targetLevel')));
        handles.stimParams.hpMaskerLevel=setStimParam(get(handles.targetLevel,'String'))...
            +handles.stimParams.hpMaskerOffset+10.*log10(handles.stimParams.hpCutUpper-handles.stimParams.targetFreq*handles.stimParams.hpMaskerCutoffNrmlz);
        [slvlVals,changeIndx,slvlIndx]=unique(basicList(sLevelRow,:));
        for nslvl=1:length(slvlIndx)
            basicList(hpLevelRow,nslvl)=handles.stimParams.hpMaskerLevel(slvlIndx(nslvl));
        end
    else
    end
    
    mCutOffsRow=~logical(cellfun('isempty',strfind(flds2include,'tempMaskerCutoffs')));
    
    % notched noise masking is selected, put an index for each normalized
    % notchwidth (which is entered into maskerFreq).
    if handles.stimParams.notchToggle
        mFreqRow=~logical(cellfun('isempty',strfind(flds2include,'maskerFreq')));
        [uVals,indxV1,indxV2]=unique(basicList(mFreqRow,:));
        basicList(mCutOffsRow,:)=indxV2;
    else
    end
    
    % check the toggles to evaluate whether to include precursor or
    % suppressor conditions-------------------------------------------%
    
    tStatus= [num2str(handles.stimParams.preToggle) num2str(handles.stimParams.supToggle)];
    
    preToggleRow=~logical(cellfun('isempty',strfind(flds2include,'preToggle')));
    supToggleRow=~logical(cellfun('isempty',strfind(flds2include,'supToggle')));
    
    switch tStatus
        case '00' % BasicList contains combinations of the masker and signal parameters and is already complete.  No need to modify.
            finalList=basicList;
            
        case '10' % BasicList lacks the standard condition
            if get(handles.noStdToggle,'Value') % don't need to modify further
                finalList=basicList;
                
            else % add the standard condition to the list
                stdList=basicList;
                stdList(preToggleRow,:)=0;
                finalList=[basicList stdList];
            end
            
        case '01' % BasicList lacks the standard condition
            if get(handles.noStdToggle,'Value') % don't need to modify further
                finalList=basicList;
                
            else % add the standard condition to the list
                stdList=basicList;
                stdList(supToggleRow,:)=0;
                finalList=[basicList stdList];
            end
            
        case '11'% BasicList contains precursor+suppressor conditions.
            % add the precursor condition
            preList=basicList;
            preList(supToggleRow,:)=0; % remove the suppressor
            
            %add the suppressor condition
            supList=basicList;
            supList(preToggleRow,:)=0; % remove the precursor
            
            if get(handles.noStdToggle,'Value')% put in empty array if not adding standard condition
                stdList=[];
                
            else % add the standard condition to the list
                stdList=basicList;
                stdList(preToggleRow,:)=0;
                stdList(supToggleRow,:)=0;
            end
            
            if get(handles.noCombToggle,'Value')% remove the combined precursor/suppressor condition if user selects to do so.
                finalList=[preList supList stdList];
            else
                finalList=[basicList preList supList stdList];
            end
            
        otherwise
            error('precursor/suppressor selection not recognized...');
    end
    
    finalList=num2cell(finalList);
    
    % Prepare rows for a table to be presented to the user.  The table will
    % display the conditions as columns and the parameter values for each
    % condition in the rows.
    
    if handles.stimParams.trackTarget
        r01_02=finalList(1:2,:);
        r03_03=repmat({handles.stimParams.preType},size(finalList,2),1)'; % adds conditions that were removed earlier (preType)
        r04_08=finalList(3:7,:);
        r09_09=repmat({handles.stimParams.maskerType},size(finalList,2),1)'; % adds conditions that were removed earlier (maskerType)
        r10_10=repmat({handles.stimParams.maskerSig},size(finalList,2),1)'; % adds conditions that were removed earlier (masker Sig)
        r11_18=finalList(8:15,:);
        
        % add the starting target levels here...
        r19_19=num2cell([finalList{14,:}]+handles.startSNR);
        r20_30=finalList(16:size(finalList,1),:);
        tblbody=[r01_02;r03_03;r04_08;r09_09;r10_10;r11_18;r19_19;r20_30];
    else
        r01_02=finalList(1:2,:);
        r03_03=repmat({handles.stimParams.preType},size(finalList,2),1)'; % adds conditions that were removed earlier (preType)
        r04_08=finalList(3:7,:);
        r09_09=repmat({handles.stimParams.maskerType},size(finalList,2),1)'; % adds conditions that were removed earlier (maskerType)
        r10_10=repmat({handles.stimParams.maskerSig},size(finalList,2),1)'; % adds conditions that were removed earlier (masker Sig)
        r11_16=finalList(8:13,:);
        
        % add the masker starting masker levels here...
        r17_17=num2cell([finalList{15,:}]+handles.startSNR);
        r18_30=finalList(14:size(finalList,1),:);
        tblbody=[r01_02;r03_03;r04_08;r09_09;r10_10;r11_16;r17_17;r18_30];
    end
    
    colnameprefix=repmat('cond #',size(tblbody,2),1);
    colnamepostfix=num2str([1:1:size(tblbody,2)]');
    tblcolnames=[colnameprefix colnamepostfix];
    
    %-------------------------------------------------------------------------%
    %display the table and allow the user to review the conditions before saving
    %-------------------------------------------------------------------------%
    
    f1=figure;
    set(f1,'Name','Close this figure to continue...');
    set(f1,'Units','Normalized','Position',[0.0063    0.3086    0.9789    0.5498]);
    t1=uitable(f1,'Data',tblbody,'ColumnName',tblcolnames,'RowName',tblheader,'Units','Normalized','Position',[.05 .01 .9 .99]);
    
    % uitable will not allow cell arrays to be presented in an individual
    % table cell.  Since maskerCutoffs is a cell array, these values cannot
    % be presented in the main table.  A workaround was to create an
    % individual table for the maskerCutoffs (below)
    
    if handles.stimParams.notchToggle
        % create a table to display the maskerCutoffs
        mCutOffsRow=~logical(cellfun('isempty',strfind(tblheader,'tempMaskerCutoffs')));
        ntchIndx=[1:1:length(handles.stimParams.maskerFreq)]';
        ntchtblrow=num2str(ntchIndx);
        ntchtblcol={'LowBandRemote' 'LowBandAdjacent' 'HighBandAdjacent' 'HighBandRemote'};
        ntchtbldata=cell2mat(handles.stimParams.maskerCutoffs);
        f2=figure;
        set(f2,'Name','Notch index rule...');
        set(f2,'Units','Normalized','Position',[0.0063    0.1553    0.3461    0.1094]);
        t2=uitable(f2,'Data',ntchtbldata,'ColumnName',ntchtblcol,'RowName',ntchtblrow,'Units','Normalized','Position',[.05 .01 .9 .99]);
        
        for nf=1:size(tblbody,2)
            tblbody{mCutOffsRow,nf}=handles.stimParams.maskerCutoffs{tblbody{mCutOffsRow,nf}};
        end
    else
        tblbody(mCutOffsRow,:)=repmat({[0 0 0 0]},1,size(tblbody,2));
    end
    
    msgbox('Close the table(s) to continue...'); % prompt the user to close the table to continue
    % - close the figure...
    waitfor(f1); % wait for the user to close the table
    
    
    ExptInfo.nStoreBlocks=handles.nReps; %(always run two consecutive repetitions of each condition)
    
    % make a directory and write the condition files
    DataPath=[cd '\Data\'];
    SubjPath=[DataPath handles.subID '\'];
    mkdir(DataPath,handles.subID);
    mkdir(SubjPath,'TestFiles');
    mkdir(SubjPath,'DataFiles');
    
    % make a structure to hold information about the experiment
    ExptInfo.subID=handles.subID;
    ExptInfo.SubjPath=SubjPath;
    ExptInfo.tblheader=tblheader;
    ExptInfo.tblcolnames=tblcolnames;
    ExptInfo.fnames=cell(size(tblbody,2),1); % holds the .txt filenames that will be created for each condition
    ExptInfo.fcompleteYN=zeros(size(tblbody,2),1); % toggle that indicates if a condition has been completed by the subject
    rand('seed', sum(100*clock)); % seed the clock to get a unique randomization for each subject
    
    %%% Sept. 20th, 2012 --- revise randomization to block by two experiment
    %%% parameters.  Put the name of the parameters in the strings shown in
    %%% the next two rows
    p1row=strcmp(tblheader,'targetFreq');
    p2row=strcmp(tblheader,'delay');
    
    [p1vals p1indx1 p1indx2]=unique(cell2mat(tblbody(p1row,:))); % p1indx2 returns a array the same length as tblbody that contains a unique number for each unique value of p1
    [p2vals p2indx1 p2indx2]=unique(cell2mat(tblbody(p2row,:)));
    forder={};
    for p1=1:length(p1vals)
        p1eqindx=find(p1indx2==p1);  % extract the indices corresponding to the current level of the first parameter
        for p2=1:length(p2vals)
            p2eqlog=logical(p2indx2(p1eqindx)==p2); % extract sub-blocks for the second parameters
            cond4rand=p1eqindx(p2eqlog);
            if length(cond4rand)<=1
                randsubblock=cond4rand;
            else
                randsubblockord=randperm(length(cond4rand));
                randsubblock=cond4rand(randsubblockord);
                % randsubblock=randsample(cond4rand,length(cond4rand)); %
                % code above replaced with randperm 7-20-2015
            end
            forder=[forder randsubblock]; % save the subblocks
        end
    end
    
    if length(p1vals)==1 || length(p2vals)==1 % make a special case when one of the parameters only contains one value
        randblockfinal=randperm(length(forder))';
        % randblockfinal=randsample(length(forder),length(forder)); % only need to randomize the parameter with more than one value
        % code above replaced with randperm 7-20-2015
    else % both parameters have more than one value each
        %randblockp1=randsample(1:length(p1vals),length(p1vals));
        %randblockp2=randsample(length(p1vals)+1:length(p1vals)+length(p2vals),length(p2vals));
        %code above replaced with randperm 7-20-2015
        randblockp1=randperm(length(p1vals));        
        remblocks=length(p1vals)+1:length(p1vals)+length(p2vals);
        remblocksord=randperm(length(remblocks));
        randblockp2=remblocks(remblocksord);
        randblock=[{randblockp1} {randblockp2}]; % randomize the subblocks
        randpos=randperm(length(randblock));
        %randpos=randsample(length(randblock),length(randblock)); % randomize the blocks
        %code above replaced with randperm on 7-20-15
        randblockfinal=[randblock{randpos}];
    end
    
    forder=forder(randblockfinal);
    forder=[forder{:}]; % the final order of the conditions blocked by parameters 1 and 2.
    
    ExptInfo.forder=forder; % save the randomization.
    % ExptInfo.forder=randsample(size(tblbody,2),size(tblbody,2)); % randomize the conditions and save a vector of the randomized condition numbers
    ExptInfo.Name=[handles.subID 'ExptInfo']; % name of the file containing information about the experiment
    ExptInfo.Table=tblbody; % body of the table displayed to the user
    ExptInfo.Thresholds=zeros(ExptInfo.nStoreBlocks,size(tblbody,2)); % initialize an array to hold the thresholds
    ExptInfo.StdDev=zeros(ExptInfo.nStoreBlocks,size(tblbody,2)); % initialize an array to hold the standard deviation
    
    
    
    % remove tempMaskerCutoffs fields and replace with maskerCutoffs to
    % ensure that the correct field values are written to the .txt files
    tblheader{mCutOffsRow}='maskerCutoffs';
    
    % write each file and place in TestFile directory
    for ncond=1:size(tblbody,2)
        % make the file name
        p01=handles.subID;
        p02=num2str(ncond);
        handles.paramsFile=[p01 '_' p02 '.txt'];
        ExptInfo.fnames{ncond}=handles.paramsFile;
        
        % redefine handles.stimParams to reflect the current parameter set
        for nflds=1:length(tblheader)
            eval(['handles.stimParams.' tblheader{nflds} '=tblbody{nflds,ncond};']);
        end
        
        % write the file
        write_parameters(handles,[SubjPath 'TestFiles']);
    end
    
    % save the structure containing experiment info.
    save([SubjPath ExptInfo.Name],'ExptInfo');
    
else
end

guidata(hObject, handles);
guidata(gcf,handles);
uiresume;

function targetLevel_Callback(hObject, eventdata, handles)
% hObject    handle to targetLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sLevelInput=get(hObject,'String');

if handles.stimParams.trackTarget
    % inputed value is the start SNR
    if length(str2num(sLevelInput))>1
        display('SNR must be a scalar.  Try again!');
        return;
    else
    end
    handles.startSNR=str2num(sLevelInput);
    currMaskLvl=handles.stimParams.maskerLevel;
    newTargetLvl=currMaskLvl+str2num(sLevelInput);
    targetLvlSTR=[num2str(newTargetLvl) repmat(',',length(newTargetLvl),1)];
    targetLvlSTR=reshape(targetLvlSTR',1,numel(targetLvlSTR));
    targetLevel=targetLvlSTR(1:end-1);
else
    % input is a new target Level need to set masker level based on SNR
    targetLevel=sLevelInput;
    targetLevelNUM=[str2num(targetLevel)]';
    maskerLevelNUM=targetLevelNUM+handles.startSNR;
    maskerLvlSTR=[num2str(maskerLevelNUM) repmat(',',length(maskerLevelNUM),1)];
    maskerLvlSTR=reshape(maskerLvlSTR',1,numel(maskerLvlSTR));
    maskerLevel=maskerLvlSTR(1:end-1);
    handles.stimParams.maskerLevel=setStimParam(maskerLevel);
    
end

handles.stimParams.targetLevel=setStimParam(targetLevel);
guidata(hObject, handles);
display([handles.stimParams.targetLevel handles.stimParams.maskerLevel]);


% --- Executes during object creation, after setting all properties.
function targetLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to targetLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function targetDuration_Callback(hObject, eventdata, handles)
% hObject    handle to targetDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sDurationInput=get(hObject,'String');
handles.stimParams.targetDur=setStimParam(sDurationInput);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function targetDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to targetDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function targetFrequency_Callback(hObject, eventdata, handles)
% hObject    handle to targetFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sFrequencyInput=get(hObject,'String');
handles.stimParams.targetFreq=setStimParam(sFrequencyInput);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function targetFrequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to targetFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function targetRamp_Callback(hObject, eventdata, handles)
% hObject    handle to targetRamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sRampInput=get(hObject,'String');
handles.stimParams.targetRamp=setStimParam(sRampInput);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function targetRamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to targetRamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function targetDelay_Callback(hObject, eventdata, handles)
% hObject    handle to targetDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sDelayInput=get(hObject,'String');
handles.stimParams.delay=setStimParam(sDelayInput);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function targetDelay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to targetDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskerLevel_Callback(hObject, eventdata, handles)
% hObject    handle to maskerLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mLevelInput=get(hObject,'String');

if handles.stimParams.trackTarget
    % input is a new masker Level need to set target level based on SNR
    maskerLevel=mLevelInput;
    maskerLevelNUM=[str2num(maskerLevel)]';
    targetLevelNUM=maskerLevelNUM+handles.startSNR;
    targetLvlSTR=[num2str(targetLevelNUM) repmat(',',length(targetLevelNUM),1)];
    targetLvlSTR=reshape(targetLvlSTR',1,numel(targetLvlSTR));
    targetLevel=targetLvlSTR(1:end-1);
    handles.stimParams.targetLevel=setStimParam(targetLevel);
    
else
    % inputed value is the start SNR
    if length(str2num(mLevelInput))>1
        display('SNR must be a scalar.  Try again!');
        return;
    else
    end
    handles.startSNR=str2num(mLevelInput);
    currTargetLvl=handles.stimParams.targetLevel;
    newMaskerLvl=currTargetLvl+str2num(mLevelInput);
    maskerLvlSTR=[num2str(newMaskerLvl) repmat(',',length(newMaskerLvl),1)];
    maskerLvlSTR=reshape(maskerLvlSTR',1,numel(maskerLvlSTR));
    maskerLevel=maskerLvlSTR(1:end-1);
end


handles.stimParams.maskerLevel=setStimParam(maskerLevel);
guidata(hObject, handles);
display([handles.stimParams.targetLevel handles.stimParams.maskerLevel]);

% --- Executes during object creation, after setting all properties.
function maskerLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskerLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskerDuration_Callback(hObject, eventdata, handles)
% hObject    handle to maskerDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mDurationInput=get(hObject,'String');
handles.stimParams.maskerDur=setStimParam(mDurationInput);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maskerDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskerDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function handles=maskerFrequency_Callback(hObject, eventdata, handles)
% hObject    handle to maskerFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mFrequencyInput=get(hObject,'String');
handles.stimParams.maskerFreq=setStimParam(mFrequencyInput);
mTypeObj=get(handles.mTypePanel,'SelectedObject');
mTypeString=get(mTypeObj,'String');

%-------------------------------------------------------------------------%
% make the appropriate masker cutoffs for the normalized notch widths entered
%-------------------------------------------------------------------------%
if strcmp(mTypeString,'Ntch Noise')
    handles.stimParams.maskerCutoffs=cell(length(handles.stimParams.maskerFreq),1);
    
    if handles.stimParams.targetFreq>1000 % use 1000 Hz BW if target frequency is greater than 1000 Hz
        BW=1000;
    else
        BW=floor(handles.stimParams.targetFreq/2); % use 1/2*target freq bandwidth if target frqeuency is less than 1000 Hz
    end
    
    for nNW=1:length(handles.stimParams.maskerFreq)
        LowBandAdjacent=handles.stimParams.targetFreq-handles.stimParams.targetFreq*handles.stimParams.maskerFreq(nNW);
        HighBandAdjacent=handles.stimParams.targetFreq+handles.stimParams.targetFreq*handles.stimParams.maskerFreq(nNW);
        LowBandRemote=LowBandAdjacent-BW;
        HighBandRemote=HighBandAdjacent+BW;
        handles.stimParams.maskerCutoffs{nNW}=[LowBandRemote LowBandAdjacent HighBandAdjacent HighBandRemote];
    end
    
else
end


guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maskerFrequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskerFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskerRamp_Callback(hObject, eventdata, handles)
% hObject    handle to maskerRamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mRampInput=get(hObject,'String');
handles.stimParams.maskerRamp=setStimParam(mRampInput);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maskerRamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskerRamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function precursorLevel_Callback(hObject, eventdata, handles)
% hObject    handle to precursorLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of precursorLevel as text
%        str2double(get(hObject,'String')) returns contents of precursorLevel as a double

pLevelInput=get(hObject,'String');
handles.stimParams.preLevel=setStimParam(pLevelInput);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function precursorLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to precursorLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function precursorDuration_Callback(hObject, eventdata, handles)
% hObject    handle to precursorDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pDurationInput=get(hObject,'String');
handles.stimParams.preDur=setStimParam(pDurationInput);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function precursorDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to precursorDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function precursorFrequency_Callback(hObject, eventdata, handles)
% hObject    handle to precursorFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pFrequencyInput=get(hObject,'String');
handles.stimParams.preFreq=setStimParam(pFrequencyInput);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function precursorFrequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to precursorFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function precursorRamp_Callback(hObject, eventdata, handles)
% hObject    handle to precursorRamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pRampInput=get(hObject,'String');
handles.stimParams.preRamp=setStimParam(pRampInput);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function precursorRamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to precursorRamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function precursorDelay_Callback(hObject, eventdata, handles)
% hObject    handle to precursorDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pDelayInput=get(hObject,'String');
handles.stimParams.preDelay=setStimParam(pDelayInput);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function precursorDelay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to precursorDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in preToggle.
function preToggle_Callback(hObject, eventdata, handles)
% hObject    handle to preToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=setPanels(handles);
handles.stimParams.preToggle=get(hObject,'Value');
guidata(hObject, handles);

% --- Executes on button press in suppToggle.
function suppToggle_Callback(hObject, eventdata, handles)
% hObject    handle to suppToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=setPanels(handles);
handles.stimParams.supToggle=get(hObject,'Value');
guidata(hObject, handles);

% --- Executes on button press in hpToggle.
function hpToggle_Callback(hObject, eventdata, handles)
% hObject    handle to hpToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.stimParams.hpMaskerToggle=get(hObject,'Value');
guidata(hObject,handles);

% --- Executes on button press in trackTargetYN.
function trackTargetYN_Callback(hObject, eventdata, handles)
% hObject    handle to trackTargetYN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.stimParams.trackTarget=get(hObject,'Value');

if get(hObject,'Value')
    % get the current masker level and convert to string to display in GUI
    currMaskLvl=handles.stimParams.maskerLevel;
    maskerLvlSTR=[num2str(currMaskLvl) repmat(',',length(currMaskLvl),1)];
    maskerLvlSTR=reshape(maskerLvlSTR',1,numel(maskerLvlSTR));
    maskerLevel=maskerLvlSTR(1:end-1);
    
    % calculate target start levels based on startSNR value
    newTargetLvl=currMaskLvl+handles.startSNR;
    targetLvlSTR=[num2str(newTargetLvl) repmat(',',length(newTargetLvl),1)];
    targetLvlSTR=reshape(targetLvlSTR',1,numel(targetLvlSTR));
    targetLevel=targetLvlSTR(1:end-1);
    
    % update GUI items
    set(handles.tNameLevel,'String','InitLvl SNR');
    set(handles.mNameLevel,'String','Level');
    set(handles.targetLevel,'String',num2str(handles.startSNR));
    set(handles.maskerLevel,'String',maskerLevel);
    handles.stimParams.targetLevel=setStimParam(targetLevel);
else
    % get the current target level and convert to string to display in GUI
    currTargetLevel=handles.stimParams.targetLevel;
    targetLvlSTR=[num2str(currTargetLevel) repmat(',',length(currTargetLevel),1)];
    targetLvlSTR=reshape(targetLvlSTR',1,numel(targetLvlSTR));
    targetLevel=targetLvlSTR(1:end-1);
    
    % calculate masker start levels based on startSNR value
    newMaskLvl=currTargetLevel+handles.startSNR;
    maskLvlSTR=[num2str(newMaskLvl) repmat(',',length(newMaskLvl),1)];
    maskLvlSTR=reshape(maskLvlSTR',1,numel(maskLvlSTR));
    maskerLevel=maskLvlSTR(1:end-1);
    
    % update GUI items
    set(handles.tNameLevel,'String','Level');
    set(handles.mNameLevel,'String','InitLvl SNR');
    set(handles.maskerLevel,'String',num2str(handles.startSNR));
    set(handles.targetLevel,'String',num2str(targetLevel));
    handles.stimParams.maskerLevel=setStimParam(maskerLevel);
end

guidata(hObject,handles);
display([handles.stimParams.targetLevel handles.stimParams.maskerLevel]);

function suppressorLevel_Callback(hObject, eventdata, handles)
% hObject    handle to suppressorLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

suppLevelInput=get(hObject,'String');
handles.stimParams.supLevel=setStimParam(suppLevelInput);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function suppressorLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to suppressorLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function suppressorDuration_Callback(hObject, eventdata, handles)
% hObject    handle to suppressorDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

suppDelayInput=get(hObject,'String');
handles.stimParams.supDelay=setStimParam(suppDelayInput);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function suppressorDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to suppressorDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function suppressorFrequency_Callback(hObject, eventdata, handles)
% hObject    handle to suppressorFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

suppFrequencyInput=get(hObject,'String');
handles.stimParams.supFreq=setStimParam(suppFrequencyInput);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function suppressorFrequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to suppressorFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function suppressorRamp_Callback(hObject, eventdata, handles)
% hObject    handle to suppressorRamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

suppRampInput=get(hObject,'String');
handles.stimParams.supRamp=setStimParam(suppRampInput);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function suppressorRamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to suppressorRamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function suppressorDelay_Callback(hObject, eventdata, handles)
% hObject    handle to suppressorDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

suppDelayInput=get(hObject,'String');
handles.stimParams.supDelay=setStimParam(suppDelayInput);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function suppressorDelay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to suppressorDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in mTypePanel.
function mTypePanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in mTypePanel
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

h_selected=get(handles.mTypePanel,'SelectedObject');
h_noiseButton=handles.mNoiseButton;
h_NNoiseButton=handles.mNNoiseButton;
h_toneButton=handles.mToneButton;

if h_selected==h_NNoiseButton
    set(handles.maskerFrequency,'Enable','on');
    maskerFrequency='0.0';
    set(handles.maskerFrequency,'String',maskerFrequency);
    set(handles.mNameFrequency,'String','Notch Width');
    set(handles.mUnitsFrequency,'String','nrmlzd');
    handles.stimParams.maskerSig='noise';
    handles.stimParams.notchToggle=1;
    handles=maskerFrequency_Callback(handles.maskerFrequency,eventdata,handles);
elseif h_selected==h_noiseButton
    maskerFrequency='0.0';
    set(handles.maskerFrequency,'String','BB Noise ');
    set(handles.mNameFrequency,'String',' ');
    set(handles.mUnitsFrequency,'String',' ');
    set(handles.maskerFrequency,'Enable','off');
    handles.stimParams.maskerSig='noise';
    handles.stimParams.notchToggle=0;
else
    set(handles.maskerFrequency,'Enable','on');
    targetFrequency=handles.stimParams.targetFreq;
    maskerFrequency=[num2str(targetFrequency/2) ',' num2str(targetFrequency)];
    set(handles.maskerFrequency,'String',maskerFrequency);
    set(handles.mNameFrequency,'String','Frequency');
    set(handles.mUnitsFrequency,'String','Hz');
    handles.stimParams.maskerSig='tone';
    handles.stimParams.notchToggle=0;
end

handles.stimParams.maskerFreq=setStimParam(maskerFrequency);
guidata(hObject,handles);

% --- Executes when selected object is changed in pTypePanel.
function pTypePanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in pTypePanel
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

h_selected=get(handles.pTypePanel,'SelectedObject');
h_noiseButton=handles.pNoiseButton;

if h_selected==h_noiseButton
    precursorFrequency='0.0';
    set(handles.precursorFrequency,'String','BB Noise');
    set(handles.pNameFrequency,'String',' ');
    set(handles.pUnitsFrequency,'String',' ');
    set(handles.precursorFrequency,'Enable','off');
    handles.stimParams.preType='noise';
else
    set(handles.precursorFrequency,'Enable','on');
    precursorFrequency=num2str(handles.stimParams.targetFreq);
    handles.stimParams.preType='tone';
    set(handles.precursorFrequency,'String',precursorFrequency);
    set(handles.pNameFrequency,'String','Frequency');
    set(handles.pUnitsFrequency,'String','Hz');
end

handles.stimParams.preFreq=setStimParam(precursorFrequency);
guidata(hObject,handles);

% --- Executes when selected object is changed in mskOptionPanel.
function mskOptionPanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in mskOptionPanel
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
h_selected=get(handles.mskOptionPanel,'SelectedObject');
h_simMskButton=handles.simMaskYN;

if h_selected==h_simMskButton
    handles.stimParams.maskerType='simultaneous';
else
    handles.stimParams.maskerType='for';
end

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function sNameRamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sNameRamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function pTypePanel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pTypePanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in noStdToggle.
function noStdToggle_Callback(hObject, eventdata, handles)
% hObject    handle to noStdToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.excludeStdYN=get(hObject,'Value');
guidata(hObject,handles);

% --- Executes on button press in noCombToggle.
function noCombToggle_Callback(hObject, eventdata, handles)
% hObject    handle to noCombToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.excludeCombYN=get(hObject,'Value');
guidata(hObject,handles);


% --- Executes on button press in setupExptBox.
function setupExptBox_Callback(hObject, eventdata, handles)
% hObject    handle to setupExptBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'Value')
    set(handles.exptSetupPanel,'Visible','on');
    set(handles.exptOptions,'Visible','on');
else
    set(handles.exptSetupPanel,'Visible','off');
    set(handles.exptOptions,'Visible','off');
end

handles.setupExptYN=get(hObject,'Value');

guidata(hObject, handles);


% --------------------------------------------------------------------
function loadPreset_Callback(hObject, eventdata, handles)
% hObject    handle to loadPreset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% check to make sure the path is correct
termfilepath='PsyAcoustX';
currpath=cd;
dirIndx=strfind(currpath,termfilepath);

if length(currpath)-dirIndx(end)+1==length(termfilepath)
    hregSubj=gcf;
    fileLoc=[cd '\UserPresets\'];
    [presetFile,presetDir]=uigetfile(fileLoc);
    presetPath=[presetDir presetFile];
    newGUI=hgload(presetPath);
else
    error('you must be in the PSYACOUS_GUI directory to complete this operation')
end

% update GUI so values are displayed correctly in boxes
% fieldnames(handles)
% set(findall(0,'
guidata(hObject, handles);
uiresume(hregSubj);
delete(hregSubj); % close the "old" version of registerSubject.
uiwait(newGUI);

% --------------------------------------------------------------------
function savePreset_Callback(hObject, eventdata, handles)
% hObject    handle to savePreset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% check to make sure the path is correct
termfilepath='PsyAcoustX';
currpath=cd;
dirIndx=strfind(currpath,termfilepath);

if length(currpath)-dirIndx(end)+1==length(termfilepath)
    fileLoc=[cd '\UserPresets\myPreset.fig'];
    [presetFile,presetDir]=uiputfile(fileLoc);
    presetPath=[presetDir presetFile];
    hgsave(gcf,presetPath)
else
    error('you must be in the PSYACOUS_GUI directory to complete this operation')
end


% --- Executes on slider movement.
function repSlider_Callback(hObject, eventdata, handles)
% hObject    handle to repSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

new_nReps=get(hObject,'Value');
set(findall(0,'tag','displayReps'),'String',{'# reps'; num2str(new_nReps)});
handles.nReps=new_nReps;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function repSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to repSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
close all; clear all; clc;
MaskingGUI;
