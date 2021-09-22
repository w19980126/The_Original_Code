
function varargout = raw2tiff(varargin)
% RAW2TIFF M-file for raw2tiff.fig
%      RAW2TIFF, by itself, creates a new RAW2TIFF or raises the existing
%      singleton*.
%
%      H = RAW2TIFF returns the handle to a new RAW2TIFF or the handle to
%      the existing singleton*.
%
%      RAW2TIFF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RAW2TIFF.M with the given input arguments.
%
%      RAW2TIFF('Property','Value',...) creates a new RAW2TIFF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before raw2tiff_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to raw2tiff_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help raw2tiff

% Last Modified by GUIDE v2.5 14-Oct-2009 14:45:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @raw2tiff_OpeningFcn, ...
    'gui_OutputFcn',  @raw2tiff_OutputFcn, ...
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


% --- Executes just before raw2tiff is made visible.
function raw2tiff_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to raw2tiff (see VARARGIN)

% Choose default command line output for raw2tiff
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes raw2tiff wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = raw2tiff_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbConvert.
function pbConvert_Callback(hObject, eventdata, handles)
% hObject    handle to pbConvert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Select Directory for Raw files
persistent startDir;
if ~ischar(startDir)
    startDir = [];
end
directory_name = uigetdir(startDir);
startDir = directory_name;
sub_dir = dir(directory_name);

%% search Main directory for files
filelist = dir([directory_name '\*.raw']);
% creat Directory for .tiff files Directory name is TIFF
[folder_structure current_folder] = fileparts(directory_name);
if length(filelist) > 0
    mkdir([folder_structure '\TIFF']);
    mkdir([folder_structure '\TIFF\' current_folder  ]);
end

% get Resolution
if (get(handles.rb320,'Value') == 1)
    xres = 320;
    yres =240;
elseif(get(handles.rb640,'Value') == 1)
    xres = 640;
    yres =480;
elseif (get(handles.rb1024,'Value') == 1)
    xres = 1024;
    yres = 768;
elseif (get(handles.rbCustom,'Value') == 1)
    xres = str2num(get(handles.editXres,'String'));
    yres = str2num(get(handles.editYres,'String'));
end

h = waitbar(0,'File Convert');
% convert files to tiff
eight_bit = 0; % select 8 bit  or 16 bit raw files; default is 16 bit
for file = 1:length(filelist)
    waitbar(file/length(filelist),h,'File Convert in progress...')
    % read files
    fid = fopen([directory_name '\' filelist(file).name]);
    A = fread(fid, 'uint8=>uint8');
    fclose(fid);
    % allign bits
    E = double(A(1:2:end));
    F = double(A(2:2:end));
    G = 64*E+F/4;
    if eight_bit == 1
        intensity = reshape(E, [xres yres]);
    elseif eight_bit == 0
        intensity = reshape(G, [xres yres])';
    end
    
    % Write Files
    imwrite(uint16(intensity), [folder_structure '\TIFF\' current_folder '\' filelist(file).name '.tiff'], 'Compression', 'none');
    
end
close(h);

%% search for sub dir
try
    for ii = 3:length(sub_dir)
        if isdir([directory_name '\' sub_dir(ii).name])
            filelist = dir([directory_name '\' sub_dir(ii).name '\*.raw']);
            if length(filelist) > 0
                % creat Directory for .tiff files Directory name is TIFF
                mkdir([directory_name '\TIFF']);
                mkdir([directory_name '\TIFF\' sub_dir(ii).name  ]);
            end
            % get Resolution
            if (get(handles.rb320,'Value') == 1)
                xres = 320;
                yres =240;
            elseif(get(handles.rb640,'Value') == 1)
                xres = 640;
                yres = 480;
            elseif (get(handles.rb1024,'Value') == 1)
                xres = 1024;
                yres = 768;
            elseif (get(handles.rbCustom,'Value') == 1)
                xres = str2num(get(handles.editXres,'String'));
                yres = str2num(get(handles.editYres,'String'));
            end
            
            h = waitbar(0,'File Convert');
            % convert files to tiff
            eight_bit = 0; % select 8 bit  or 16 bit raw files; default is 16 bit
            for file = 1:length(filelist)
                waitbar(file/length(filelist),h,'File Convert in progress...')
                % read files
                fid = fopen([directory_name '\' sub_dir(ii).name '\' filelist(file).name]);
                A = fread(fid, 'uint8=>uint8');
                fclose(fid);
                % allign bits
                E = double(A(1:2:end));
                F = double(A(2:2:end));
                G = 64*E+F/4;
                if eight_bit == 1
                    intensity = reshape(E, [xres yres]);
                elseif eight_bit == 0
                    intensity = reshape(G, [xres yres])';
                end
                
                % Write Files
                imwrite(uint16(intensity), [directory_name '\TIFF\' sub_dir(ii).name '\' filelist(file).name '.tiff'], 'Compression', 'none');
                
            end
            close(h);
        end
    end
catch  
end

function editXres_Callback(hObject, eventdata, handles)
% hObject    handle to editXres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editXres as text
%        str2double(get(hObject,'String')) returns contents of editXres as a double


% --- Executes during object creation, after setting all properties.
function editXres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editXres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editYres_Callback(hObject, eventdata, handles)
% hObject    handle to editYres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editYres as text
%        str2double(get(hObject,'String')) returns contents of editYres as a double


% --- Executes during object creation, after setting all properties.
function editYres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editYres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rb320.
function rb320_Callback(hObject, eventdata, handles)
% hObject    handle to rb320 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb320

set(handles.rb320,'Value',1);
set(handles.rb640,'Value',0);
set(handles.rb1024,'Value',0);
set(handles.rbCustom,'Value',0);


% --- Executes on button press in rb640.
function rb640_Callback(hObject, eventdata, handles)
% hObject    handle to rb640 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb640
set(handles.rb320,'Value',0);
set(handles.rb640,'Value',1);
set(handles.rb1024,'Value',0);
set(handles.rbCustom,'Value',0);

% --- Executes on button press in rb1024.
function rb1024_Callback(hObject, eventdata, handles)
% hObject    handle to rb1024 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb1024
set(handles.rb320,'Value',0);
set(handles.rb640,'Value',0);
set(handles.rb1024,'Value',1);
set(handles.rbCustom,'Value',0);

% --- Executes on button press in rbCustom.
function rbCustom_Callback(hObject, eventdata, handles)
% hObject    handle to rbCustom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbCustom
set(handles.rb320,'Value',0);
set(handles.rb640,'Value',0);
set(handles.rb1024,'Value',0);
set(handles.rbCustom,'Value',1);
