% Machine Intelligence 2
% Exercise Sheet 6
% Task 6.3
%
% Jens Krenzin
% Till Rohrmann

close all;
clear all;
clc;

pathToSound1 = 'sounds/sound1.dat';
pathToSound2 = 'sounds/sound2.dat';

sound1 = importdata(pathToSound1);
sound2 = importdata(pathToSound2);
s = [sound1, sound2]';

N = 2;
p = length(s);
learningRate = @(t) 0.0075;

% Random mixing matrix

A = rand(N,N);

x = A * s;

% permute data samples
[ ~ ,idx] = sort(rand(1,p));
% idx = 1:p;
perX = x(:,idx);

% Why do the samples have to be uncorrelated????? Ask Timm!!!


% center data to zero mean
mean = sum(perX,2)./length(perX);
perX = perX - repmat(mean,1,length(perX));

% Initializing Unmixing matrix

W = rand(N,N);

f = @(x) (exp(-x)-1)./(exp(-x)+1);

for i= 1:p
    sample = perX(:,i);
    GradientMatrix = inv(W)' + f(W*sample)*sample';
    W = W+learningRate(i)*GradientMatrix*(W'*W);
end

W
inv(A)

estimatedS = W*x;

% plot original sounds
figure();
scatter(s(1,:),s(2,:))
title('Original sounds');

% plot mixed sounds
figure();
scatter(x(1,:),x(2,:))
title('Mixed sounds');

% plot recovered sounds
figure();
scatter(estimatedS(1,:),estimatedS(2,:));
title('Recovered sounds');

figure();
% Correlations
subplot(2,2,1);
caxis([-1, 1]);
imagesc(corr(s',s'),[-1,1]);
title('Corr s,s');

subplot(2,2,2);
imagesc(corr(s',x'),[-1,1]);
title('Corr s,x');

subplot(2,2,3);
imagesc(corr(s',perX'),[-1,1]);
title('Corr s, permuted x');

corrSeS = corr(s',estimatedS');
subplot(2,2,4);
imagesc(corrSeS,[-1,1]);
title('Corr s, estimated S');

figure();
subplot(3,2,1);
spoints = linspace(0,1,p);
plot(spoints,s(1,:));
title('1st Original sound');

subplot(3,2,2);
plot(spoints,s(2,:));
title('2nd Original sound');

subplot(3,2,3);
plot(spoints,x(1,:));
title('1st mixed sound');

subplot(3,2,4);
plot(spoints,x(2,:));
title('2nd mixed sound');

if(norm(s(1,:)-estimatedS(1,:)) < norm(s(1,:)-estimatedS(2,:)))
subplot(3,2,5);
plot(spoints,estimatedS(1,:));
title('1st estimated sound');

subplot(3,2,6);
plot(spoints,estimatedS(2,:));
title('2nd estimated sound');
else
subplot(3,2,6);
plot(spoints,estimatedS(1,:));
title('1st estimated sound');

subplot(3,2,5);
plot(spoints,estimatedS(2,:));
title('2nd estimated sound');
    
end

figure();
plot(spoints,perX(1,:));
title('1st permuted mixed sound');

figure();
plot(spoints,perX(2,:));
title('2nd permuted mixed sound');


% soundsc(s(1,:));
% soundsc(s(2,:));
% 
% soundsc(x(1,:));
% soundsc(x(2,:));
% 
% soundsc(perX(1,:));
% soundsc(perX(2,:));
% 
% soundsc(estimatedS(1,:));
% soundsc(estimatedS(2,:));


