%% 2(b)Ideal Low-Pass Filter, Ucutoff = 64
close all; 
%  Build the ideal LPF in frequency domain 
U_cutoff = 64;
[U, V] = meshgrid(-128:127, -128:127);          % 256x256 frequency grid
HLtildeCenter = double(sqrt(U.^2 + V.^2) <= U_cutoff); % 1 inside circle, 0 outside
HLtilde = fftshift(HLtildeCenter);              % un-center for fft2 multiplication

%  Apply filter to all 3 images 
% Circular convolution: just multiply DFTs directly (no zero padding!)

% Filter original clean image
F_girl2    = fft2(girl2);
out_girl2  = real(ifft2(F_girl2 .* HLtilde));

% Filter hi-pass noisy image
F_hi       = fft2(girl2_hi);
out_hi     = real(ifft2(F_hi .* HLtilde));

% Filter broadband noisy image
F_bb       = fft2(girl2_bb);
out_bb     = real(ifft2(F_bb .* HLtilde));

%  Display all filtered images (full scale contrast) 
figure; imshow(out_girl2, []);
title('2(b) Filtered original girl2 - Ideal LPF');

figure; imshow(out_hi, []);
title('2(b) Filtered girl2Noise32Hi - Ideal LPF');

figure; imshow(out_bb, []);
title('2(b) Filtered girl2Noise32 - Ideal LPF');

%  Compute MSE (use floating point, NO rounding, NO contrast stretch!) 
MSE_girl2_b = mean(mean((out_girl2 - girl2).^2));
MSE_hi_b    = mean(mean((out_hi    - girl2).^2));
MSE_bb_b    = mean(mean((out_bb    - girl2).^2));

disp(['2(b) MSE filtered original  : ' num2str(MSE_girl2_b)]);
disp(['2(b) MSE filtered Noise32Hi : ' num2str(MSE_hi_b)]);
disp(['2(b) MSE filtered Noise32   : ' num2str(MSE_bb_b)]);

%  Compute ISNR (only for the 2 noisy images) 
% MSE of noisy inputs from part (a)
MSE_hi_input = mean(mean((girl2_hi - girl2).^2));
MSE_bb_input = mean(mean((girl2_bb - girl2).^2));

ISNR_hi_b = 10 * log10(MSE_hi_input / MSE_hi_b);
ISNR_bb_b = 10 * log10(MSE_bb_input / MSE_bb_b);

disp(['2(b) ISNR Noise32Hi : ' num2str(ISNR_hi_b) ' dB']);
disp(['2(b) ISNR Noise32   : ' num2str(ISNR_bb_b) ' dB']);

