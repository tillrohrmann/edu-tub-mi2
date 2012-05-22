% Machine Intelligence 2
% Exercise Sheet 4
% Task 4.1
%
% Jens Krenzin
% Till Rohrmann

close all;
clear all;
clc;

pathToDataset = 'PCAdata/pca2.csv';
coeff = 3;

dataset = importdata(pathToDataset);

handle = figure();
hold on 
data = dataset.data;
mean = sum(data,1)./repmat(size(data,1),1,2);
hold off

centralizedData = data - repmat(mean,size(data,1),1);
scatter(centralizedData(:,1),centralizedData(:,2));
title('Input data');

[PCs1 ] = pcaScatter(dataset.data,'Projection of all datapoints');

%remove element 157 and 17
subsetData = dataset.data;
subsetData(157,:)= [];
subsetData(17,:) = [];
[PCs2] = pcaScatter(subsetData, 'Projection without observation 17 and 157');

figure(handle);

hold on
quiver(zeros(2,1),zeros(2,1),coeff*PCs1(1,:)',coeff*PCs1(2,:)');
quiver(zeros(2,1),zeros(2,1),coeff*PCs2(1,:)',coeff*PCs2(2,:)');
legend('','All','No outliers');
hold off
