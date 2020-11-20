clc;clear;close all;
image_folder = 'Dataset Images'; %lokasi folder dari file image
filenames = dir(fullfile(image_folder, '*.jpg')); %menyimpan image sebagai list sehingga dapat dipanggil berulang kali
total_images=2; %banyaknya gambar yang digunakan yaitu 10, dan juga sebagai variable batas perulangan
for n = 1:total_images %melakukan looping sebanyak 10 image
    full_name = fullfile(image_folder, strcat('Apple (',num2str(n),').jpg')) ; %memanggil file image dengan mengubah angka menjadi berbentuk string
    Image = imread(full_name); %membaca file image
    %atur image
    I = imresize(Image,[300,400]);
    Img = imadjust(I,stretchlim(I));
    
    % Extract Features
    cform = makecform('srgb2lab');
    lab_he = applycform(Img,cform);
    %Classify the colors in a*b* colorspace using K means clustering.
    ab = double(lab_he(:,:,2:3));
    nrows = size(ab,1);
    ncols = size(ab,2);
    ab = reshape(ab,nrows*ncols,2);
    nColors = 3;
    [cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                          'Replicates',3);
    pixel_labels = reshape(cluster_idx,nrows,ncols);
    segmented_images = cell(1,4);
    rgb_label = repmat(pixel_labels,[1,1,3]);
    for k = 1:nColors
        colors = Img;
        colors(rgb_label ~= k) = 0;
        segmented_images{k} = colors;
    end

figure,subplot(2,3,2);imshow(Img);title('Original Image'); subplot(2,3,4);imshow(segmented_images{1});title('Cluster 1'); subplot(2,3,5);imshow(segmented_images{2});title('Cluster 2');
subplot(2,3,6);imshow(segmented_images{3});title('Cluster 3');
end