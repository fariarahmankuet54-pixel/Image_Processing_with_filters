%% 2(c) - Gaussian LPF with Ucutoff = 64, Example 4 method
close all;
clc;
%  Step 1: Compute sigma 
U_cutoff_c = 64;
N = 256;
sigma_c = 0.19 * (N / U_cutoff_c);   % = 0.19 * 4 = 0.76
disp(['sigma = ' num2str(sigma_c)]);

%  Step 2: Build Gaussian filter in centered frequency domain 
[U, V] = meshgrid(-128:127, -128:127);
HtildeCenter = exp((-2*pi^2 * sigma_c^2) / (N^2) * (U.^2 + V.^2));

%  Step 3: Get zero-phase spatial impulse response 
Htilde = fftshift(HtildeCenter);     % un-center for ifft2
H      = ifft2(Htilde);              % go to space domain
H2     = fftshift(real(H));          % center> zero-phase impulse response

%  Step 4: Zero-pad H2 to 512x512 
ZPH2 = zeros(512, 512);
ZPH2(1:256, 1:256) = H2;

%  Helper: apply filter to one image 
% (will reuse this for all 3 images)

% Zero-pad and filter original girl2
ZP_g2 = zeros(512,512);  ZP_g2(1:256,1:256) = girl2;
Y_g2  = real(ifft2(fft2(ZP_g2) .* fft2(ZPH2)));
out_girl2_c = Y_g2(129:384, 129:384);    % crop 256x256

% Zero-pad and filter hi-pass noisy image
ZP_hi = zeros(512,512);  ZP_hi(1:256,1:256) = girl2_hi;
Y_hi  = real(ifft2(fft2(ZP_hi) .* fft2(ZPH2)));
out_hi_c = Y_hi(129:384, 129:384);

% Zero-pad and filter broadband noisy image
ZP_bb = zeros(512,512);  ZP_bb(1:256,1:256) = girl2_bb;
Y_bb  = real(ifft2(fft2(ZP_bb) .* fft2(ZPH2)));
out_bb_c = Y_bb(129:384, 129:384);

%  Display all filtered images 
figure; imshow(out_girl2_c, []);
title('2(c) Filtered original girl2 - Gaussian LPF U=64');

figure; imshow(out_hi_c, []);
title('2(c) Filtered girl2Noise32Hi - Gaussian LPF U=64');

figure; imshow(out_bb_c, []);
title('2(c) Filtered girl2Noise32 - Gaussian LPF U=64');

%  Compute MSE (floating point only, no rounding!) 
MSE_girl2_c = mean(mean((out_girl2_c - girl2).^2));
MSE_hi_c    = mean(mean((out_hi_c    - girl2).^2));
MSE_bb_c    = mean(mean((out_bb_c    - girl2).^2));

disp(['2(c) MSE filtered original  : ' num2str(MSE_girl2_c)]);
disp(['2(c) MSE filtered Noise32Hi : ' num2str(MSE_hi_c)]);
disp(['2(c) MSE filtered Noise32   : ' num2str(MSE_bb_c)]);

%  Compute ISNR for 2 noisy images 
MSE_hi_input = mean(mean((girl2_hi - girl2).^2));
MSE_bb_input = mean(mean((girl2_bb - girl2).^2));

ISNR_hi_c = 10 * log10(MSE_hi_input / MSE_hi_c);
ISNR_bb_c = 10 * log10(MSE_bb_input / MSE_bb_c);

disp(['2(c) ISNR Noise32Hi : ' num2str(ISNR_hi_c) ' dB']);
disp(['2(c) ISNR Noise32   : ' num2str(ISNR_bb_c) ' dB']);
