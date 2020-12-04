clc;clear;close all;
image_folder = 'gambar'; %lokasi folder dari file image
filenames = dir(fullfile(image_folder, '*.jpg')); %menyimpan image sebagai list sehingga dapat dipanggil berulang kali
total_images = 306; %banyaknya gambar yang digunakan yaitu 10, dan juga sebagai variable batas perulangan
for n = 1:total_images %melakukan looping sebanyak 10 image
    full_name = fullfile(image_folder, strcat('Apple(',num2str(n),').jpg')) ; %memanggil file image dengan mengubah angka menjadi berbentuk string
    Img = imread(full_name); %membaca file image
    I = rgb2gray(Img); %mengubah gambar menjadi grayscale %modul 3
    %modul 8
    GLCM = graycomatrix(I,'Offset',[0 1; -1 1; -1 0; -1 -1]); %fitur tekstur GLCM
    stats = graycoprops(GLCM,{'contrast','correlation','energy','homogeneity'}); %menyediakan nilai properti untuk gambar YAITU CONTRAST,ENERGY,HOMOGENETY, DAN CORELATION
    CON(n) = mean(stats.Contrast); %mengambil nilai properti kontras
    CORR(n) = mean(stats.Correlation); %mengambil nilai properti korelasi
    EN(n) = mean(stats.Energy); %mengambil nilai properti Energy
    HOM(n) = mean(stats.Homogeneity); %mengambil nilai properti Homogenity
    Mean(n) = mean2(Img); %mengambil nilai rata-rata dari gambar
    Standard_Deviation(n) = std2(Img); %mengambil nilai standar deviasi dari gambar
    Entropy(n) = entropy(Img); %mengmabil data entropy gambar
    RMS(n) = mean2(rms(Img)); %mengambil nilai root-mean-square gambar
    Variance(n) = mean2(var(double(Img))); %mengambil nilai varian gambar
    a = sum(double(Img(:))); %menjumlah baris matrik gambar
    Smoothness(n) = 1-(1/(1+a)); %menghitung smoothness
    Kurtosis(n) = kurtosis(double(Img(:))); %mengambil data kurtosis
    Skewness(n) = skewness(double(Img(:))); %mengambil data skewness
    o = size(Img,1); %mengambil nilai baris
    p = size(Img,2); %mengambil nilai kolom
    in_diff = 0; %membuat variabel temporari
    for i = 1:o
        for j = 1:p
            temp = Img(i,j)./(1+(i-j).^2);
            in_diff = in_diff+temp;
        end
    end
    IDM(n) = double(in_diff);   
    urutan(n) = [n]; %membuat array urutan berisi nilai n
end

X =[CON;CORR]';
number = [urutan;CON;CORR;EN;HOM;Mean;Standard_Deviation;Entropy;RMS;Variance;Smoothness;Kurtosis;Skewness;IDM]'; %menyimpan variabel kedalam array untuk disimpan di excel
Header = {'Gambar ke-', 'Contrast', 'Corelation', 'energy', 'homogenity', 'Mean', 'Standar Deviasi', 'enthropy', 'RMS', 'Variance', 'Smoothness', 'Kurtosis','Skewness', 'IDM'}; %menyimpan header untuk file excel
anyar = [CON;CORR;EN;HOM;Mean;Standard_Deviation;Entropy;RMS;Variance;Smoothness;Kurtosis;Skewness;IDM]'; %mengambil nilai variabel untuk disimpan di array anyar
DataCell = num2cell(number); %mengubah array ke cell dengan ukuran yang tetap
Output = [Header;DataCell]; %menggabung header dan datacell, kemudian disimpan kedalam variabel output
    
baru = zeros(1, total_images); %membuat matriks 0 dengan ordo 1xjumlah gambar
for i = 1:total_images
    if i < 79
        baru(i) = 1;
    elseif i < 169
        baru(i) = 2;
    elseif i < 238
        baru(i) = 3;
    else
        baru(i) = 4;
    end
end
xlswrite('Training_data',Output,'Sheet1','A1'); %menyimpan variabel output dalam file excel
save Training_data.mat anyar baru; %menyimpan variabel anyar dan baru pada file Training_data.mat
load('Training_data.mat')