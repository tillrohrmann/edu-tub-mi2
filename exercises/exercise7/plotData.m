function [ ] = plotData( data, strTitle)

figure();

N = size(data,1);

for i = 1:N
   for j = 1:N
       subplot(N,N,(i-1)*N+j);
       if(i ~= j)
          scatter(data(i,:),data(j,:));
       else
          title(strcat(['X',num2str(i)]));
       end
   end
end

suptitle(strTitle);


end

