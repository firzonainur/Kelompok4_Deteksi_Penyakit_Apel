clc;clear;close all;
image_folder = 'Dataset Images'; %lokasi folder dari file image
image_folder2 = 'gambar'; %lokasi folder dari gambar yang telah diolah
filenames = dir(fullfile(image_folder, '*.jpg')); %menyimpan image sebagai list sehingga dapat dipanggil berulang kali
total_images=102; %banyaknya gambar yang digunakan yaitu 102, dan juga sebagai variable batas perulangan
z = 1; %variabel untuk penomoran gambar baru
for n = 1:total_images %melakukan looping sebanyak total_images
    full_name = fullfile(image_folder, strcat('Apple (',num2str(n),').jpg')) ; %memanggil file image dengan mengubah angka menjadi berbentuk string
    Image = imread(full_name); %membaca file image
    %atur image
    I = imresize(Image,[300,400]); %mengubah ukuran gambar 
    Img = imadjust(I,stretchlim(I)); %meningkatkan kontras gambar   % modul 2
    
    % Extract Features %modul 3
    cform = makecform('srgb2lab'); %membuat struktur tarnsformasi warna
    lab_he = applycform(Img,cform); %mengubah ruang warna gambar dari rgb ke lab
    %Classify the colors in a*b* colorspace using K means clustering.
    ab = double(lab_he(:,:,2:3));
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
        colors = Img;
        colors(rgb_label ~= k) = 0; 
        segmented_images{k} = colors;
        imwrite(segmented_images{k}, fullfile(image_folder2, strcat('Apple(', num2str(z), ').jpg'))); %menyimpan gambar dan memberi nama baru pada gambar hasil segmentasi
        z = z+1; %menambah z, sehingga nomor gambar bertambah
     end

% figure,subplot(2,3,2);imshow(Img);
% title('Original Image'); 
% subplot(2,3,4);imshow(segmented_images{1});title('Cluster 1'); 
% subplot(2,3,5);imshow(segmented_images{2});title('Cluster 2');
% subplot(2,3,6);imshow(segmented_images{3});title('Cluster 3');



end