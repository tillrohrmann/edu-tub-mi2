function [ ] = plotDataMarginalDensity( data,titleStr, bins )

figure();
subplot(1,2,1);
scatter(data(1,:),data(2,:));
axis equal;
subplot(2,2,2);
hist(data(1,:),bins);
title('Marginal density X1');
subplot(2,2,4);
hist(data(2,:),bins);
title('Marginal density X2');

suptitle(titleStr);

end

