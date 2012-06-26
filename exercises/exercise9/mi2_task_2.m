%%%%%%%%%%
% MI2 - Exercise 9
%
% Task 2: Mean Field Annealing
%
% Jens Krenzin - 
% Till Rohrmann - 343756

close all;
clear all;
clc;

N = 6;

energy = @(S,W) -1/2*S'*W*S;

beta0 = 0.001;
tau = 1.15;
tmax = 100;
S = 2*rand(N,1)-1;

beta = beta0;

W = rand(N);
W = W+W';
W = W + diag(-diag(W));

E = zeros(tmax+1,1);
T = zeros(tmax+1,1);

for t = 1:tmax+1
    T(t) = 1/beta;
    E(t) = energy(S,W);
    node = ceil(N*rand());

    mean = W(node,:)*S;
    
    S(node)=tanh(beta*mean);
    
    beta = tau*beta;
end

figure();
plot(0:tmax,E);
title('Energy over time t');

figure();
plot(0:tmax,T);
title('Temperature over time t');











