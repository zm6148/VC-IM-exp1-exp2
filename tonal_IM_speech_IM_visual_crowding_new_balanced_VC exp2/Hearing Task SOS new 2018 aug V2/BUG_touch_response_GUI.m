function varargout = BUG_touch_response_GUI(varargin)
% BUG_TOUCH_RESPONSE_GUI M-file for BUG_touch_response_GUI.fig
%      BUG_TOUCH_RESPONSE_GUI, by itself, creates a new BUG_TOUCH_RESPONSE_GUI or raises the existing
%      singleton*.
%
%      H = BUG_TOUCH_RESPONSE_GUI returns the handle to a new BUG_TOUCH_RESPONSE_GUI or the handle to
%      the existing singleton*.
%
%      BUG_TOUCH_RESPONSE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BUG_TOUCH_RESPONSE_GUI.M with the given input arguments.
%
%      BUG_TOUCH_RESPONSE_GUI('Property','Value',...) creates a new BUG_TOUCH_RESPONSE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BUG_touch_response_GUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BUG_touch_response_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BUG_touch_response_GUI

% Last Modified by GUIDE v2.5 29-Oct-2009 07:56:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BUG_touch_response_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @BUG_touch_response_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

% if nargout
     [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
% else
%    gui_mainfcn(gui_State, varargin{:});
% end
% End initialization code - DO NOT EDIT


% --- Executes just before BUG_touch_response_GUI is made visible.
function BUG_touch_response_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BUG_touch_response_GUI (see VARARGIN)

% Choose default command line output for BUG_touch_response_GUI
handles.output = hObject;

%Grab the operation flag from single user input:
%-----------------------------------------------
handles.op_flag = varargin{1};
handles.order_flag = varargin{2};
handles.text_string = varargin{3};
handles.display_mode = varargin{4};
handles.gui_name = varargin{5};
feedback = varargin{6};

%Maximize window:
%----------------
set(handles.figure1,'Name',handles.gui_name)

%Generate button matrix list:
%----------------------------
handles.button_list=zeros(5,8); %5 catgories with 8 choices per catagory
handles.button_presses =[];

%Reset all buttons:
%------------------
for n_col = 1:5
    clear_button_colors(n_col,hObject, eventdata, handles)
end

%Set info text string:
%---------------------
set(handles.info_text,'String',handles.text_string)

%Set display mode:
%-----------------
if strcmp(handles.display_mode,'light')
    set(get(handles.figure1,'children'),'BackgroundColor','w','ForegroundColor','k')
    set(handles.figure1,'Color','w')    
elseif strcmp(handles.display_mode,'dark')
    set(get(handles.figure1,'children'),'BackgroundColor','k','ForegroundColor','w')
    set(handles.figure1,'Color','k')
end

% Update handles structure
guidata(hObject, handles);

feedback_children_index = 2:6;
button_children_index = 8:47;

switch handles.op_flag
    case 'vis'
        vis_flag = get(handles.figure1,'Visible');
        switch vis_flag
            case 'off'
                set(handles.figure1,'Visible','on')
            case 'on'
                set(handles.figure1,'Visible','off')
        end
    case 'trial'
        set(get(handles.figure1,'children'),'Visible','on')
        children_list = get(handles.figure1,'children');
        set(children_list(feedback_children_index),'Visible','off')
        set(children_list(button_children_index),'Enable','on')
        set(handles.start_button,'visible','off')
        set(handles.continue_button,'Visible','off')
        uiwait(handles.figure1); %wait for subject reponse
    case 'reset'
        uiresume(handles.figure1); %clear the outputs
    case 'hide'
        children_list = get(handles.figure1,'children');
        set(children_list,'Visible','off');
        set(handles.info_text,'Visible','on');
    case 'show'
        children_list = get(handles.figure1,'children');
        set(children_list,'Visible','on');
        set(handles.info_text,'Visible','on');
        set(children_list(feedback_children_index),'Visible','off')
        set(children_list(button_children_index),'Enable','off')
        set(handles.start_button,'visible','off')
        set(handles.continue_button,'Visible','off')
    case 'start'
        set(get(handles.figure1,'children'),'visible','off');
        set(handles.start_button,'visible','on')
        set(handles.info_text,'Visible','on');
        uiwait(handles.figure1)
    case 'feedback'
        children_list = get(handles.figure1,'children');
        set(handles.info_text,'Visible','off')
        set(children_list(feedback_children_index),'Visible','on')
        set(children_list(button_children_index),'Enable','off')
        set(handles.continue_button,'Visible','off')
        set(handles.start_button,'Visible','off')
        for n_word = 1:5
            eval(['set(handles.t',num2str(n_word),',''String'',feedback.target{n_word})'])
            if strcmp(feedback.target{n_word},feedback.response{n_word})
                eval(['set(handles.t',num2str(n_word),',''BackgroundColor'',[0 .75 0])']) %if correct, make green
            else
                eval(['set(handles.t',num2str(n_word),',''BackgroundColor'',[.75 0 0])']) %if incorrect, make red
            end
        end
        pause(.6);
        %uiwait(handles.figure1,.05) %limited wait (second argument) 
    case 'wait'
        set(get(handles.figure1,'children'),'visible','off');
        set(handles.info_text,'Visible','on');
        uiwait(handles.figure1)
end

% --- Outputs from this function are returned to the command line.
function varargout = BUG_touch_response_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% Get default command line output from handles structure
if strcmp(handles.op_flag,'trial')
    varargout{1} = handles.button_list;
    varargout{2} = handles.button_presses;
elseif strcmp(handles.op_flag,'hide')
    varargout{1} = handles.figure1;
elseif strcmp(handles.op_flag,'close')
    delete(handles.figure1);
end

% --- Executes on button press in B11.
function B11_Callback(hObject, eventdata, handles)
% hObject    handle to B11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B12.
function B12_Callback(hObject, eventdata, handles)
% hObject    handle to B12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in B13.
button_update(hObject, eventdata, handles)

function B13_Callback(hObject, eventdata, handles)
% hObject    handle to B13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B14.
function B14_Callback(hObject, eventdata, handles)
% hObject    handle to B14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B15.
function B15_Callback(hObject, eventdata, handles)
% hObject    handle to B15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B16.
function B16_Callback(hObject, eventdata, handles)
% hObject    handle to B16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B17.
function B17_Callback(hObject, eventdata, handles)
% hObject    handle to B17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B18.
function B18_Callback(hObject, eventdata, handles)
% hObject    handle to B18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B21.
function B21_Callback(hObject, eventdata, handles)
% hObject    handle to B21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B22.
function B22_Callback(hObject, eventdata, handles)
% hObject    handle to B22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B23.
function B23_Callback(hObject, eventdata, handles)
% hObject    handle to B23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B24.
function B24_Callback(hObject, eventdata, handles)
% hObject    handle to B24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B25.
function B25_Callback(hObject, eventdata, handles)
% hObject    handle to B25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B26.
function B26_Callback(hObject, eventdata, handles)
% hObject    handle to B26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in B27.
button_update(hObject, eventdata, handles)

function B27_Callback(hObject, eventdata, handles)
% hObject    handle to B27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B28.
function B28_Callback(hObject, eventdata, handles)
% hObject    handle to B28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B31.
function B31_Callback(hObject, eventdata, handles)
% hObject    handle to B31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B32.
function B32_Callback(hObject, eventdata, handles)
% hObject    handle to B32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B33.
function B33_Callback(hObject, eventdata, handles)
% hObject    handle to B33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B34.
function B34_Callback(hObject, eventdata, handles)
% hObject    handle to B34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B35.
function B35_Callback(hObject, eventdata, handles)
% hObject    handle to B35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B36.
function B36_Callback(hObject, eventdata, handles)
% hObject    handle to B36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B37.
function B37_Callback(hObject, eventdata, handles)
% hObject    handle to B37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B38.
function B38_Callback(hObject, eventdata, handles)
% hObject    handle to B38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B41.
function B41_Callback(hObject, eventdata, handles)
% hObject    handle to B41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B42.
function B42_Callback(hObject, eventdata, handles)
% hObject    handle to B42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B43.
function B43_Callback(hObject, eventdata, handles)
% hObject    handle to B43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B44.
function B44_Callback(hObject, eventdata, handles)
% hObject    handle to B44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B45.
function B45_Callback(hObject, eventdata, handles)
% hObject    handle to B45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B46.
function B46_Callback(hObject, eventdata, handles)
% hObject    handle to B46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B47.
function B47_Callback(hObject, eventdata, handles)
% hObject    handle to B47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B48.
function B48_Callback(hObject, eventdata, handles)
% hObject    handle to B48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B51.
function B51_Callback(hObject, eventdata, handles)
% hObject    handle to B51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B52.
function B52_Callback(hObject, eventdata, handles)
% hObject    handle to B52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B53.
function B53_Callback(hObject, eventdata, handles)
% hObject    handle to B53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B54.
function B54_Callback(hObject, eventdata, handles)
% hObject    handle to B54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B55.
function B55_Callback(hObject, eventdata, handles)
% hObject    handle to B55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B56.
function B56_Callback(hObject, eventdata, handles)
% hObject    handle to B56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B57.
function B57_Callback(hObject, eventdata, handles)
% hObject    handle to B57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

% --- Executes on button press in B58.
function B58_Callback(hObject, eventdata, handles)
% hObject    handle to B58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_update(hObject, eventdata, handles)

%% Start and Continue buttons:
%  ---------------------------

% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.start_button,'visible','off')
uiresume(handles.figure1);

