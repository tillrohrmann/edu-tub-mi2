function [ pdf ] = getMarginalDensity( data )

pdf = @(x,h) sum(exp(-(repmat(x,length(data),1)-repmat(data,1,length(x))).^2/(2*h^2)))/(sqrt(2*pi*h^2)*length(data));

end

