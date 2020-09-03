function varargout = testbuttongroup(varargin)
% TESTBUTTONGROUP MATLAB code for testbuttongroup.fig
%      TESTBUTTONGROUP, by itself, creates a new TESTBUTTONGROUP or raises the existing
%      singleton*.
%
%      H = TESTBUTTONGROUP returns the handle to a new TESTBUTTONGROUP or the handle to
%      the existing singleton*.
%
%      TESTBUTTONGROUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTBUTTONGROUP.M with the given input arguments.
%
%      TESTBUTTONGROUP('Property','Value',...) creates a new TESTBUTTONGROUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testbuttongroup_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testbuttongroup_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help testbuttongroup

% Last Modified by GUIDE v2.5 19-Dec-2013 15:29:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testbuttongroup_OpeningFcn, ...
                   'gui_OutputFcn',  @testbuttongroup_OutputFcn, ...
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


% --- Executes just before testbuttongroup is made visible.
function testbuttongroup_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testbuttongroup (see VARARGIN)

% Choose default command line output for testbuttongroup
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes testbuttongroup wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = testbuttongroup_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in buttongrouppanel.
function buttongrouppanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in buttongrouppanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
