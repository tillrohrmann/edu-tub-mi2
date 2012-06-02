% Machine Intelligence 2
% Exercise Sheet 7
% Task 7.1
%
% Jens Krenzin
% Till Rohrmann

close all;
clear all;
clc;

pathToData = 'datafilesICA/distrib.mat';
bins = 20;

data = importdata(pathToData);

normal = data.normal;
laplacian = data.laplacian;
uniform = data.uniform;

plotDataMarginalDensity(normal,'Normal distribution',bins);
plotDataMarginalDensity(laplacian,'Laplacian distribution',bins);
plotDataMarginalDensity(uniform,'Uniform distribution',bins);

A = [4,3;2,1];

mNormal = A*normal;
mLaplacian = A*laplacian;
mUniform = A*uniform;

% center data

mcNormal = mNormal - repmat(mean(mNormal,2),1,length(mNormal));
mcLaplacian = mLaplacian - repmat(mean(mLaplacian,2),1,length(mLaplacian));
mcUniform = mUniform - repmat(mean(mUniform,2),1,length(mUniform));

plotDataMarginalDensity(mcNormal,'Mixed centered normal distribution',bins);
plotDataMarginalDensity(mcLaplacian,'Mixed centered  laplacian distribution',bins);
plotDataMarginalDensity(mcUniform,'Mixed centered uniform distribution',bins);

[PCsNormal, varNormal] = pca(mcNormal,2);
[PCsLaplacian, varLaplacian] = pca(mcLaplacian,2);
[PCsUniform, varUniform] = pca(mcUniform,2);

%projection

pNormal = PCsNormal'*mcNormal;
pLaplacian = PCsLaplacian'*mcLaplacian;
pUniform = PCsUniform'*mcUniform;

% whitening

wpNormal = diag(1./sqrt(diag(varNormal)))*pNormal;
wpLaplacian = diag(1./sqrt(diag(varLaplacian)))*pLaplacian;
wpUniform = diag(1./sqrt(diag(varUniform)))*pUniform;

plotDataMarginalDensity(wpNormal,'Whitened proj. mixed normal distribution',bins);
plotDataMarginalDensity(wpLaplacian,'Whitened proj. mixed laplacian distribution',bins);
plotDataMarginalDensity(wpUniform,'Whitened proj. mixed uniform distribution',bins);

thetas = (0:pi/50:2*pi);

kNormal = calcKurtosis(wpNormal,thetas);
kLaplacian = calcKurtosis(wpLaplacian,thetas);
kUniform = calcKurtosis(wpUniform,thetas);


[minNormal,maxNormal] = rotMinMax(wpNormal,kNormal,thetas);
[minLaplacian,maxLaplacian] = rotMinMax(wpLaplacian,kLaplacian,thetas);
[minUniform, maxUniform] = rotMinMax(wpUniform,kUniform,thetas);

plotDataMarginalDensity(minNormal,'Min kurtosis normal distribution',bins);
plotDataMarginalDensity(maxNormal,'Max kurtosis normal distribution',bins);
plotDataMarginalDensity(minLaplacian,'Min kurtosis laplacian distribution',bins);
plotDataMarginalDensity(maxLaplacian,'Max kurtosis laplacian distribution',bins);
plotDataMarginalDensity(minUniform,'Min kurtosis uniform distribution',bins);
plotDataMarginalDensity(maxUniform,'Max kurtosis uniform distribution',bins);

plotKurtosis(kNormal,thetas,'Kurtosis normal distribution');
plotKurtosis(kLaplacian,thetas,'Kurtosis laplacian distribution');
plotKurtosis(kUniform,thetas,'Kurtosis uniform distribution');
