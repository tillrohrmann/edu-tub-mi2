% Machine Intelligence 2
% Exercise Sheet 3
% Task 3.1
%
% Jens Krenzin
% Till Rohrmann

close all;
clear all;
clc;

pathToyPCA = 'pca_datafiles/toypca/pca_data.dat';

data = importdata(pathToyPCA);

mean = sum(data)/length(data);

centeredData = [data(:,1)-mean(1,1),data(:,2)-mean(1,2)];
figure();
scatter(centeredData(:,1),centeredData(:,2));
title('Scatter of centered data');
covarianceMatrix = centeredData'*centeredData/length(centeredData);

% finding the eigenvalues and eigenvector
[pcaMatrix,varianceMatrix] = eig(covarianceMatrix);

%sort eigenvalues and matrix of eigenvectors in descending order
[sortedEigenvalues, sortOrder] = sort(diag(varianceMatrix),'descend');
varianceMatrix = diag(sortedEigenvalues);
pcaMatrix = pcaMatrix(:,sortOrder);

projectedData = centeredData*pcaMatrix;

figure();
scatter(projectedData(:,1),projectedData(:,2));
title('Scatter of projected data according to pc');

figure();
hold on;
reconstructedDataFull = projectedData*pcaMatrix';
reconstructedDataFirst = projectedData(:,1)*pcaMatrix(:,1)';
reconstructedDataSecond = projectedData(:,2)*pcaMatrix(:,2)';

scatter(reconstructedDataFull(:,1),reconstructedDataFull(:,2))
scatter(reconstructedDataFirst(:,1),reconstructedDataFirst(:,2));
scatter(reconstructedDataSecond(:,1),reconstructedDataSecond(:,2));

legend('All PCs','1st PC','2nd PC');

title('Scatter of reconstructed data');
hold off;