% --- Executes on button press in continue_button.
function continue_button_Callback(hObject, eventdata, handles)
% hObject    handle to continue_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

children_list = get(handles.figure1,'children');
set(handles.info_text,'Visible','off')
uiresume(handles.figure1);

%% BUTTON UPDATE FUNCTIONS
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%Clear button colors
%-------------------
%Clears all previous button color reponses

function clear_button_colors(n_col,hObject, eventdata, handles)

for n_button = 1:8
    button_col = n_col;
    button_row = n_button;
    button_name = ['B',num2str(button_col),num2str(button_row)];
    if strcmp(handles.display_mode,'light')
        eval(['set(handles.',button_name,',''BackGroundColor'',''w'',''ForeGroundColor'',''k'')'])
    else
        eval(['set(handles.',button_name,',''BackGroundColor'',''k'',''ForeGroundColor'',''w'')'])
    end
end
%--------------------------------------------------------------------------

%Set button color
%----------------
%Sets a single button to on (green)

function set_button_color(button_on_list,hObject, eventdata, handles)

button_place =button_on_list;
button_col = button_place(1);
button_row = button_place(2);
button_name = ['B',num2str(button_col),num2str(button_row)];
eval(['set(handles.',button_name,',''BackGroundColor'',[0  .75 0],''ForeGroundColor'',''w'')'])

