function [ ] = showPC(strTitle, covarianceMatrix,patchSize, pcToShow )
[pcaMatrix,varianceMatrix] = eigs(covarianceMatrix,pcToShow);

figure();
m = floor(sqrt(pcToShow));
n = pcToShow/m;

for i = 1:pcToShow
    subplot(m,n,i);
    imshow(reshape(4*pcaMatrix(:,i),patchSize,patchSize));
    title(varianceMatrix(i,i));
end

suptitle(strTitle);

end

