x = load("Training_data", 'anyar'); %memuat file Training_data, variabel anyar
h = zeros(4, 13); %membuat matrik 0, dengan ordo 4x13
for i = 1:4 
    for j = 1:13
        temp = 0.0; %variabel sementara
        if i == 1 
            for k = 1:78
               temp = temp + anyar(k, j); %menjumlah data anyar baris 1-78, kolom 1-13
            end
            h(i, j) = temp/78; %menghitung rata-rata 
        elseif i == 2
            for k = 79:168
               temp = temp + anyar(k, j); %menjumlah data anyar baris 79-168, kolom 1-13
            end
            h(i, j) = temp/90; %menghitung rata-rata 
        elseif i == 3
            for k = 169:237
               temp = temp + anyar(k, j); %menjumlah data anyar baris 169-237, kolom 1-13
            end
            h(i, j) = temp/69; %menghitung rata-rata 
        else
            for k = 238:306
               temp = temp + anyar(k, j); %menjumlah data anyar baris 238-306, kolom 1-13
            end
            h(i, j) = temp/69; %menghitung rata-rata 
        end
    end
end
a = zeros(1, 4); %membuat matrik 0, dengan ordo 1x4

for k= 1:13
    for l = 1:4
        a(l) = h(l, k); %menyimpan hasil rata-rata dari keempat baris/keempat klaster
    end 
    %memberi judul pada nilai k
    if k == 1
        z = 'Contrast';
    elseif k == 2
        z = 'Corelation';
    elseif k == 3
        z = 'energy';
    elseif k == 4
        z = 'homogenity';
    elseif k == 5
        z = 'Mean';
    elseif k == 6
        z = 'Standar Deviasi';
    elseif k == 7
        z = 'enthropy';
    elseif k == 8
        z = 'RMS';
    elseif k == 9
        z = 'Variance';
    elseif k == 10
        z = 'Smoothness';
    elseif k == 11
        z = 'Kurtosis';
    elseif k == 12
        z = 'Skewness';
    else
        z = 'IDM';
    end
    figure, bar(a), title(z); %menampilkan data dalam bentuk diagram batang, dengan title z
end
