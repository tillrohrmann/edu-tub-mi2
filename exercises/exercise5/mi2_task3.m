% Machine Intelligence 2
% Exercise Sheet 3
% Task 4.3
%
% Jens Krenzin
% Till Rohrmann

close all;
clear all;
clc;

pathToData = 'PCAdata/pca2b.csv';

dataset = importdata(pathToData);

data = dataset.data;

[PCs,V,C] = pca(data);

mean = sum(data)/length(data);
centralizedData = data-repmat(mean,length(data),1);

% TODO: marginal density of data
marginalDensityX = getMarginalDensity(centralizedData(:,1));
marginalDensityY = getMarginalDensity(centralizedData(:,2));

x= -4:0.01:5;
h=0.5;
figure();
plot(x,marginalDensityX(x,h));
title('Marginal density X1');

figure();
plot(x,marginalDensityY(x,h));
title('Marginal density X2');

projectedData = centralizedData*PCs;
figure();
scatter(centralizedData(:,1),centralizedData(:,2));
title('Centralized input data');
figure();
scatter(projectedData(:,1),projectedData(:,2));
title('Projected data onto the PCs');

% whitened variables

isD = diag(1./sqrt(diag(V)));
Z = centralizedData*PCs*isD;

CZ = Z'*Z./length(Z);

alpha = pi/4;
R = [cos(alpha), -sin(alpha);sin(alpha), cos(alpha)];

RZ = (R*Z')';

CR = RZ'*RZ./length(RZ);

figure();
imagesc(C);
colorbar;
title('Covariance matrix');

figure();
imagesc(CZ);
colorbar;
title('Covariance matrix whitened variables');

figure();
imagesc(CR);
colorbar;
title('Covariance matrix rotated whitened variables');

marginalDensityZ1 = getMarginalDensity(Z(:,1));
marginalDensityZ2 = getMarginalDensity(Z(:,2));

marginalDensityRZ1 = getMarginalDensity(RZ(:,1));
marginalDensityRZ2 = getMarginalDensity(RZ(:,2));

figure();
plot(x,marginalDensityZ1(x,h),x,marginalDensityRZ1(x,h),'-r');
legend('Whitened','Rotated');
title('Marginal density of X1');

figure();
plot(x,marginalDensityZ2(x,h),x,marginalDensityRZ2(x,h),'-r');
legend('Whitened','Rotated');
title('Marginal density of X2');


figure();
hold on
scatter(projectedData(:,1),projectedData(:,2),'r');
scatter(Z(:,1),Z(:,2),'g');
title('Scatter plot');
legend('Projected','Whitened');
hold off
