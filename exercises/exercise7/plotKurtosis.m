function [  ] = plotKurtosis( kurtosis,thetas, titleStr )

figure();

plot(thetas,kurtosis(1,:),thetas,kurtosis(2,:));
title(titleStr);
legend('X1','X2');

end

