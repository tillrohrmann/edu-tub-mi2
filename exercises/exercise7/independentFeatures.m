function [] = independentFeatures( files, numberPatches, patchSize,independentFeatures2Show,strTitle)

samples =samplePatches(files,numberPatches,patchSize);

[A,~]=fastica(samples,'approach','symm','g','tanh');

M = floor(sqrt(independentFeatures2Show));
N = independentFeatures2Show/M;


figure();
for i = 1:M
    for j = 1:N
        subplot(M,N,(i-1)*N+j);
        imagesc(reshape(A(:,(i-1)*M+j),patchSize,patchSize));
    end
end
suptitle(strTitle);

end

