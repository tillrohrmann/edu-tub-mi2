clc;
clear all;
close all;

% --- 3.1 PCA: Toy Data ---
% a) Scatter Plot
toy_data = load('pca_data.dat');
X = toy_data(:,1);
Y = toy_data(:,2);
figure(1);
scatter(X,Y);
title('Data Samples');
legend('samples');
xlabel('x1');
ylabel('x2');
xlim([0 4]);
ylim([-4 0]);

% b) Scatter Plot + PCs
% Calculate covariance matrix and eigenvectors
C = cov(X,Y);
[V,D] = eig(C);
origin = [2,-2];
% Draw PCs in original coordinates with Scatter Plot
figure(2);
scatter(X,Y);
title('Data Samples with PCs');
xlabel('x1');
ylabel('x2');
hold on;
x=[origin(1);origin(1)+V(1,1)];
y=[origin(2);origin(2)+V(1,2)];
plot(x,y,'LineWidth',2,'Color','red');
x=[origin(1);origin(1)+V(2,1)];
y=[origin(2);origin(2)+V(2,2)];
plot(x,y,'LineWidth',2,'Color','green');
hold off;
xlim([0 4]);
ylim([-4 0]);
legend('samples','xa1','xa2');
% Use PCs as new coordinates
figure(3);
XYA = zeros(length(toy_data(:,1)),2);
for i=1:1:length(XYA)
    XYA(i,1) = V(1,:)*transpose(toy_data(i,:));
    XYA(i,2) = V(2,:)*transpose(toy_data(i,:));
end;
scatter(XYA(:,1),XYA(:,2));
title('PCs as new coordinates');
xlabel('xa1');
ylabel('xa2');
legend('samples');

% c) Reconstruction
XY_reconstruct_perfect = zeros(length(toy_data),length(toy_data(1,:)));
XY_reconstruct_xa1 = zeros(length(toy_data),length(toy_data(1,:)));
XY_reconstruct_xa2 = zeros(length(toy_data),length(toy_data(1,:)));

for i=1:1:length(XYA)
    XY_reconstruct_perfect(i,:) = XYA(i,1)*V(1,:) +  XYA(i,2)*V(2,:);
    XY_reconstruct_xa1(i,:) = XYA(i,1)*V(1,:);
    XY_reconstruct_xa2(i,:) = XYA(i,2)*V(2,:);
end;

figure(4);
scatter(XY_reconstruct_perfect(:,1),XY_reconstruct_perfect(:,2));
title('Fully reconstructed data samples');
legend('samples');
xlabel('x1');
ylabel('x2');
xlim([0 4]);
ylim([-4 0]);

figure(5);
scatter(XY_reconstruct_xa1(:,1),XY_reconstruct_xa1(:,2));
title('reconstructed data samples (only from xa1)');
legend('samples');
xlabel('x1');
ylabel('x2');

figure(6);
scatter(XY_reconstruct_xa2(:,1),XY_reconstruct_xa2(:,2));
title('reconstructed data samples (only from xa2)');
legend('samples');
xlabel('x1');
ylabel('x2');
