function varargout = CodeForSMFilter(varargin)
%CODEFORSMFILTER M-file for CodeForSMFilter.fig
%      CODEFORSMFILTER, by itself, creates a new CODEFORSMFILTER or raises the existing
%      singleton*.
%
%      H = CODEFORSMFILTER returns the handle to a new CODEFORSMFILTER or the handle to
%      the existing singleton*.
%
%      CODEFORSMFILTER('Property','Value',...) creates a new CODEFORSMFILTER using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to CodeForSMFilter_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      CODEFORSMFILTER('CALLBACK') and CODEFORSMFILTER('CALLBACK',hObject,...) call the
%      local function named CALLBACK in CODEFORSMFILTER.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CodeForSMFilter

% Last Modified by GUIDE v2.5 11-Oct-2020 08:53:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CodeForSMFilter_OpeningFcn, ...
                   'gui_OutputFcn',  @CodeForSMFilter_OutputFcn, ...
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


% --- Executes just before CodeForSMFilter is made visible.
function CodeForSMFilter_OpeningFcn(hObject, eventdata, handles, varargin)

x = 0:0.1:10;
axes(handles.axes1);
h1 = plot(sin(x));
hold on
tmp = sin(x)+rand(1,length(x))*0.25;
h2 = plot(tmp);
xlim1 = get(handles.axes1,'xlim');
ylim1 = get(handles.axes1,'ylim');

axes(handles.axes2)
h3 = plot(diff(sin(x)));
hold on
h4 = plot(diff(tmp));
xlim2 = get(handles.axes2,'xlim');
ylim2 = get(handles.axes2,'ylim');

handles.h1 = h1;
handles.h2 = h2;
handles.h3 = h3;
handles.h4 = h4;

set(handles.XMin_1,'string',xlim1(1));
set(handles.XMin_2,'string',xlim2(1));
set(handles.YMin_1,'string',ylim1(1));
set(handles.YMin_2,'string',ylim2(1));
set(handles.XMax_1,'string',xlim1(2));
set(handles.XMax_2,'string',xlim2(2));
set(handles.YMax_1,'string',ylim1(2));
set(handles.YMax_2,'string',ylim2(2));

% Update handles structure
handles.output = hObject;
guidata(hObject, handles);

function varargout = CodeForSMFilter_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function XMin_2_Callback(hObject, eventdata, handles)

xlim = get(handles.axes2,'XLim');
xlim(1) = str2num(get(hObject,'string'));

if xlim(1)>=xlim(2)
    errordlg('请输入正确的值');
else
    set(handles.axes2,'XLim',xlim);
end

guidata(hObject,handles);

function XMin_2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function XMax_2_Callback(hObject, eventdata, handles)

xlim = get(handles.axes2,'XLim');
xlim(2) = str2num(get(hObject,'string'));

if xlim(1)>=xlim(2)
    errordlg('请输入正确的数值');
else
    set(handles.axes2,'XLim',xlim);
end

guidata(hObject,handles);

function XMax_2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function YMin_2_Callback(hObject, eventdata, handles)

ylim = get(handles.axes2,'YLim');
ylim(1) = str2num(get(hObject,'string'));

if ylim(1)>=ylim(2)
    errordlg('请输入正确的数值');
else
    set(handles.axes2,'YLim',ylim);
end

guidata(hObject,handles);

function YMin_2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function YMax_2_Callback(hObject, eventdata, handles)

ylim = get(handles.axes2,'YLim');
ylim(2) = str2num(get(hObject,'string'));

if ylim(1)>=ylim(2)
    errordlg('请输入正确的数值');
else
    set(handles.axes2,'YLim',ylim);
end

guidata(hObject,handles);

function YMax_2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function YMax_1_Callback(hObject, eventdata, handles)

ylim = get(handles.axes1,'YLim');
ylim(2) = str2num(get(hObject,'string'));

if ylim(1)>=ylim(2)
    errordlg('请输入正确的数值');
else
    set(handles.axes1,'YLim',ylim);
end

guidata(hObject,handles);

function YMax_1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function YMin_1_Callback(hObject, eventdata, handles)

ylim = get(handles.axes1,'YLim');
ylim(1) = str2num(get(hObject,'string'));

if ylim(1)>=ylim(2)
    errordlg('请输入正确的数值');
else
    set(handles.axes1,'YLim',ylim);
end

guidata(hObject,handles);


function YMin_1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function XMax_1_Callback(hObject, eventdata, handles)

xlim = get(handles.axes1,'XLim');
xlim(2) = str2num(get(hObject,'string'));

if xlim(1)>=xlim(2)
    errordlg('请输入正确的数值');
