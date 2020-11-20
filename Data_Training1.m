clc;clear;close all;
image_folder = 'Dataset Images'; %lokasi folder dari file image
filenames = dir(fullfile(image_folder, '*.jpg')); %menyimpan image sebagai list sehingga dapat dipanggil berulang kali
total_images=35; %banyaknya gambar yang digunakan yaitu 10, dan juga sebagai variable batas perulangan
for n = 1:total_images %melakukan looping sebanyak 10 image
    full_name = fullfile(image_folder, strcat('Apple (',num2str(n),').jpg')) ; %memanggil file image dengan mengubah angka menjadi berbentuk string
    Img = imread(full_name); %membaca file image
    I = rgb2gray(Img);
    GLCM = graycomatrix(I,'Offset',[0 1; -1 1; -1 0; -1 -1]); %fitur tekstur GLCM
    stats = graycoprops(GLCM,{'contrast','correlation','energy','homogeneity'}); %menyediakan nilai properti untuk gambar YAITU CONTRAST,ENERGY,HOMOGENETY, DAN CORELATION
    CON(n) = mean(stats.Contrast); %mengambil nilai properti kontras
    CORR(n) = mean(stats.Correlation); %mengambil nilai properti korelasi
    EN(n) = mean(stats.Energy);
    HOM(n) = mean(stats.Homogeneity);
    Mean(n) = mean2(Img);
    Standard_Deviation(n) = std2(Img);
    Entropy(n) = entropy(Img);
    RMS(n) = mean2(rms(Img));
    Variance(n) = mean2(var(double(Img)));
    a = sum(double(Img(:)));
    Smoothness(n) = 1-(1/(1+a));
    Kurtosis(n) = kurtosis(double(Img(:)));
    Skewness(n) = skewness(double(Img(:)));
    o = size(Img,1);
    p = size(Img,2);
    in_diff = 0;
    for i = 1:o
        for j = 1:p
            temp = Img(i,j)./(1+(i-j).^2);
            in_diff = in_diff+temp;
        end
    end
    IDM(n) = double(in_diff);
    
    urutan(n) = [n];
    X =[CON;CORR]';
    number = [urutan;CON;CORR;EN;HOM;Mean;Standard_Deviation;Entropy;RMS;Variance;Smoothness;Kurtosis;Skewness;IDM]';
    Header = {'Gambar ke-', 'Contrast', 'Corelation', 'energy', 'homogenity', 'Mean', 'Standar Deviasi', 'enthropy', 'RMS', 'Variance', 'Smoothness', 'Kurtosis','Skewness', 'IDM'}
    DataCell = num2cell(number);
    Output = [Header;DataCell]; %memasukkan ke data x
end

xlswrite('Training_data',Output,'Sheet1','B2');
save Training_data.m Output%menyimpann


