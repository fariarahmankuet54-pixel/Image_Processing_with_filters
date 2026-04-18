%% 1(c) zero_phase_filtering.m
close all;
fid= fopen('salesman.bin','rb')
if fid==-1
    error('cannot open file salesman.bin')
end
img=double(fread(fid,[256,256],'uint8'));
img=img.';
fclose(fid);

%display image 
figure;
imshow(img,[]);% auto contrast scaling
title('1(a) input image')

%step 1: build filter H 256*256 
H = zeros(256, 256);
H(126:132, 126:132) = 1/49; 
H2=fftshift(H);

%display H
figure;
imshow(H2,[]);title('1(c)zero phase impulse response image')

% 512*512 zero padded zero phase impulse response 
H2ZP= zeros (512,512);
H2ZP(1:128,1:128)=H2(1:128,1:128);
H2ZP(1:128,385:512)=H2(1:128,129:256);
H2ZP(385:512,1:128)= H2(129:256,1:128);
H2ZP(385:512,385:512)=H2(129:256,129:256);

% Display 512x512 zero-padded zero-phase filter
figure; imshow(H2ZP, []);
title('1(c) 512x512 zero-padded zero-phase filter h2ZP');

Y= zeros(512,512);
Y(1:256,1:256)=img;

Y_output= real(ifft2(fft2(Y).*fft2(H2ZP)));
% figure;
% imshow(Y_output,[]);

Y_crop = Y_output(1:256, 1:256);
figure;
imshow(Y_crop, []);
title('1(c) Final 256x256 output');

% Verify same as part (a)
disp(['(c): max difference from part (a): ' ...
    num2str(max(max(abs(Y_crop - output_img))))]);



disp(size(Y_crop))
disp(size(output_img))
