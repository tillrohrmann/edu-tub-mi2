% Machine Intelligence 2
% Exercise Sheet 10
% Task 10.1
%
% Jens Krenzin
% Till Rohrmann

close all;
clear all;
clc;

data = importdata('cluster.dat');

meanData = mean(data,2);
varData = sum((data-repmat(meanData,1,length(data))).^2,2)/length(data);

k=4;
w = randn(2,k).*repmat(sqrt(varData),1,k)+repmat(meanData,1,k);

eta=0.5;
tau = 0.75;

tmax = length(data);

dist = sqrt((repmat(w(1,:),length(data),1)-repmat(data(1,:)',1,k)).^2+...
(repmat(w(2,:),length(data),1)-repmat(data(2,:)',1,k)).^2);

[~,idx] = min(dist,[],2);
figure();
visualizeData(w,data,idx);

error = zeros(tmax,k);

for t = 1:tmax/4
    datapoint = data(:,t);
    dist = sqrt(sum((repmat(datapoint,1,k)-w).^2));
    
    [~,idx]=min(dist);
    
    w(:,idx) = w(:,idx)+eta*(datapoint-w(:,idx));
    
    dist = sqrt((repmat(w(1,:),length(data),1)-repmat(data(1,:)',1,k)).^2+...
        (repmat(w(2,:),length(data),1)-repmat(data(2,:)',1,k)).^2);

        [dist2Prototype,idx] = min(dist,[],2);
    
    if(mod(t,50)==0)
        
        figure();
        visualizeData(w,data,idx);
    end
    
     for i =1:k
        error(t,i) = 1/2/length(data)*sum(dist2Prototype(idx==i))/sum(idx==i);
    end
end

for t=tmax/4+1:tmax
   eta = tau*eta;
   datapoint = data(:,t);
    dist = sqrt(sum((repmat(datapoint,1,k)-w).^2));

    [~,idx]=min(dist);

    w(:,idx) = w(:,idx)+eta*(datapoint-w(:,idx));
     dist = sqrt((repmat(w(1,:),length(data),1)-repmat(data(1,:)',1,k)).^2+...
        (repmat(w(2,:),length(data),1)-repmat(data(2,:)',1,k)).^2);

        [dist2Prototype,idx] = min(dist,[],2);
    
    if(mod(t,50)==0)
       
        figure();
        visualizeData(w,data,idx);
    end
    
     for i =1:k
        error(t,i) = 1/2/length(data)*sum(dist2Prototype(idx==i))/sum(idx==i);
    end
end

dist = sqrt((repmat(w(1,:),length(data),1)-repmat(data(1,:)',1,k)).^2+...
(repmat(w(2,:),length(data),1)-repmat(data(2,:)',1,k)).^2);

[~,idx] = min(dist,[],2);
figure();
visualizeData(w,data,idx);

for i = 1:k
   figure();
   plot(1:tmax,error(:,i));
   title(strcat(['Empirical risk function:',num2str(w(:,i)')]));
end
