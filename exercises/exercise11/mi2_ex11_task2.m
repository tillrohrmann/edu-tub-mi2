% Machine Intelligence 2
% Exercise Sheet 11
% Task 11.2
%
% Jens Krenzin
% Till Rohrmann

close all;
clear all;
clc;

P=1000;
N=5000;

data = rand(P,2).*repmat([2,1],P,1);

neighbourhood =@(q,p,sigma) exp(-(q-p).^2/2/sigma^2);

ks=[4,8,16,32,64,128,256];

learningRate = 1;
redSigma = 0.99;
redLearningRate = 0.99;

meanData = mean(data);

centralData = data - repmat(meanData,P,1);
covMatrix = (centralData'*centralData)/P;
[PCS,var] = eigs(covMatrix);

distances = zeros(numel(ks),1);

figure();
scatter(data(:,1),data(:,2));

for j=1:numel(ks)
   
    k=ks(j);
    sigma = log2(k);
   prototypes = repmat(meanData,k,1)+(rand(k,2)-0.5)*sqrt(var)*PCS';
%    plotPrototypes(prototypes);
   axis([0,2,0,1]);
   
   elements = randi(P,N,1);
   
   for i=1:N
       datapoint = data(elements(i),:);
       diff =  repmat(datapoint,k,1)-prototypes;
       distance = sum(diff.^2,2);
       
       [~,idx] = min(distance);
       deltaPrototypes  = learningRate*repmat(neighbourhood((1:k)',idx,sigma),1,2).*diff;
       prototypes = prototypes+deltaPrototypes;
   end
   figure();
   plot(prototypes(:,1),prototypes(:,2),'o-');
   title(['K=',num2str(k)]);
   axis([0,2,0,1]);
   drawnow;
   
   sigma = redSigma*sigma;
   learningRate = redLearningRate*learningRate;
   
   sumDist = 0;
   for i=1:P
       datapoint = data(i,:);
       diff = repmat(datapoint,k,1)-prototypes;
       distance = sum(diff.^2,2);
       [~,idx]=min(distance);
       distance(idx) = inf;
       [~,idx2] = min(distance);
       sumDist = sumDist + abs(idx2-idx);
   end
   
   distances(j) = sumDist/P;
end

figure();
semilogx(ks,distances);
title('distances');