else
    set(handles.axes1,'XLim',xlim);
end

guidata(hObject,handles);

function XMax_1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function XMin_1_Callback(hObject, eventdata, handles)

xlim = get(handles.axes1,'XLim');
xlim(1) = str2num(get(hObject,'string'));

if xlim(1)>=xlim(2)
    errordlg('请输入正确的数值');
else
    set(handles.axes1,'XLim',xlim);
end

guidata(hObject,handles);

function XMin_1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_expTab.
function pushbutton_expTab_Callback(hObject, eventdata, handles)

[file,path] = uigetfile;
set(handles.text_expTab,'string',[path file]);
load([path file]);
handles.expTab = expTab;

expname = cell(1,length(expTab));
for ii = 1:length(expname)
    expname{ii} = expTab(ii).expname;
end
handles.expname = expname;
expname_ = '';

for ii = 1:(length(expname)-1)
    expname_ = [expname_ expname{ii}];
    expname_ = [expname_ '|'];
end
expname_ = [expname_ expname{end}];

set(handles.popupmenu1,'string',expname_);
set(handles.popupmenu1,'value',1);
set(handles.popupmenu2,'value',1);

guidata(hObject, handles);

function popupmenu1_Callback(hObject, eventdata, handles)

tmp_val = get(hObject,'value');
tmp_filepath1 = get(handles.text_expTab,'string');

loc = find(tmp_filepath1 == '\');
tmp_filepath2{1} = tmp_filepath1(1:(loc(1)-1));
for ii = 2:length(loc)
    tmp_filepath2{ii} = tmp_filepath1((loc(ii-1)+1):(loc(ii)-1));
end
tmp_filepath2{ii+1} = tmp_filepath1((loc(ii)+1):end);
tmp_filepath2{end} = handles.expname{tmp_val};

tmp_filepath2_ = '';
for ii = 1:(length(tmp_filepath2)-1)
    tmp_filepath2_ = [tmp_filepath2_ tmp_filepath2{ii}];
    tmp_filepath2_ = [tmp_filepath2_ '\'];
end
tmp_filepath2_ = [tmp_filepath2_ tmp_filepath2{end}];
handles.path = tmp_filepath2_;            % 将cell格式的tmp_filepath2转为char格式的tmp_filepath2

zonedir = dir(fullfile(tmp_filepath2_,'*.mat'));
handls.zonedir = zonedir;
zonename = cell(length(zonedir),1);
for ii = 1:length(zonename)
    zonename{ii} = zonedir(ii).name;
end
handles.zonename = zonename;
zonename_ = '';
for ii = 1:(length(zonename)-1)
    zonename_ = [zonename_ zonename{ii}];
    zonename_ = [zonename_ '|'];
end
zonename_ = [zonename_ zonename{end}];
set(handles.popupmenu2,'string',zonename_);

guidata(hObject,handles);

function popupmenu1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenu2_Callback(hObject, eventdata, handles)

zone_val = get(hObject,'value');
value_filename = handles.zonename{zone_val};
valuepath = fullfile(handles.path,value_filename);
load(valuepath)

handles.Value = Value;
avr = Value.avr;
axes(handles.axes1)
hold off
handles.h1 = plot(avr);
axes(handles.axes2)
hold off
handles.h3 = plot(diff(avr));

frame = handles.Value.begin.frame;
n = get(handles.popupmenu1,'value');    % 返回下拉菜单value用来确定是用哪组数据做的图
tmp_expname = handles.expname{n};   % 得到该组数据的expname

for ii = 1:length(handles.expTab)
    
    if tmp_expname == handles.expTab(ii).expname
        
        mark = ii; 
        
    end
    
end

handles.mark = mark;
cycle_num = handles.expTab(mark).cycle_num;
handles.cycle_num = cycle_num;
seg_length = handles.Value.seg_length;
handles.seg_length = seg_length;

avr = handles.Value.avr;
% l_filter = str2num(get(handles.l_filter_edit,'string'));
l_filter = round(str2num(get(handles.l_filter_edit,'string'))*handles.seg_length);
filted_avr = smooth(avr,l_filter);
df_avr = diff(filted_avr);

axes(handles.axes1)
ylim = get(handles.axes1,'ylim');
hold on

x = frame:seg_length:(frame+seg_length*2);
xx = [x;x];
y1 = ylim(1)*ones(1,length(x));
y2 = ylim(2)*ones(1,length(x));
yy = [y1;y2];
handles.h_potential1 = plot(xx,yy,'--');
handles.h2 = plot(filted_avr);
xlim1 = get(handles.axes1,'xlim');
ylim1 = get(handles.axes1,'ylim');

axes(handles.axes2)
ylim = get(handles.axes2,'ylim');
hold on

x = (frame-1):seg_length:(frame-1+seg_length*2);
xx = [x;x];
y1 = ylim(1)*ones(1,length(x));
y2 = ylim(2)*ones(1,length(x));
yy = [y1;y2];
handles.h_potential2 = plot(xx,yy,'--');
handles.h4 = plot(df_avr);
xlim2 = get(handles.axes2,'xlim');
ylim2 = get(handles.axes2,'ylim');

set(handles.XMin_1,'string',xlim1(1));
set(handles.XMin_2,'string',xlim2(1));
set(handles.YMin_1,'string',ylim1(1));
set(handles.YMin_2,'string',ylim2(1));
set(handles.XMax_1,'string',xlim1(2));
set(handles.XMax_2,'string',xlim2(2));
set(handles.YMax_1,'string',ylim1(2));
set(handles.YMax_2,'string',ylim2(2));

set(handles.Smooth_checkbox1,'value',1);
set(handles.checkbox3,'value',1);
set(handles.checkbox4,'value',1);
set(handles.checkbox5,'value',1);

guidata(hObject,handles);

function popupmenu2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)

    if get(hObject,'value') == 1
        
        set(handles.h1,'visible','on');
        set(handles.h3,'visible','on');
        
    else
        set(handles.h1,'visible','off');
        set(handles.h3,'visible','off');
        
    end
    
guidata(hObject,handles);


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)

 if get(hObject,'value') == 1
        
        set(handles.h2,'visible','on');
        set(handles.h4,'visible','on');
        
    else
        set(handles.h2,'visible','off');
        set(handles.h4,'visible','off');
        
    end
    
