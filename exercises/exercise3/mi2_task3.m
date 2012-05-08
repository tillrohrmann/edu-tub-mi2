% Machine Intelligence 2
% Exercise Sheet 3
% Task 3.3
%
% Jens Krenzin
% Till Rohrmann

close all;
clear all;
clc;

standardDeviation = 0.1;
variance = standardDeviation*standardDeviation;
numberOfPoints = 30;
mean1 = [-0.5,-0.2];
mean2 = [0,0.6];
mean3 = [0.5,0];
numberOfPCs = 8;

%generate points: Since the coordinates of the point are uncorrelated
% and normally distributed, they are also independent and can be generated
% by drawing twice from a normal distribution and then adjusting the
% variance and the mean value
points1 = repmat(mean1,numberOfPoints,1) +...
    standardDeviation*randn(numberOfPoints,2);
points2 = repmat(mean2,numberOfPoints,1) + ...
    standardDeviation*randn(numberOfPoints,2);
points3 = repmat(mean3,numberOfPoints,1) + ...
    standardDeviation*randn(numberOfPoints,2);


hold on
scatter(points1(:,1),points1(:,2));
scatter(points2(:,1),points2(:,2));
scatter(points3(:,1),points3(:,2));
title('Scatter plot of generated points');
hold off

%KPCA using RBF kernel
datapoints = [points1;points2;points3];

% calculate unnormalized Kernel matrix
% x_alpha-x_beta
diff = kron(ones(length(datapoints),1),datapoints)-...
    kron(datapoints,ones(length(datapoints),1));
%||(x_alpha -x_beta)||^2
euclen=sum(diff.^2,2);

kernelMatrix = reshape(exp(-euclen/2/standardDeviation^2),...
    length(datapoints),length(datapoints));

%normalize to zero mean

p = length(datapoints);

kernelMatrix = kernelMatrix - 1/p*repmat(sum(kernelMatrix),p,1)-...
    1/p*repmat(sum(kernelMatrix,2),1,p)+...
    1/p^2*repmat(sum(sum(kernelMatrix)),p,p);

% solve the eigenvalue problem

[pcaMatrix,covarianceMatrix] = eigs(kernelMatrix,numberOfPCs);

%normalize eigenvectors to unit length
sqrtEigenvalues=sqrt(diag(covarianceMatrix));
lengthEigenvectors = sqrt(sum(pcaMatrix.^2)');
pcaMatrix = pcaMatrix * diag(1./(sqrt(p)*sqrtEigenvalues.*lengthEigenvectors));

%pcaMatrix contains the coefficients of the
numberOfGridPoints = 200;
xn = ((1:numberOfGridPoints)'-1)*2/(numberOfGridPoints-1)-1;

[X,Y] = meshgrid(xn,xn);

gridpoints = [ kron(xn,ones(numberOfGridPoints,1)),kron(ones(numberOfGridPoints,1),xn)];

%diff between gridpoints and datapoints

diff = kron(ones(numberOfGridPoints^2,1),datapoints)-...
    kron(gridpoints,ones(p,1));

euclen = sum(diff.^2,2);
projectionMatrix = pcaMatrix'*reshape(exp(-euclen/2/standardDeviation^2),p,numberOfGridPoints^2);

for i = 1:size(projectionMatrix,1)
   figure();
   contour(X,Y,reshape(projectionMatrix(i,:),numberOfGridPoints,numberOfGridPoints));
   title(strcat('Contour map of grid points projected to',' ', num2str(i),' th PC in feature space'));
end






