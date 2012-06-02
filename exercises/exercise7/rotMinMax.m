function [ minRot, maxRot ] = rotMinMax( data,kurtosis,thetas )

R = @(theta) [cos(theta), -sin(theta);sin(theta), cos(theta)];

[~,i] = min(kurtosis,[],2);

minRot = R(thetas(i(1)))*data;

[~,i] = max(kurtosis,[],2);
maxRot = R(thetas(i(1)))*data;


end

