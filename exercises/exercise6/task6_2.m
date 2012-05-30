% Machine Intelligence 2
% Exercise Sheet 6
% Task 6.2
%
% Jens Krenzin
% Till Rohrmann

close all;
clear all;
clc;


numberSamples = 500;
b = 1;
mu = 1;
lborder=-2;
rborder =4;
bins = 20;
resolution = 0.2;
histEdges = lborder:resolution:rborder;

resolutionUniform=0.1;
histEdgesUniform=0:resolutionUniform:1;

transformation = @(y,mu,b) sign(1/2-y)*b.*log(1-2*abs(y-1/2))+mu;
laplace = @(x,mu,b) 1/2/b*exp(-abs(x-mu)./b);

ys = rand(numberSamples,1);

xs = transformation(ys,mu,b);

xvalues = lborder:0.001:rborder;

binValues = histc(xs,histEdges);
binValuesUniform=histc(ys,histEdgesUniform);

figure();
bar(histEdgesUniform(1:end-1)+resolutionUniform/2,binValuesUniform(1:end-1)./numberSamples/resolutionUniform,1);
title('Probability density of uniformly sampled variable');
axis tight;

figure();
hold on
bar(histEdges(1:end-1)+resolution/2,binValues(1:end-1)./numberSamples/resolution,'b');
plot(xvalues,laplace(xvalues,mu,b),'r');
title('Probability density of transformed varialbe');
legend('Approximation','Exact');
hold off