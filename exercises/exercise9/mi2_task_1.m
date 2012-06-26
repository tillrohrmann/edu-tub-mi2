%%%%%%%%%%
% MI2 - Exercise 9
%
% Task 1: Simulated Annealing
%
% Jens Krenzin - 
% Till Rohrmann - 343756

close all;
clear all;
clc;

N = 6;


energy = @(S,W) -1/2*S'*W*S;
prob = @(S,W,beta) 1/Z(N,W,beta,energy)*exp(-beta*energy(S,W));

beta0 = 0.001;
tau = 1.15;
tmax = 100;
S = randsrc(N,1);

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

    Enode = -1/2*S(node)*(W(node,:)*S);
    Emnode = -Enode;

    deltaE = Emnode - Enode;

    flipProb = (1+exp(beta*deltaE))^-1;
    
    if(rand() <= flipProb)
        S(node) = -S(node);
    end
    
    beta = tau*beta;
end

figure();
plot(0:tmax,E);
title('Energy over time t');

figure();
plot(0:tmax,T);
title('Temperature over time t');

betas = [0.001,1];

Es= zeros(2^N,1);
P = zeros(2^N,length(betas));

state = -1*ones(N,1);

for i = 1:2^N
   Es(i) = energy(state,W);
   for j = 1:length(betas)
      P(i,j) = prob(state,W,betas(j)); 
   end
   for j=1:N
      if(state(j) == -1)
          state(j) = 1;
          break;
      else
          state(j) = -1;
      end
   end
end

figure();
bar(1:2^N,Es);
title('Energy of all states');

for i=1:length(betas)
   figure();
   bar(1:2^N,P(:,i));
   title(strcat(['Probability with beta=',num2str(betas(i))]));
end











