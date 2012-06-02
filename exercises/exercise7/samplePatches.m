function [ samples ] = samplePatches( path, numberPatches, patchSize )

files = textscan(ls(path),'%s');
files = files{1,1};

samples = zeros(patchSize*patchSize,numberPatches);

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
        samples(:,j+floor((i-1)*numberPatches/length(files))) = reshape(imData(ys(j):ys(j)+patchSize-1,...
            xs(j):xs(j)+patchSize-1),patchSize*patchSize,1);
    end 
end


end

