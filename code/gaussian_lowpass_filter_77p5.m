%% 2(d) - Gaussian LPF with Ucutoff = 77.5 (same method as 2c, different cutoff)

%  Step 1: Compute new sigma for U_cutoff = 77.5 
U_cutoff_d = 77.5;
N = 256;
sigma_d = 0.19 * (N / U_cutoff_d);    % = 0.19 * 3.303 = 0.6277
disp(['2(d) sigma = ' num2str(sigma_d)]);

%  Step 2: Build Gaussian filter in centered frequency domain 
[U, V] = meshgrid(-128:127, -128:127);
HtildeCenter_d = exp((-2*pi^2 * sigma_d^2) / (N^2) * (U.^2 + V.^2));

%  Step 3: Get zero-phase spatial impulse response 
Htilde_d = fftshift(HtildeCenter_d);   % un-center
H_d      = ifft2(Htilde_d);            % go to space domain
H2_d     = fftshift(real(H_d));        % center > zero-phase impulse response

%  Step 4: Zero-pad H2 to 512x512 
ZPH2_d = zeros(512, 512);
ZPH2_d(1:256, 1:256) = H2_d;

%  Step 5: Filter all 3 images 

% Filter original girl2
ZP_g2 = zeros(512,512);
ZP_g2(1:256,1:256) = girl2;
Y_g2_d = real(ifft2(fft2(ZP_g2) .* fft2(ZPH2_d)));
out_girl2_d = Y_g2_d(129:384, 129:384);

% Filter hi-pass noisy image
ZP_hi = zeros(512,512);
ZP_hi(1:256,1:256) = girl2_hi;
Y_hi_d = real(ifft2(fft2(ZP_hi) .* fft2(ZPH2_d)));
out_hi_d = Y_hi_d(129:384, 129:384);

% Filter broadband noisy image
ZP_bb = zeros(512,512);
ZP_bb(1:256,1:256) = girl2_bb;
Y_bb_d = real(ifft2(fft2(ZP_bb) .* fft2(ZPH2_d)));
out_bb_d = Y_bb_d(129:384, 129:384);

%  Display all filtered images 
figure; imshow(out_girl2_d, []);
title('2(d) Filtered original girl2 - Gaussian LPF U=77.5');

figure; imshow(out_hi_d, []);
title('2(d) Filtered girl2Noise32Hi - Gaussian LPF U=77.5');

figure; imshow(out_bb_d, []);
title('2(d) Filtered girl2Noise32 - Gaussian LPF U=77.5');

%  Compute MSE (floating point only!) 
MSE_girl2_d = mean(mean((out_girl2_d - girl2).^2));
MSE_hi_d    = mean(mean((out_hi_d    - girl2).^2));
MSE_bb_d    = mean(mean((out_bb_d    - girl2).^2));

disp(['2(d) MSE filtered original  : ' num2str(MSE_girl2_d)]);
disp(['2(d) MSE filtered Noise32Hi : ' num2str(MSE_hi_d)]);
disp(['2(d) MSE filtered Noise32   : ' num2str(MSE_bb_d)]);

%  Compute ISNR for 2 noisy images 
MSE_hi_input = mean(mean((girl2_hi - girl2).^2));
MSE_bb_input = mean(mean((girl2_bb - girl2).^2));

ISNR_hi_d = 10 * log10(MSE_hi_input / MSE_hi_d);
ISNR_bb_d = 10 * log10(MSE_bb_input / MSE_bb_d);

disp(['2(d) ISNR Noise32Hi : ' num2str(ISNR_hi_d) ' dB']);
disp(['2(d) ISNR Noise32   : ' num2str(ISNR_bb_d) ' dB']);
