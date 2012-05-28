clc;
clear all;
close all;

% --- 6.2 ---
elements = 500;

% Generate input samples
inputSamples = 2*rand(1,elements);
figure();
hist(inputSamples);
title('Uniformly distributed input samples');

% Generate output samples
mean = 1;
var = 2;
b = sqrt(var/2);
outputSamples = zeros(1,elements);
for i=1:1:elements
    outputSamples(i) = Fi(inputSamples(i),mean,b);
end;
figure();
hist(outputSamples);
title('Laplacian distributed output samples');