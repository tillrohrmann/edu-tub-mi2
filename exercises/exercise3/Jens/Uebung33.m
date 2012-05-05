clc;
clear all;
close all;

% --- 3.3 Kernel PCA: Toy Data ---

% a) Create toy set
mux_1 = -0.5;
muy_1 = -0.2;

mux_2 = 0;
muy_2 = 0.6;

mux_3 = 0.5;
muy_3 = 0;

sigma = 0.1;

toy_set(1,1:30) = normrnd(mux_1,sigma,1,30);
toy_set(2,1:30) = normrnd(muy_1,sigma,1,30);
toy_set(1,31:60) = normrnd(mux_2,sigma,1,30);
toy_set(2,31:60) = normrnd(muy_2,sigma,1,30);
toy_set(1,61:90) = normrnd(mux_2,sigma,1,30);
toy_set(2,61:90) = normrnd(muy_2,sigma,1,30);

toy_set = transpose(toy_set);
X = toy_set(1:90,1);
Y = toy_set(1:90,2);

% Show toy set
figure(1);
scatter(X,Y);
title('Random points');
legend('Random points');
xlabel('x1');
ylabel('x2');

% b) Kernel PCA with RBF-Kernel
P = 90;

% Calculate kernel matrix
K_norm = zeros(90,90);
for alpha=1:1:90
    for beta=1:1:90
        
        % 1. term
        K_alpha_beta = rbf_kernel(toy_set(alpha,:),toy_set(beta,:),sigma);
        
        % --- not necessary because observations have mean=0 ---
        % 2. term
        %sum = 0;
        %for gamma=1:1:90
        %    sum = sum + rbf_kernel(toy_set(gamma,:),toy_set(beta,:),sigma);
        %end;
        %K_gamma_beta = sum/P;
        
        % 3. term
        %sum = 0;
        %for gamma=1:1:90
        %    sum = sum + rbf_kernel(toy_set(alpha,:),toy_set(gamma,:),sigma);
        %end;
        %K_alpha_gamma = sum/P;
        
        % 4. term
        %sum = 0;
        %for gamma=1:1:90
        %    for delta=1:1:90
        %        sum = sum + rbf_kernel(toy_set(gamma,:),toy_set(delta,:),sigma);
        %    end;
        %end;
        %K_gamma_delta = sum/(P*P);
        
        K_norm(alpha,beta) = K_alpha_beta;% - K_gamma_beta - K_alpha_gamma - K_gamma_delta;
        
    end;
end;

% Calculate coefficients and lambdas
[a_k,lambda_k] = eig(K_norm);

% c) Projection onto the first 8 eigenvectors

% Calculate first 8 eigenvectors
eigenvectors = zeros(8,2);
for k=1:1:8
    sum = [0,0];
    for beta = 1:1:P
        sum(1) = sum(1) + a_k(k,beta)*toy_set(beta,1);
        sum(2) = sum(2) + a_k(k,beta)*toy_set(beta,2);
    end;
    eigenvectors(k,1) = sum(1)/(sqrt( sum(1)*sum(1) + sum(2)*sum(2)));
    eigenvectors(k,2) = sum(2)/(sqrt( sum(1)*sum(1) + sum(2)*sum(2)));
end;

% Draw first 8 eigenvectors
figure(2);
scatter(X,Y);
origin = [-0.4,0.4];
title('Eigenvectors with random points');
xlabel('x1');
ylabel('x2');
hold on;
for k=1:1:8
    hsv = [k/8,1,1];
    rgb = hsv2rgb(hsv);
    x=[origin(1);origin(1)+eigenvectors(k,1)];
    y=[origin(2);origin(2)+eigenvectors(k,2)];
    plot(x,y,'LineWidth',2,'Color',rgb,'LineWidth',2);
end;
hold off;

% Generate test grid field
for i=1:1:25
    c = mod(i-1,5);
    r = floor((i-1)/5);
    test_grid(i,1) = r/5 - 0.8;
    test_grid(i,2) = c/5;
end;

figure(3);
scatter(test_grid(:,1),test_grid(:,2));
hold on;
for k = 1:1:8
    hsv = [k/8,1,1];
    rgb = hsv2rgb(hsv);
    x=[origin(1);origin(1)+eigenvectors(k,1)];
    y=[origin(2);origin(2)+eigenvectors(k,2)];
    plot(x,y,'LineWidth',2,'Color',rgb,'LineWidth',2);
end;
hold off;
title('Test grid with eigenvectors');
legend('grid points');
xlabel('x1');
ylabel('x2');
xlim([-1 0.2]);
ylim([-0.2 1]);

% Project grid field on eigenvectors
for i=1:1:25
    for k=1:1:8
        Projection(i,k) = eigenvectors(k,:)*transpose(test_grid(i,:));
    end;
end;


% Plot contour lines
figure(4);
hold on;
for k = 1:1:8
    hsv = [k/8,1,1];
    rgb = hsv2rgb(hsv);
    plot(Projection(:,k),'Color',rgb,'LineWidth',2);
end;
hold off;
title('Projection values of grid points');
xlabel('Point Nr.');
ylabel('Projection value');
