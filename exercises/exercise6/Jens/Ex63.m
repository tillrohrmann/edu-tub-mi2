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
figure();
subplot(2,1,1);
plot(s(1,:),'b');
title('original sound 1');
subplot(2,1,2);
plot(s(2,:),'b');
title('original sound 2');
soundsc(s(1,:));
soundsc(s(2,:));
pause(2.197);

% Mix sources
A_rand = rand(1,1);
A = [0.7, 0.3; 0.3, 0.7]
x = A*s;

% Play mixed sounds
disp('Mixed sounds');
figure();
subplot(2,1,1);
plot(x(1,:),'r');
title('mixed sound 1');
subplot(2,1,2);
plot(x(2,:),'r');
title('mixed sound 2');
soundsc(x(1,:));
soundsc(x(2,:));
pause(2.197);

% Permute x randomly
p = randperm(samples);
xp = zeros(2,samples);
for i=1:1:samples
    xp(1,i) = x(1,(p(i)));
    xp(2,i) = x(2,(p(i)));
end;
clear p;

% Play mixed permuted sounds
disp('Mixed permuted sounds');
figure();
subplot(2,1,1);
plot(xp(1,:),'m');
title('mixed permuted sound 1');
subplot(2,1,2);
plot(xp(2,:),'m');
title('mixed permuted sound 2');
soundsc(xp(1,:));
soundsc(xp(2,:));
pause(2.197);

% Calculate correlations
corr_s_x = corrcoef(s,xp)

% Center data
xp(1,:) = xp(1,:) - mean(xp(1,:));
xp(2,:) = xp(2,:) - mean(xp(2,:));

% Initialize W with random values
W_start = [2, -1; -1, 2]
W = W_start;

% --------------------
% --- OPTIMIZATION ---
% --------------------
% Learn W by "Natural Gradient Learning"
start_eta = 0.02;

for t = 1:1:samples
        eta = start_eta/t;
        dW = zeros(2,2);
        WX = W*xp(t);
        dW(1,1) = eta*( W(1,1)*(1+logistic_function_deriv(WX(1)))*WX(1) + W(2,1)*(  logistic_function_deriv(WX(1)))*WX(2) );
        dW(1,2) = eta*( W(1,2)*(1+logistic_function_deriv(WX(1)))*WX(1) + W(2,2)*(  logistic_function_deriv(WX(1)))*WX(2) );
        dW(2,1) = eta*( W(1,1)*(  logistic_function_deriv(WX(2)))*WX(1) + W(2,1)*(1+logistic_function_deriv(WX(2)))*WX(2) );
        dW(2,2) = eta*( W(1,2)*(  logistic_function_deriv(WX(2)))*WX(1) + W(2,2)*(1+logistic_function_deriv(WX(2)))*WX(2) );
        W = W + dW;
        W(1,:) = W(1,:)/sum(W(1,:));
        W(2,:) = W(2,:)/sum(W(2,:));
end;

% ---------------
% --- RESULTS ---
% ---------------

%compare learned W with optimal W
W_end = W
W_optimal = inv(A)
diff = sum(sum(abs(W_optimal - W_end)))

% Use learned W to recover sources
s_est = W*x;

% Calculate correlations between true and estimated sources
corr_s_sest = corrcoef(s,s_est)

% Play recovered sounds
disp('Recovered sounds');
figure();
subplot(2,1,1);
plot(s_est(1,:),'g');
ylim([-5 5]);
title('recovered sound 1');
subplot(2,1,2);
plot(s_est(2,:),'g');
title('recovered sound 2');
soundsc(s_est(1,:));
soundsc(s_est(2,:));
