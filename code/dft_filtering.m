%% 1(b) DFT filtering 

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

% step 1 build filter H 128*128 
H= zeros(128,128);
H(62:68,62:68)=1/49; %(65,65) center

%step 2: zero pad both filter and img to 384*384 as fft requires even
%matrix 
ZP_img=zeros(384,384);
ZP_img(1:256,1:256)=img;

ZP_H= zeros(384,384);
ZP_H(1:128,1:128)=H;

% display zero padded original image
figure;
imshow(ZP_img,[]); title('1(b) zero padded input image');

% display zero padded impulse response image
figure;
imshow(ZP_H,[]); title('1(b) zero padded impulse response image');

%display centered DFT log magnitude spectrum 
figure;
imshow(log(1+abs(fftshift(fft2(ZP_img)))),[]);
title('1(b) Log-magnitude DFT of zero-padded input');

figure;
imshow(log(1+abs(fftshift(fft2(ZP_H)))),[]);
title('1(b) log magnitude DFT of zero-padded impulse response image')

output_b= zeros(384,384);
output_b= real(ifft2((fft2(ZP_img).*fft2(ZP_H))));

%display the zero padded output image 
figure;
imshow(output_b,[]);title('1(b) zero padded output image')

figure;
imshow(log(1+abs(fftshift(fft2(output_b)))),[]);
title('1(b) log magnitude DFT of zero padded output image')

%final image 
final_output=zeros(256,256)
final_output=output_b(65:320,65:320);

figure;
imshow(final_output,[]);title('1(b) final output image')

