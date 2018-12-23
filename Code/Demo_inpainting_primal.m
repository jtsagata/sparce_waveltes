clearvars
close all

% Load lena
f= imread('lena.png');
f=double(rgb2gray(f));
n = 256;
f0 = rescale(crop(f,n));

rho=0.7;
Lambda = rand(n,n)>rho;
Phi = @(f) f.*Lambda;
y=Phi(f0);

% Functors
K = @(f) grad(f);
KS = @(u) - div(u);
Amplitude = @(u) sqrt(sum(u.^2,3));
F = @(u) sum(sum(Amplitude(u)));

ProxF  = @(u,lambda) max(0, 1-lambda./repmat(Amplitude(u), [1 1 2])).*u;
ProxFS = @(y,sigma) y - sigma*ProxF(y/sigma,1/sigma);
ProxG  = @(f,tau) f + Phi(y -Phi(f));

% Parameters
L=8;
sigma = 10;
tau = .9/(L*sigma);
theta = 1;

f=y;
g=K(y)*0;
f1=f;

NumFrames=100;
VideoResult = zeros(size(f,1),size(f,2),3,NumFrames);
od3 = repmat({':'},1,ndims(VideoResult)-1);
VideoResult(od3{:},1) = cat(3,f,f,f);

TVEnergy=zeros(NumFrames,1);
TVEnergy(1) =  F(K(f1));
for ii=2:NumFrames
    % Iteration
    fold = f;
    g = ProxFS( g+sigma*K(f1), sigma);
    f = ProxG(f-tau*KS(g), tau);
    f1 = f + theta * (f-fold);
    
    TVEnergy(ii) = F(K(f1));    
    f= f1;
    VideoResult(od3{:},ii) = cat(3,f,f,f);
end

%imageplot(f1)

movieFile='../Videos/lena_primal.avi';

movie=immovie(VideoResult);
myVideo = VideoWriter(movieFile);
open(myVideo);
writeVideo(myVideo, movie);
close(myVideo);

video_to_img_seq(VideoResult,'../Videos/lena_primal_frames.png');
