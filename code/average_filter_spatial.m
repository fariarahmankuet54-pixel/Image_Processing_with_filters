clear all;
close all;
clc;

%% Average Filter (Spatial Domain)

fid = fopen('salesman.bin','rb');
if fid == -1
    error('cannot open file salesman.bin')
end

img = double(fread(fid,[256,256],'uint8'));
img = img.';
fclose(fid);

figure;
imshow(img,[]); % it does the contrast stretching 
title('Input image');

ZP_img = zeros(262,262);
ZP_img(4:259,4:259) = img;

output_img = zeros(256,256);

for m = 1:256
    for n = 1:256
        window = ZP_img(m:m+6,n:n+6);
        output_img(m,n) = sum(window(:))/49;
    end
end

figure
imshow(output_img,[]);
title('7x7 Average Filter Output');
