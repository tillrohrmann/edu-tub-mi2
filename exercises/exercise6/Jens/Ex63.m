clc;
clear all;
close all;

% --- 6.3 ---
% ----------------------
% --- INITIALIZATION ---
% ----------------------

% --- Variables ---

s(1,:) = load('sound1.dat');
s(2,:) = load('sound2.dat');
samples = length(s);

% Play original sounds
disp('Original sounds');
soundsc(s(1,:));
soundsc(s(2,:));
pause(2.197);

% Mix sources
A_rand = rand(1,2);
A = [A_rand(1), 1-A_rand(1); 1-A_rand(2), A_rand(2)];
x = A*s;

% Play mixed sounds
disp('Mixed sounds');
soundsc(x(1,:));
soundsc(x(2,:));
pause(2.197);

% Permute x randomly
p = randperm(samples);
xp = zeros(2,samples);
for i=1:1:samples
    xp(i) = x(p(i));
end;
clear p;

% Play mixed permuted sounds
disp('Mixed permuted sounds');
soundsc(xp(1,:));
soundsc(xp(2,:));
pause(2.197);

% Calculate correlations
corr_s_x = corrcoef(s,xp)

% Center data
xp(1,:) = xp(1,:) - mean(xp(1,:));
xp(2,:) = xp(2,:) - mean(xp(2,:));

% Initialize W with random values
W_start = rand(2,2)
W = W_start;

% --------------------
% --- OPTIMIZATION ---
% --------------------
% Funktioniert noch nicht
% Learn W by "Natural Gradient Learning"
init_learning_rate = 2;


for t = 1:1:20;
    learning_rate = init_learning_rate/t;
    
    dW = zeros(2,2);
    for sm = 1:1:samples
        
        for i=1:1:2

            sum_wikxk = W(i,1)*xp(1,sm) + W(i,2)*xp(2,sm);

            for j=1:1:2
                
                sum_g = 0;
                
                for l=1:1:2

                    summand = 0;
                    if i == l
                        summand = summand + 1;
                    end;
                    sum_wlkxk = W(l,1)*xp(1,sm) + W(l,2)*xp(2,sm);
                    summand = logistic_function_deriv(sum_wikxk)*sum_wlkxk;
                    summand = summand*W(l,j);
                    sum_g = sum_g + summand;
                    
                end;
                dW(i,j) = learning_rate*sum_g;
            end;
        end;
        W = W + dW;
    end;
    W
end;
% ---------------
% --- RESULTS ---
% ---------------

%compare learned W with optimal W
W_end = W
W_optimal = inv(A)

% Use learned W to recover sources
s_est = W*x;

% Calculate correlations between true and estimated sources
corr_s_sest = corrcoef(s,s_est)

% Play recovered sounds
disp('Recovered sounds');
soundsc(s_est(1,:));
soundsc(s_est(2,:));

