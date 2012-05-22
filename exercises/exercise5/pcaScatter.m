function [PCs,V]=pcaScatter( data, strTitle )

% pca analysis
% centralize data
mean = sum(data,1)./repmat(size(data,1),1,2);

centralizedData = data - repmat(mean,size(data,1),1);

% calculate covariance matrix

C = centralizedData'*centralizedData./length(centralizedData);

[ PCs, V] = eigs(C,2);
% print projected Data

projectedData = centralizedData * PCs;

figure();
scatter(projectedData(:,1),projectedData(:,2));
title(strTitle);


end

