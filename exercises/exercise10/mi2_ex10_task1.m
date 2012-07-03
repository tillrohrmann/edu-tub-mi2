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

k=5;
w = randn(2,k).*repmat(sqrt(varData),1,k)+repmat(meanData,1,k);
tmax=6;

error = zeros(tmax,k);

figure();

for t = 1:tmax
    dist = sqrt((repmat(w(1,:),length(data),1)-repmat(data(1,:)',1,k)).^2+...
    (repmat(w(2,:),length(data),1)-repmat(data(2,:)',1,k)).^2);

    [dist2Prototype,idx] = min(dist,[],2);
    
    subplot(2,3,t);
    visualizeData(w,data,idx);
    title(num2str(t));

    for i =1:k
        error(t,i) = 1/2/length(data)*sum(dist2Prototype(idx==i))/sum(idx==i);
        w(:,i) = sum(data(:,idx==i),2)/sum(idx==i);
    end
    
end

for i = 1:k
   figure();
   plot(1:tmax,error(:,i));
   title(strcat(['Empirical risk function:',num2str(w(:,i)')]));
end

dist = sqrt((repmat(w(1,:),length(data),1)-repmat(data(1,:)',1,k)).^2+...
(repmat(w(2,:),length(data),1)-repmat(data(2,:)',1,k)).^2);

[dist2Prototype,idx] = min(dist,[],2);

figure();
visualizeArea(w,[-3,3],[-1.5,2]);