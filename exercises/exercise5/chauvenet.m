function [ idx ] = chauvenet( data )
mean = sum(data,1)./length(data);
centralizedData = data - repmat(mean,length(data),1);
variance = sum(centralizedData.^2)./length(data);

prob = exp(-centralizedData.^2./repmat(2*variance,length(data),1))...
    ./repmat(sqrt(2*pi*variance),length(data),1)*length(data);

idx = prob < 0.5;

end

