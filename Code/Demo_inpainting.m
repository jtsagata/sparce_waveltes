%Work: Inpainting using Sparse Regularization
clear all
close all
clc
%%
name = 'lena';
n = 256;
f0 = load_image(name);
f0 = rescale(crop(f0,n));
rho = .5;%for corrupting image
Lambda = rand(n,n)>rho;
Phi = @(f)f.*Lambda;

y = Phi(f0);
imageplot(y);
%%%

SoftThresh = @(x,T)x.*max(0, 1-T./max(abs(x),1e-10));

Jmax = log2(n)-1;
Jmin = Jmax-3;
options.ti = 0; % use orthogonality.
Psi = @(a)perform_wavelet_transf(a, Jmin, -1,options);
PsiS = @(f)perform_wavelet_transf(f, Jmin, +1,options);
SoftThreshPsi = @(f,T)Psi(SoftThresh(PsiS(f),T));

temp1=y;
temp2=y;
t=linspace(5,0.1,30);
for ii=1:30
    R1=SoftThreshPsi(temp1,t(ii));;
    R2=SoftThreshPsi(temp2,.1);
    temp1=y+not(Lambda).*R1 ;
    temp2=y+not(Lambda).*R2 ;
end

SNR1=snr(f0,temp1);
SNR2=snr(f0,temp2);
figure;%imageplot([y clamp(temp1) clamp(temp2)] );
subplot(1,3,1); imageplot(y); title('noisy lena');
subplot(1,3,2); imageplot(temp1); title(['Adaptive SNR ' num2str(SNR1)]);
subplot(1,3,3); imageplot(clamp(temp1)); title(['Fixed ' num2str(SNR2)]);


% Calculate result png name and directory
p = mfilename('fullpath');
[filepath,name,ext]=fileparts(p);
imageFile=fullfile(filepath,'../Results/inpainint_sparce.png');
saveas(gcf,imageFile)
