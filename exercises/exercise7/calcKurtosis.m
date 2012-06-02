function [ result ] = calcKurtosis( data,thetas )

kurt = @(x) mean(x.^4,2) -3*mean(x.^2,2).^2;
R = @(theta) [cos(theta), -sin(theta);sin(theta), cos(theta)];

result = zeros(size(data,1),length(thetas));
i = 1;
for theta = thetas
    result(:,i) = kurt(R(theta)*data);
    i=i+1;
end

end

