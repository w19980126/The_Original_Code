function varargout = CodeForCVFilting(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CodeForCVFilting_OpeningFcn, ...
                   'gui_OutputFcn',  @CodeForCVFilting_OutputFcn, ...
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

function CodeForCVFilting_OpeningFcn(hObject, eventdata, handles, varargin)

x = 0:0.1:1000;
y = sin(0.01*x);
yy = y+rand(1,length(x))*0.3;
d_yy = diff(yy);

f1 = get(handles.slider_f1,'value');
f3 = get(handles.slider_f3,'value');
rp = get(handles.slider_rp,'value');
rs = get(handles.slider_rs,'value');
Fs = 1;
lp_d_yy = lowp(d_yy,f1,f3,rp,rs,Fs);

axes(handles.axes1)
h1 = plot(x(2:end),d_yy);
hold on
h2 = plot(x(2:end),lp_d_yy);
legend(h1,h2,'原始数据','原始数据滤波');

axes(handles.axes2)
h3 = plot(x,yy);
legend(h3,'原始数据');

handles.output = hObject;

guidata(hObject, handles);

%------------------------------------------------------------------------------------------------

function varargout = CodeForCVFilting_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

function Xmin1_Callback(hObject, eventdata, handles)



function Xmin1_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%------------------------------------------------------------------------------------------------

function Xmax1_Callback(hObject, eventdata, handles)


function Xmax1_CreateFcn(hObject, eventdata, handles)


if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%------------------------------------------------------------------------------------------------

function Ymax1_Callback(hObject, eventdata, handles)

function Ymax1_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%------------------------------------------------------------------------------------------------

function Ymin1_Callback(hObject, eventdata, handles)

function Ymin1_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%------------------------------------------------------------------------------------------------

function Xmin2_Callback(hObject, eventdata, handles)

function Xmin2_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%------------------------------------------------------------------------------------------------

function Xmax2_Callback(hObject, eventdata, handles)

function Xmax2_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%------------------------------------------------------------------------------------------------

function Ymax2_Callback(hObject, eventdata, handles)

function Ymax2_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%------------------------------------------------------------------------------------------------

function Ymin2_Callback(hObject, eventdata, handles)

function Ymin2_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%------------------------------------------------------------------------------------------------

function pushbutton_expTab_Callback(hObject, eventdata, handles)

%------------------------------------------------------------------------------------------------

function popupmenu_A_Callback(hObject, eventdata, handles)

function popupmenu_A_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%------------------------------------------------------------------------------------------------

function popupmenu_zone_Callback(hObject, eventdata, handles)

function popupmenu_zone_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%------------------------------------------------------------------------------------------------

function radiobutton_potential_Callback(hObject, eventdata, handles)

%------------------------------------------------------------------------------------------------

function radiobutton_rawdata_Callback(hObject, eventdata, handles)

%------------------------------------------------------------------------------------------------

function radiobutton_filteddata_Callback(hObject, eventdata, handles)

%------------------------------------------------------------------------------------------------

function slider_f1_Callback(hObject, eventdata, handles)

function slider_f1_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%------------------------------------------------------------------------------------------------

function slider_f3_Callback(hObject, eventdata, handles)

function slider_f3_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%------------------------------------------------------------------------------------------------

function slider_rp_Callback(hObject, eventdata, handles)

function slider_rp_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%------------------------------------------------------------------------------------------------

function slider_rs_Callback(hObject, eventdata, handles)

function slider_rs_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