guidata(hObject,handles);


function checkbox5_Callback(hObject, eventdata, handles)

tmp_val = get(hObject,'value');
if tmp_val == 0
    set(handles.h_potential1,'visible','off');
    set(handles.h_potential2,'visible','off');
else
    set(handles.h_potential1,'visible','on');
    set(handles.h_potential2,'visible','on');
end

guidata(hObject,handles)


function Smooth_checkbox1_Callback(hObject, eventdata, handles)

tmp_val = get(hObject,'value');

if tmp_val == 1
    avr = handles.Value.avr;
%     l_filter = str2num(get(handles.l_filter_edit,'string'));
    l_filter = round(str2num(get(handles.l_filter_edit,'string'))*handles.seg_length);
    filted_avr = smooth(avr,l_filter);
    df_avr = diff(filted_avr);
    axes(handles.axes1)
    delete(handles.h2);
    handles.h2 = plot(filted_avr);
    axes(handles.axes2)
    delete(handles.h4);
    handles.h4 = plot(df_avr);
elseif tmp_val ==0
    delete(handles.h2);
    delete(handles.h4);
end

guidata(hObject,handles)

function Med_checkbox_Callback(hObject, eventdata, handles)

tmp_val = get(hObject,'value');

if tmp_val == 1
    avr = handles.Value.avr;
%     l_filter = str2num(get(handles.l_filter_edit,'string'));
    l_filter = round(str2num(get(handles.l_filter_edit,'string'))*handles.seg_length);
    filted_avr = medfilt1(avr,l_filter);
    df_avr = diff(filted_avr);
    axes(handles.axes1)
    delete(handles.h2);
    handles.h2 = plot(filted_avr);
    axes(handles.axes2)
    delete(handles.h4);
    handles.h4 = plot(df_avr);
elseif tmp_val ==0
    delete(handles.h2);
    delete(handles.h4);
end

guidata(hObject,handles)

function l_filter_edit_Callback(hObject, eventdata, handles)

if get(handles.Smooth_checkbox1,'value') == 1
    avr = handles.Value.avr;
    l_filter = round(str2num(get(handles.l_filter_edit,'string'))*handles.seg_length);
    filted_avr = smooth(avr,l_filter);
    df_avr = diff(filted_avr);
    axes(handles.axes1)
    delete(handles.h2)
    handles.h2 = plot(filted_avr);
    axes(handles.axes2)
    delete(handles.h4)
    handles.h4 = plot(df_avr);
elseif get(handles.Med_checkbox,'value') == 1
    avr = handles.Value.avr;
    l_filter = round(str2num(get(handles.l_filter_edit,'string'))*handles.seg_length);
    filted_avr = medfilt1(avr,l_filter);
    df_avr = diff(filted_avr);
    axes(handles.axes1)
    delete(handles.h2)
    handles.h2 = plot(filted_avr);
    axes(handles.axes2)
    delete(handles.h4)
    handles.h4 = plot(df_avr);
end

guidata(hObject,handles);

function l_filter_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
