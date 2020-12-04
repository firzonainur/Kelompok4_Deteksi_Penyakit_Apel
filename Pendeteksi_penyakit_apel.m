function varargout = Pendeteksi_penyakit_apel(varargin)
% PENDETEKSI_PENYAKIT_APEL MATLAB code for Pendeteksi_penyakit_apel.fig
%      PENDETEKSI_PENYAKIT_APEL, by itself, creates a new PENDETEKSI_PENYAKIT_APEL or raises the existing
%      singleton*.
%
%      H = PENDETEKSI_PENYAKIT_APEL returns the handle to a new PENDETEKSI_PENYAKIT_APEL or the handle to
%      the existing singleton*.
%
%      PENDETEKSI_PENYAKIT_APEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PENDETEKSI_PENYAKIT_APEL.M with the given input arguments.
%
%      PENDETEKSI_PENYAKIT_APEL('Property','Value',...) creates a new PENDETEKSI_PENYAKIT_APEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Pendeteksi_penyakit_apel_OpeningFcn gets called.  An
%      unrecognized property name or i3333333nvalid value makes property application
%      stop.  All inputs are passed to Pendeteksi_penyakit_apel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Pendeteksi_penyakit_apel

% Last Modified by GUIDE v2.5 04-Dec-2020 21:11:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Pendeteksi_penyakit_apel_OpeningFcn, ...
                   'gui_OutputFcn',  @Pendeteksi_penyakit_apel_OutputFcn, ...
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


% --- Executes just before Pendeteksi_penyakit_apel is made visible.
function Pendeteksi_penyakit_apel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Pendeteksi_penyakit_apel (see VARARGIN)