%--------------------------------------------------------------------------

%For each button press:
% (1) determine which button was pressed
% (2) check to see which buttons were previously pressed
% (3) if check passes, update the button color response indictor and button
%     reponse list
% (4) if all 5 buttons have been pressed, send an output from the function

function button_update(hObject, eventdata, handles)


%Find the column and row of the current button press
current_tag = get(hObject,'Tag');
n_col = str2num(current_tag(2));
n_row = str2num(current_tag(3));

%Check to see if the preceding button columns were selected
if strcmp(handles.order_flag,'on');
    button_col_check = sum(handles.button_list,2);
    
    if length(find(button_col_check(1:n_col-1)>0))==n_col-1
        handles.button_presses = [handles.button_presses ;n_col n_row];
        handles.button_list(n_col,:)=handles.button_list(n_col,:)*0; %clear previous button presses for current column

        %Shift button previous button press down if current column selection
        %contained an older button press:
        current_list = unique(handles.button_list);
        gap_list = 1:max(max(handles.button_list));
        for n_g = gap_list
            if isempty(find(n_g==current_list))
                [nc,nr] =  find(handles.button_list>n_g);
                for nn = 1:length(nc)
                    handles.button_list(nc(nn),nr(nn)) = handles.button_list(nc(nn),nr(nn))-1;
                end
            end
        end
        handles.button_list(n_col,n_row)=max(max(handles.button_list))+1; %store response
        if max(max(handles.button_list))==5
            uiresume(handles.figure1);
        end
        clear_button_colors(n_col,hObject, eventdata, handles) %clear all previous button in current column
        set_button_color([n_col n_row],hObject, eventdata, handles) %set the current button press color to on
        guidata(hObject, handles);

        process_flag = 1;
    end
elseif strcmp(handles.order_flag,'off');
    handles.button_presses = [handles.button_presses ;n_col n_row];
    handles.button_list(n_col,:)=handles.button_list(n_col,:)*0; %clear previous button presses for current column

    %Shift button previous button press down if current column selection
    %contained an older button press:
    current_list = unique(handles.button_list);
    gap_list = 1:max(max(handles.button_list));
    for n_g = gap_list
        if isempty(find(n_g==current_list))
            [nc,nr] =  find(handles.button_list>n_g);
            for nn = 1:length(nc)
                handles.button_list(nc(nn),nr(nn)) = handles.button_list(nc(nn),nr(nn))-1;
            end
        end
    end
    handles.button_list(n_col,n_row)=max(max(handles.button_list))+1; %store response
    if max(max(handles.button_list))==5
        uiresume(handles.figure1);
    end
    clear_button_colors(n_col,hObject, eventdata, handles) %clear all previous button in current column
    set_button_color([n_col n_row],hObject, eventdata, handles) %set the current button press color to on
    guidata(hObject, handles);
elseif strcmp(handles.order_flag,'random');
    handles.button_presses = [handles.button_presses ;n_col n_row];
    handles.button_list(n_col,n_row)=max(max(handles.button_list))+1; %store response
    if max(max(handles.button_list))==5
        uiresume(handles.figure1);
    end
    set_button_color([n_col n_row],hObject, eventdata, handles); %set the current button press color to on
    guidata(hObject, handles);
end

% --- Executes on key press with focus on figure1 and no controls selected.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(handles.op_flag,'wait')
    if strcmp(get(hObject,'CurrentKey'),'c')
        set(handles.info_text,'Visible','off')
        uiresume(handles.figure1);
    end
end



