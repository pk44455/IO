function varargout = GUI(varargin)
%GUI MATLAB code file for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('Property','Value',...) creates a new GUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to GUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GUI('CALLBACK') and GUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 09-Jun-2020 08:42:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

conn = database("measurement", "root", "admin");

global id;
id = 1;
global danger_id;
selectquery = "SELECT MAX(Worker_ID) FROM measurement";
global max_id;
max_id = select(conn, selectquery);
max_id = table2array(max_id);
max_id = max_id(1,1);

workers_pulse = cell(1, max_id);
workers_air_pollution = cell(1, max_id);
workers_dust_content = cell(1, max_id);

time_tab = [];

datetime.setDefaultFormats('default','hh:mm:ss')

set(handles.text4, 'String', "Worker ID : " + id);

while true
 
for i=1 : max_id   

selectquery = "SELECT pulse FROM measurement WHERE Worker_ID = " + i;
pulse = select(conn, selectquery);
pulse = table2array(pulse);
pulse_tab = workers_pulse{i};
pulse_tab(end+1) = pulse;
if size(pulse_tab,2) > 200
    pulse_tab = pulse_tab(end-200:end);
end
workers_pulse{i} = pulse_tab;


selectquery = "SELECT air_pollution FROM measurement WHERE Worker_ID = " + i;
air_pollution = select(conn, selectquery);
air_pollution = table2array(air_pollution);
air_pollution_tab = workers_air_pollution{i};
air_pollution_tab(end+1) = air_pollution;
if size(air_pollution_tab,2) > 200
    air_pollution_tab = air_pollution_tab(end-200:end);
end
workers_air_pollution{i} = air_pollution_tab;

selectquery = "SELECT dust_content FROM measurement WHERE Worker_ID = " + i;
dust_content = select(conn, selectquery);
dust_content = table2array(dust_content);
dust_content_tab = workers_dust_content{i};
dust_content_tab(end+1) = dust_content;
if size(dust_content_tab,2) > 200
    dust_content_tab = dust_content_tab(end-200:end);
end
workers_dust_content{i} = dust_content_tab;

end

date = datetime('now');
time = datenum(date);
time_tab(end+1) = time;
if size(time_tab,2) > 200
    time_tab = time_tab(end-200:end);
end

pulse_tab = workers_pulse{id};
air_pollution_tab = workers_air_pollution{id};
dust_content_tab = workers_dust_content{id};

axes(handles.axes1);
level = 200;
pulse_plot = plot(time_tab, workers_pulse{id}, 'g');
hold on
area(time_tab, max(workers_pulse{id}, level), level, 'EdgeColor', 'r', 'FaceColor', 'w')
hold off
title("pulse");
ylim([0 300]);
datetick('x', 'HH:MM:SS');
drawnow;

axes(handles.axes2);
level = 50;
pulse_plot = plot(time_tab, workers_air_pollution{id}, 'g');
hold on
area(time_tab, max(workers_air_pollution{id}, level), level, 'EdgeColor', 'r', 'FaceColor', 'w');
hold off
title("air pollution");
ylim([0 100]);
datetick('x', 'HH:MM:SS')
drawnow;

axes(handles.axes3);
level = 50;
pulse_plot = plot(time_tab, workers_dust_content{id}, 'g');
hold on
area(time_tab, max(workers_dust_content{id}, level), level, 'EdgeColor', 'r', 'FaceColor', 'w')
hold off
title("dust content");
ylim([0 100]);
datetick('x', 'HH:MM:SS')
drawnow;

if size(time_tab,2) > 100
    for i=1 : max_id
        pulse_tab = workers_pulse{i};
        air_pollution_tab = workers_air_pollution{i};
        dust_content_tab = workers_dust_content{i};
        mean(pulse_tab(end-10:end))
        if mean(pulse_tab(end-100:end)) >= 200 || mean(air_pollution_tab(end-100:end)) >= 50 || mean(dust_content_tab(end-100:end)) >= 50
            set(handles.text5, 'visible', 'on', 'ForegroundColor', 'r', 'String', "Attention !!! Worker with ID " + i + " is in danger !!!");
            set(handles.pushbutton2, 'visible', 'on');
            set(handles.pushbutton4, 'visible', 'on');
            set(handles.pushbutton5, 'visible', 'on');
            danger_id = i;
        end  
    end
end

end

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global id;
global max_id;

id = id + 1;
if id == max_id + 1
    id = 1;
end

cla(handles.axes1)
cla(handles.axes2)
cla(handles.axes3)
    
set(handles.text4, 'String', "Worker ID : " + id);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global id;
global danger_id;

id = danger_id;

cla(handles.axes1)
cla(handles.axes2)
cla(handles.axes3)
    
set(handles.text4, 'String', "Worker ID : " + id);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global id;
global max_id;

id = id - 1;
if id == 0
    id = max_id;
end

cla(handles.axes1)
cla(handles.axes2)
cla(handles.axes3)
    
set(handles.text4, 'String', "Worker ID : " + id);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text5, 'visible', 'off')
set(handles.pushbutton2, 'visible', 'off');
set(handles.pushbutton4, 'visible', 'off');
set(handles.pushbutton5, 'visible', 'off');

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
