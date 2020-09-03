function varargout = runTracker_gap(varargin)
% RUNTRACKER_GAP MATLAB code for runTracker_gap.fig
%      RUNTRACKER_GAP, by itself, creates a new RUNTRACKER_GAP or raises the existing
%      singleton*.
%
%      H = RUNTRACKER_GAP returns the handle to a new RUNTRACKER_GAP or the handle to
%      the existing singleton*.
%
%      RUNTRACKER_GAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUNTRACKER_GAP.M with the given input arguments.
%
%      RUNTRACKER_GAP('Property','Value',...) creates a new RUNTRACKER_GAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before runTracker_gap_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to runTracker_gap_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help runTracker_gap

% Last Modified by GUIDE v2.5 23-Dec-2013 13:56:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @runTracker_gap_OpeningFcn, ...
                   'gui_OutputFcn',  @runTracker_gap_OutputFcn, ...
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


% --- Executes just before runTracker_gap is made visible.
function runTracker_gap_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to runTracker_gap (see VARARGIN)

% Choose default command line output for runTracker_gap
handles.output = hObject;
handles = varargin{1};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%---- Fill in the Stimulus Info. Panel ------%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dispIndx=handles.run.currentBlockNum;
stimFlds=fields(handles.blocks{dispIndx});
stimTypes={'marker' 'bnoise' 'precursor'};
flds2Exclude={};
runningFlds={};
flagExclude=[];

%%% get stimulus info
for nTypes=1:length(stimTypes)
    indx=~logical(cellfun('isempty',strfind(stimFlds,stimTypes{nTypes})));
    flds=stimFlds(indx);
    vals=cell(length(flds),1);
    fldval=cell(length(flds),1);
    for sflds=1:length(flds)
        vals{sflds}=eval(['handles.blocks{dispIndx}.' flds{sflds}]);
        fldval{sflds}=[flds{sflds} '=' num2str(vals{sflds})];
    end
    eval([stimTypes{nTypes} 'Flds=flds;']);
    eval([stimTypes{nTypes} 'Vals=vals;']);
    eval([stimTypes{nTypes} 'Fldval=fldval;']);    
    [excVals,excIndx1,excIndx2]=intersect(flds, flds2Exclude);
    rmvFields=zeros(length(flds),1);
    rmvFields(excIndx1)=1;    
    toggleYN=~logical(cellfun('isempty',strfind(flds,[stimTypes{nTypes} 'Toggle'])));
    if any(toggleYN)
        if any([vals{toggleYN}])
            runningFlds=[runningFlds; fldval];
            flagExclude=[flagExclude; rmvFields];
        else
        end
    else
        runningFlds=[runningFlds; fldval];
        flagExclude=[flagExclude; rmvFields];
    end
end

% form several columns to list the conditions
AllFlds=runningFlds(~flagExclude);
ncols=3;
nrows=ceil(length(AllFlds)/ncols);
idxAllFlds=[1:nrows:length(AllFlds) length(AllFlds)+1];
dispCols=[];
ncols2fill=ceil(length(AllFlds)/nrows);

% create the columns and save in one large character matrix
for icols=1:ncols2fill
    currCol=char(AllFlds(idxAllFlds(icols):idxAllFlds(icols+1)-1));
    if icols==1
        nwspace=0;
    else
        nwspace=3;
    end
    if size(currCol,1)==nrows        
        dispCols=[dispCols repmat(' ',size(currCol,1),nwspace) currCol];
    else
        remRows=nrows-size(currCol,1);
        addwspace=repmat(' ',remRows,size(currCol,2));
        currCol=[currCol; addwspace];
        dispCols=[dispCols repmat(' ',size(currCol,1),nwspace) currCol];
    end
end

set(findall(0,'tag','stimText'),'String',dispCols); % save the character array to display

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%---- Fill in the Subject Info. Panel -----%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

exptYN=handles.stimParams.RunExpt.YN;

if exptYN
    subjFlds={'YN' 'SaveFile' 'SaveDir' 'CondNum'};
    subjVals=cell(length(subjFlds),1);
    subjFldvals=cell(length(subjFlds),1);
    for nsfld=1:length(subjFlds)
        subjVals{nsfld}=handles.stimParams.RunExpt.(subjFlds{nsfld});
        subjFldvals{nsfld}=[subjFlds{nsfld} '=' num2str(subjVals{nsfld})];
    end
    indxYN=~logical(cellfun('isempty',strfind(subjFldvals,'YN=1')));
    subjFldvals{indxYN}=['SubID=' handles.subID];
    dispSubjInfo=char(subjFldvals{:});
    set(findall(0,'tag','sText'),'String',dispSubjInfo);
else
    dispSubjInfo=['SubID=' handles.subID];
    set(findall(0,'tag','sText'),'String',dispSubjInfo);
end

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes runTracker_gap wait for user response (see UIRESUME)
% uiwait(handles.statusFIG);


% --- Outputs from this function are returned to the command line.
function varargout = runTracker_gap_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
