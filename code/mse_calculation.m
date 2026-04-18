%% 2(a)  Read, display, and compute MSE of all 3 images
close all;
%  Read original clean image 
fid = fopen('girl2.bin', 'rb');
girl2 = double(fread(fid, [256,256], 'uint8'))';
fclose(fid);

%  Read hi-pass noisy image 
fid = fopen('girl2Noise32Hi.bin', 'rb');
girl2_hi = double(fread(fid, [256,256], 'uint8'))';
fclose(fid);

%  Read broadband noisy image 
fid = fopen('girl2Noise32.bin', 'rb');
girl2_bb = double(fread(fid, [256,256], 'uint8'))';
fclose(fid);

%  Display all 3 images 
figure;
imshow(girl2, []);
title('girl2 - Original clean image');

figure;
imshow(girl2_hi, []);
title('girl2Noise32Hi - Hi-pass noise');

figure;
imshow(girl2_bb, []);
title('girl2Noise32 - Broadband noise');

%  Compute MSE 
% MSE formula: sum of (noisy - original)^2 / (M*N)
MSE_hi = mean(mean((girl2_hi - girl2).^2));
MSE_bb = mean(mean((girl2_bb - girl2).^2));

%  Display results 
disp(['MSE of girl2Noise32Hi : ' num2str(MSE_hi)]);
disp(['MSE of girl2Noise32   : ' num2str(MSE_bb)]);


