function varargout = GUI(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)

%default image in GUI
loadImg(handles,'img/5.png');
showMask(handles,0);
showContours(handles,0);

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% selection button function
function btnSelectImg_Callback(hObject, eventdata, handles)
[FileName PathName] = uigetfile('../img/*','Select Image');
if (isequal(PathName,0))
    return;
end
loadImg(handles, fullfile(PathName,FileName));


%load the selected image in axes1
function loadImg(handles, path)
global img;
img = imread(path);
axes(handles.axes1);
imshow(img);


%show the shadow mask image in axes2
function showMask(handles, maskImg)
axes(handles.axes2);
imshow(maskImg*255);

%show the shadow detected image in axes3
function showContours(handles, contours)
axes(handles.axes3);
imshow(contours);


%show the shadow mask of the image 
function btnCompute_Callback(hObject, eventdata, handles)
global img;
global intr;


theta = str2double(get(handles.edit1, 'String'));
[intr, theta] = getIntrinsic(img, 1, 0.00001, true, true, theta);
set(handles.edit2, 'String', int2str(theta));

slider2_Callback(hObject, eventdata, handles);





%draw the detected boundary according to the threshold value
function slider2_Callback(hObject, eventdata, handles)
global img;
global intr;
global mask;
val = get(handles.slider2, 'Value');
G = rgb2gray(img);
mask = intr - G*val;
treshold = 25;
mask(mask<treshold) = 0;
mask(mask>=treshold) = 1;
[mask contours] = smoothShadowMask(img, mask);
showMask(handles, mask);
showContours(handles, contours);

%remove the shadow
function btnRemoveShadow_Callback(hObject, eventdata, handles)
global img;
global mask;
removeShadow(img, mask, get(handles.checkbox1, 'Value'));
