% Machine Intelligence 2
% Exercise Sheet 7
% Task 7.2
%
% Jens Krenzin
% Till Rohrmann

close all;
clear all;
clc;

t = 0:0.05:50;

s = [4*sin(t-3);mod(t+5,10);...
    -14*(cos(2*t)>0)];

A = [2,-3,-4;7,5,1;-4,7,5];

x = A*s;

plotData(s,'Original data');
plotData(x,'Mixed data');

whitenedData = fastica(x,'only','white');

plotData(whitenedData,'Whitened data');

ics = fastica(x);

plotData(ics,'Estimated sources');