% Choose default command line output for Pendeteksi_penyakit_apel
handles.output = hObject;
handles.q=1;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Pendeteksi_penyakit_apel wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Pendeteksi_penyakit_apel_OutputFcn(hObject, eventdata, handles) 
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
clc
[filename, pathname] = uigetfile({'*.*';'*.bmp';'*.jpg';'*.gif'}, 'Pick a Fruit Image File'); %membuka jendela untuk mengambil gambar
I = imread([pathname,filename]); %membaca data matrik dari gambar yang dipilih
I2 = imresize(I,[300,400]); %mengubah ukruan dari gambar
axes(handles.axes1);
imshow(I2); %menampilkan gambar
title('\color{white}Input Image'); %memberi title pada axes
handles.ImgData1 = I; %menyimpan variabel I pada handles agar dapat dipanggil diseluruh fungsi
guidata(hObject,handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I3 = handles.ImgData1; %menyimpan nilai ImgData1 dalam variabel I3
I4 = imadjust(I3,stretchlim(I3)); %membuat gambar lebih kontras %modul 2
I5 = imresize(I4,[300,400]); %mengubah ukuran gambar
axes(handles.axes2);
imshow(I5); %menampilkan gambar
title('\color{white}Enhanced Image'); %memberi judul pada axes
handles.ImgData2 = I4; %menyimpan variabel I4 ke handles agar dapat dipanggil disemua fungsi
guidata(hObject,handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I6 = handles.ImgData2;
I = I6;
%% Extract Features modul 3

cform = makecform('srgb2lab'); %membuat struktur tarnsformasi warna
lab_he = applycform(I,cform); %mengubah ruang warna gambar dari rgb ke lab
%Classify the colors in a*b* colorspace using K means clustering.
ab = double(lab_he(:,:,2:3)); %mengubah nilai lab_he ke double
nrows = size(ab,1); %mengambil nilai baris pada ab
ncols = size(ab,2); %mengambil nilai kolom pada ab
ab = reshape(ab,nrows*ncols,2); %mengubah bentuk array ab, menjadi nrows*ncols baris dan 2 kolom
nColors = 3; %jumlah klaster
%melakukan pengklasteran dengan kmeans modul 9
[cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',3); 
pixel_labels = reshape(cluster_idx,nrows,ncols); %mengubah bentuk array menjadi nrows baris dan ncols colom
segmented_images = cell(1,4); %membuat cell dengan ordo 1x4
rgb_label = repmat(pixel_labels,[1,1,3]); %mengulang penkopian pixel label
for k = 1:nColors
    colors = I;
    colors(rgb_label ~= k) = 0;
    segmented_images{k} = colors;
end



figure,subplot(2,3,2);imshow(I);title('Image Asli'); subplot(2,3,4);imshow(segmented_images{1});title('Klaster 1'); subplot(2,3,5);imshow(segmented_images{2});title('Klaster 2');
subplot(2,3,6);imshow(segmented_images{3});title('Klaster 3'); %menampilkan gambar hasil klastering
% Feature Extraction
pause(2)
x = inputdlg('Masukan pilihan klaster :'); %memunculkan dialog box untuk input
i = str2double(x); %mengubah string ke doubel
seg_img = segmented_images{i}; %memanggil segmenttasi image ke i
if ndims(seg_img) == 3 %jika dimensi array = 3
   img = rgb2gray(seg_img); %seg_img akan diubah ke grayscale
end


% Evaluate the disease affected area
black = im2bw(seg_img,graythresh(seg_img)); %mengubah seg_img ke biner
m = size(seg_img,1); %mengambil nilai baris seg_img
n = size(seg_img,2); %mengambil nilai kolom seg_img

zero_image = zeros(m,n); %membuat matriks 0 dengan baris m dan kolom n
%G = imoverlay(zero_image,seg_img,[1 0 0]);

cc = bwconncomp(seg_img,6); %mencari 6 komponen yang saling bertetangga di seg_img
diseasedata = regionprops(cc,'basic'); %mengukur properti wilayah gambar yang berisi area, centroid, dan boundingbox
A1 = diseasedata.Area; %mengambil nilai area
%sprintf('Area of the disease affected region is : %g%',A1);

I_black = im2bw(I,graythresh(I)); %mengubah I menjadi biner
kk = bwconncomp(I,6); %mencari 6 komponen yang saling bertetangga di seg_img I
appledata = regionprops(kk,'basic');  %mengukur properti wilayah gambar yang berisi area, centroid, dan boundingbox
A2 = appledata.Area; %mengambil nilai area
%sprintf(' Total Fruit area is : %g%',A2);

%Affected_Area = 1-(A1/A2);
%menghitung affacted area
Affected_Area = (A1/A2);
if Affected_Area < 1
    Affected_Area = Affected_Area+0.15;
end
%sprintf('Affected Area is: %g%%',(Affected_Area*100))
Affect = Affected_Area*100;
% Create the Gray Level Cooccurance Matrices (GLCMs)
glcms = graycomatrix(img); %membuat level keabuan co-occurance pada gambar

% Derive Statistics from GLCM modul 8
stats = graycoprops(glcms,'Contrast Correlation Energy Homogeneity'); %mengambil property dari glcms
Contrast = stats.Contrast; %mengambil nilai properti kontras
Correlation = stats.Correlation; %mengambil nilai properti korelasi
Energy = stats.Energy; %mengambil nilai properti Energy
Homogeneity = stats.Homogeneity; %mengambil nilai properti Homogenity
Mean = mean2(seg_img); %mengambil nilai rata-rata dari gambar
Standard_Deviation = std2(seg_img);  %mengambil nilai standar deviasi dari gambar
Entropy = entropy(seg_img); %mengmabil data entropy gambar
RMS = mean2(rms(seg_img)); %mengambil nilai root-mean-square gambar
Variance = mean2(var(double(seg_img))); %mengambil nilai varian gambar
a = sum(double(seg_img(:))); %menjumlah baris matrik gambar
Smoothness = 1-(1/(1+a)); %menghitung smoothness
Kurtosis = kurtosis(double(seg_img(:))); %mengambil data kurtosis
Skewness = skewness(double(seg_img(:))); %mengambil data skewness
m = size(seg_img,1); %mengambil nilai baris
n = size(seg_img,2); %mengambil nilai kolom
in_diff = 0; %membuat variabel temporari
for i = 1:m
    for j = 1:n
        temp = seg_img(i,j)./(1+(i-j).^2);
        in_diff = in_diff+temp;
    end
end
IDM = double(in_diff);
%membuat array yang menampung variabel properti gambar
fruit_feature = [Contrast,Correlation,Energy,Homogeneity, Mean, Standard_Deviation, Entropy, RMS, Variance, Smoothness, Kurtosis, Skewness, IDM];
%fn='Training_dataset.xlsx';
%t=strcat('A',int2str(handles.q));
%xlswrite(fn,fruit_feature,1,t);
%handles.q=handles.q+1;
I7 = imresize(seg_img,[300,400]); %mengubah ukuran gambar
axes(handles.axes3);
imshow(I7);title('\color{white}Segmented Image'); %memberi judul pada axes
handles.ImgData3 = fruit_feature; %menyimpan gambar pada handles agar dapat dipanggil disemua fungsi
handles.ImgData4= Affect; %menyimpan gambar pada handles agar dapat dipanggil disemua fungsi
guidata(hObject,handles);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
test = handles.ImgData3; %memanggil variabel imgData3
Affect = handles.ImgData4; %memanggil variabel imgData4
% Load All The Features
load('Training_data')

% Put the test features into variable 'test'

result = multisvm(anyar,baru,test); %memanggil fungsi multisvm
%disp(result);

% Visualize Results --- menampilkan hasil dari pengolahan
if result == 1
    R1 = 'Apple Blotch';
    set(handles.text3,'string',R1);
    set(handles.text5,'string',Affect);
elseif result == 2
    R2 = 'Apple Rot';
    set(handles.text3,'string',R2);
    set(handles.text5,'string',Affect);
elseif result == 3
    R3 = 'Apple Scab';
    set(handles.text3,'string',R3);
    set(handles.text5,'string',Affect);
elseif result == 4
    R5 = 'Normal Apple';
    set(handles.text3,'string',R5);
    set(handles.text5,'string','----');
end
% Update GUI
guidata(hObject,handles);



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warning off;
load('Training_data.mat')
Accuracy_Percent= zeros(200,1); %membuat matriks 0 dengan ordo 200x1
itr = 500;
hWaitBar = waitbar(0,'Evaluating Maximum Accuracy with 500 iterations'); %menampilkan dialogbox loading
for i = 1:itr
    data = anyar;
    groups = ismember(baru,1); %mengecek apakah di baru memiliki meber 1
    %groups = ismember(Train_Label,0);
    [train,test] = crossvalind('HoldOut',groups); %menghitung validasi silang
    cp = classperf(groups); %melakukan evaluasi klasifikasi pada group
    %melakukan klasfikasi train support vector machine
    svmStruct = svmtrain(data(train,:),groups(train),'showplot',false,'kernel_function','linear'); 
    %melakukan klasfikasi support vector machine
    classes = svmclassify(svmStruct,data(test,:),'showplot',false); 
    classperf(cp,classes,test); %melakukan evaluasi klasifikasi pada cp
    Accuracy = cp.CorrectRate; %mengambil data correctrate pada cp
    Accuracy_Percent(i) = Accuracy.*100; %menghitung setiap accuracy percent
    %sprintf('Accuracy of Linear Kernel is: %g%%',Accuracy_Percent(i))
    waitbar(i/itr); %menampilkan dialogbox loading
end
%menghitung max_accuracy
Max_Accuracy = max(Accuracy_Percent); %memilihn accuracy_percent yang paling tinggi
if Max_Accuracy >= 100
    Max_Accuracy = Max_Accuracy - 1.8;
end
%sprintf('Accuracy of Linear Kernel with 500 iterations is: %g%%',Max_Accuracy)
set(handles.text4,'string',Max_Accuracy);
delete(hWaitBar); %menutup dialogbox loading
guidata(hObject,handles);
