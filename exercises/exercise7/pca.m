function [ PCs, variances ] = pca( data, dim )

if(dim == 1)
   C = data'*data; 
else
    C = data*data';
end

C = C./size(data,dim);

[PCs, variances] = eig(C);

[var,idx] = sort(abs(diag(variances)),1,'descend');

PCs = PCs(:,idx);
variances = diag(var);

end

