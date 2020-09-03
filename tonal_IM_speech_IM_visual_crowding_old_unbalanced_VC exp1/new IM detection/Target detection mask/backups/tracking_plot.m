function varargout = tracking_plot(varargin)
% TRACKING_PLOT MATLAB code for tracking_plot.fig
%      TRACKING_PLOT, by itself, creates a new TRACKING_PLOT or raises the existing
%      singleton*.
%
%      H = TRACKING_PLOT returns the handle to a new TRACKING_PLOT or the handle to
%      the existing singleton*.
%
%      TRACKING_PLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRACKING_PLOT.M with the given input arguments.
%
%      TRACKING_PLOT('Property','Value',...) creates a new TRACKING_PLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tracking_plot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tracking_plot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tracking_plot

% Last Modified by GUIDE v2.5 28-Sep-2016 14:30:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tracking_plot_OpeningFcn, ...
                   'gui_OutputFcn',  @tracking_plot_OutputFcn, ...
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


% --- Executes just before tracking_plot is made visible.
function tracking_plot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tracking_plot (see VARARGIN)

% Choose default command line output for tracking_plot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tracking_plot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tracking_plot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
