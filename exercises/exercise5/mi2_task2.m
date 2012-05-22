% Machine Intelligence 2
% Exercise Sheet 4
% Task 4.2
%
% Jens Krenzin
% Till Rohrmann

close all;
clear all;
clc;

pathToData = 'PCAdata/pca4.csv';

dataset = importdata(pathToData);

data = dataset.data;

% remove outlier using the chauvenet criterion
data = removeOutlier(data);

[PCs,V,C] = pca(data);

%scree plot
figure();
plot(1:length(diag(V)),diag(V));
title('Scree plot');

% whiten the data

mean = sum(data,1)./length(data);
centralizedData = data - repmat(mean,length(data),1);
siD =  diag(1./sqrt(diag(V)));
Z = centralizedData*PCs*siD;

figure();
imagesc(C);
colorbar();
title('Covariance matrix');

figure();
imagesc(Z);
colorbar;
title('Whitened data');

figure();
imagesc(V);
colorbar;
title('Covariance matrix with principle components as a basis');


