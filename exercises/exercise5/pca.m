function [ PCs, V,C ] = pca( data )

mean = sum(data,1)./length(data);
centralizedData = data - repmat(mean,length(data),1);

C = centralizedData'*centralizedData/length(data);

[PCs, V] = eig(C);

%sort eigenvalues and matrix of eigenvectors in descending order
[sortedEigenvalues, sortOrder] = sort(diag(V),'descend');
V = diag(sortedEigenvalues);
PCs = PCs(:,sortOrder);

end

