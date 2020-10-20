function varargout = control(varargin)
% CONTROL MATLAB code for control.fig
%      CONTROL, by itself, creates a new CONTROL or raises the existing
%      singleton*.
%
%      H = CONTROL returns the handle to a new CONTROL or the handle to
%      the existing singleton*.
%
%      CONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONTROL.M with the given input arguments.
%
%      CONTROL('Property','Value',...) creates a new CONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before control_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to control_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help control

% Last Modified by GUIDE v2.5 04-Feb-2020 17:26:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @control_OpeningFcn, ...
                   'gui_OutputFcn',  @control_OutputFcn, ...
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


% --- Executes just before control is made visible.
function control_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to control (see VARARGIN)

% Choose default command line output for control
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes control wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = control_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
guidata(hObject, handles);
han = axes('unit','normalized','position',[0 0 1 1]);
new = imread('2.jpg');
imagesc(new);
set(han,'handlevisibility','on','visible','off');
uistack(han,'top');


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s=serial('com6');
set(s,'BaudRate',9600,'DataBits', 8, 'Parity', 'none','StopBits', 1, 'FlowControl', 'none','Terminator','CR');
fopen(s);
pause(5);
fprintf(s,'B');
fclose(s);



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s=serial('com6');
set(s,'BaudRate',9600,'DataBits', 8, 'Parity', 'none','StopBits', 1, 'FlowControl', 'none','Terminator','CR');
fopen(s);
pause(5);
fprintf(s,'D');
fclose(s);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s=serial('com6');
set(s,'BaudRate',9600,'DataBits', 8, 'Parity', 'none','StopBits', 1, 'FlowControl', 'none','Terminator','CR');
fopen(s);
pause(5);
fprintf(s,'C');
fclose(s);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s=serial('com6');
set(s,'BaudRate',9600,'DataBits', 8, 'Parity', 'none','StopBits', 1, 'FlowControl', 'none','Terminator','CR');
fopen(s);
pause(5);
fprintf(s,'E');
fclose(s);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('trained.mat')

a=uigetfile('.mp4');
vidreader=VideoReader(a);
vidplayer=vision.DeployableVideoPlayer;
i=1; 
results=struct('Boxes',[],'Scores',[]);
while(hasFrame(vidreader))
    I=readFrame(vidreader);
    [bboxes,scores]=detect(detector,I,'Threshold',1);
    [bboxes1,scores1]=detect(detector1,I,'Threshold',1);
%     [bboxes2,scores2]=detect(detector2,I,'Threshold',1);

    [~,idx]=max(scores);
    [~,idx1]=max(scores1);
%     [~,idx2]=max(scores2);
    
    results(i).Boxes=bboxes;
    results(i).Scores=scores;

    if (scores1>40)
        annotation1=sprintf('%s,confidence %4.2f',detector1.ModelName,scores1(idx1));
        I=insertObjectAnnotation(I,'rectangle',bboxes1(idx1,:),annotation1,'LineWidth',4,...
        'TextBoxOpacity',0.9,'FontSize',18);
    else 
        annotation=sprintf('%s,confidence %4.2f',detector.ModelName,scores(idx));
        I=insertObjectAnnotation(I,'rectangle',bboxes(50,:),annotation,'LineWidth',4,...
        'TextBoxOpacity',0.9,'FontSize',18);
    end
    
    step(vidplayer,I)
    i=i+1;
    if scores(i>1)
        fprintf('weed detected\n');
        pause(10);
        s=serial('com6');
        set(s,'BaudRate',9600,'DataBits', 8, 'Parity', 'none','StopBits', 1, 'FlowControl', 'none','Terminator','CR');
        fopen(s);
        pause(5);
        fprintf(s,'A');
        fclose(s);
    end
end
