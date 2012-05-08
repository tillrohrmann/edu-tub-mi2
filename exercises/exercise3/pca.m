function [covarianceMatrix] = pca( path, numberPatches, patchSize )

% sampling from nature pictures
files = textscan(ls(path),'%s');
files = files{1,1};

samples = zeros(numberPatches,patchSize*patchSize);

for i = (1:length(files))
    imData = imread(files{i});
    
    numberSamplesPerImage = floor(i*numberPatches/length(files))-...
        floor((i-1)*numberPatches/length(files));
    %calculate starting point
    
    [height,width] = size(imData);
    
    heightRange = height - patchSize+1;
    widthRange = width-patchSize+1;
    
    xs=floor(rand(numberSamplesPerImage,1)*widthRange)+1;
    ys=floor(rand(numberSamplesPerImage,1)*heightRange)+1;
    
    for j = (1:numberSamplesPerImage)
        samples(j+floor((i-1)*numberPatches/length(files)),:) = reshape(imData(ys(j):ys(j)+patchSize-1,...
            xs(j):xs(j)+patchSize-1),1,patchSize*patchSize);
    end 
end

mean = sum(samples,numberPatches);
centeredSamples = zeros(numberPatches,patchSize*patchSize);

for i = (1:patchSize*patchSize)
    centeredSamples(:,i) = samples(:,i)-mean(i);
end

covarianceMatrix = centeredSamples'*centeredSamples;

end

