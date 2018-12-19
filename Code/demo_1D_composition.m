clearvars
close all
clc 

load greasy.mat
fs=abs(fft(s));

% Do Harr decomposition
Ho=1/sqrt(2)*[1 +1];
[c1,d1]= do_comp(s,Ho);

% Calculate Fourier of the signal
fc1=abs(fft(c1));
fd1=abs(fft(d1));

f=figure;
f1= subplot('Position',[0.1 0.8 0.85 0.15]);
plot(s, 'color','r');
xlabel('Original Signal "s"');
set(f1,'YTickLabel',[]);

f2= subplot('Position',[0.1 0.55 0.85 0.15]);
plot(fs);
hold on;
% Draw vertical line at 4000
line([4000 4000],get(f2,'YLim'),'Color',[0 1 0])
set(f2,'YTickLabel',[]);
xlabel('Fourier coefficients of "s"');


f3= subplot('Position',[0.1 0.30 0.4 0.15]);
plot(c1, 'color','r');
xlabel('Low Pass Signal "c1"');
set(f3,'YTickLabel',[]);


f4= subplot('Position',[0.1 0.05 0.4 0.15]);
plot(fc1, 'color','b');
%xlabel('Fourier coefficients of "c1"');
% Draw vertical line at 2000
hold on
line([2000 2000],get(f4,'YLim'),'Color',[0 1 0])
set(f4,'YTickLabel',[]);

f5= subplot('Position',[0.55 0.30 0.4 0.15]);
plot(d1, 'color','r');
xlabel('Hi Pass Signal "d1"');
set(f5,'YTickLabel',[]);

f6= subplot('Position',[0.55 0.05 0.4 0.15]);
plot(fd1, 'color','b');
% Draw vertical line at 2000
hold on
line([2000 2000],get(f6,'YLim'),'Color',[0 1 0])
%xlabel('Fourier coefficients of "d1"');
set(f6,'YTickLabel',[]);

% Calculate result png name and directory
p = mfilename('fullpath');
[filepath,name,ext]=fileparts(p);
imageFile=fullfile(filepath,'../Results/',[name,'.png']);
saveas(f,imageFile)


% Check if our code gives same results as filterbank
direction=0;
s1=filterbank(s',1,Ho,direction);

disp('This must be equal to zero')
sum(s1-[c1 d1])

function [c,d]= do_comp(signal,H)
    % H is the low pass filter
    
    % Compute the Hi pass filter
    G = -1 * (-1).^(1:size(H,2)).*H;
    
    % convert s to Nx1 vector
    signal = reshape(signal,1,[]);
    L=size(signal,1);
    
    % Apply the filters
    D=pconv(G,signal);
    C=pconv(H,signal);
    
    % Take half values
    d=D(1:2:end);
    c=C(1:2:end);
    
end
