clearvars
close all
clc

load greasy.mat
s=s';

% Filter Calculations
h0=1/sqrt(2)*[+1 +1];

direction=0;
s1=filterbank(s,1,h0,direction);
s2=filterbank(s,2,h0,direction);
s3=filterbank(s,3,h0,direction);

f= figure;
subplot(4,1,1); plot(s)
subplot(4,1,2); plot(s1)
hold on
line([4000 4000],get(gca,'YLim'),'Color',[0 1 0]);

subplot(4,1,3); plot(s2)
hold on
line([4000 4000],get(gca,'YLim'),'Color',[0 1 0]);
line([2000 2000],get(gca,'YLim'),'Color',[0 1 0]);

subplot(4,1,4); plot(s3)
hold on
line([4000 4000],get(gca,'YLim'),'Color',[0 1 0]);
line([2000 2000],get(gca,'YLim'),'Color',[0 1 0]);
line([1000 1000],get(gca,'YLim'),'Color',[0 1 0]);

direction =1;
s_r=filterbank(s3,3, h0, direction);

disp('This must be close to zero')
sum(s-s_r)


% Calculate result png name and directory
p = mfilename('fullpath');
[filepath,name,ext]=fileparts(p);
imageFile=fullfile(filepath,'../Results/',[name,'.png']);
saveas(gcf,imageFile)
