clearvars
close all
clc 

% Basic setup
p = mfilename('fullpath');
[filepath,~]=fileparts(p);
n = 256;

% Images
images={'barb','boat','lena','flowers','hibiscus'};

% Parameters
L=8;
sigma = 10;
tau = .9/(L*sigma);
theta = 1;

% Destroy
rho=0.7;
Lambda = rand(n,n)>rho;
Phi = @(f) f.*Lambda;



for idx = 1:numel(images)
    f0=load_image(images{idx});
    f0 = rescale(crop(f0,n));
    y=Phi(f0);
    figure; imageplot(y); title(images{idx})
    
    fg1= figure('Name',images{idx});
    [repair1,~]=ImpaintingPrimalDual(y(:,:,1),100, sigma, tau, theta, Phi);
    [repair2,~]=ImpaintingPrimalDual(y(:,:,2),100, sigma, tau, theta, Phi);
    [repair3,~]=ImpaintingPrimalDual(y(:,:,3),100, sigma, tau, theta, Phi);
    repair=cat(3,repair1, repair2, repair3);
    
    subplot(1,3,1); imageplot(f0);    title('Original Image');
    subplot(1,3,2); imageplot(y);     title('Damaged Image');
    subplot(1,3,3); imageplot(repair); title('Impainting Image');
    
    filename= ['../Results/Inpainting_pdual_' images{idx} '_evolution.png'];
    imageFile=fullfile(filepath,filename);
    saveas(fg1,imageFile)
end