clc;
clear all;
close all;

% --- Set Parameters ---
%standard_deviation = 0.05;
standard_deviation = 0.1;
%P = 100;
P = 500;
windowSizes = 1:1:20;

% --- 3.1 - Data ---

% 1) Load image
img_in = imread('testimg.jpg','jpg');
figure(1);
imshow(img_in);
title('Input Image');
img_in_d = im2double(img_in);

% 2) Add noise
img_noised = imnoise(img_in_d,'gaussian',0,standard_deviation*standard_deviation);
figure(2);
imshow(img_noised);
title('Output Image');

% --- 3.2 - Kernel Density Estimation ---

% 1) Get P random samples of the image
img_noised_vector = img_noised(:);
random_samples = randsample(length(img_noised_vector),P);
img_noised_values = zeros(P,1);
for i=1:1:P
    img_noised_values(i) = img_noised_vector(random_samples(i))*255;
end;
figure(3);
plot(img_noised_values);
title('Used samples');
xlabel('Sample');
ylabel('Value');

% Histogramm plot (show density as histogram)
x_hist = 0:8:255;
n_hist = hist(img_noised_values,length(x_hist));
figure(4);
bar(x_hist,n_hist/length(img_noised_values)/8);
title('Histogramm, Window size = 8');
xlabel('Pixel Intensity');
ylabel('Frequency');

estimated_funtion = zeros(size(windowSizes,2),256);

% 2) Estimate Density
for windowsize = windowSizes

    h = windowsize;
    x_estimate = (1:256);
    y_estimate = zeros(1,256);
    
    for i = 1:1:P
        y_estimate = y_estimate + 1/sqrt(2*pi)/h*exp(-(x_estimate-img_noised_values(i)).^2/2/h^2);
    end

    figure(4+windowsize);
    plot(x_estimate,y_estimate/P);
    title(strcat('Estimated density - windowsize=',num2str(windowsize)));
    xlabel('Pixel Intensity');
    ylabel('Probabilty');
    
    %Save density function
    estimated_funtion(windowsize,:) = y_estimate(:);

end;

% --- 3.3 - Validation ---

% Get samples of pixels which were not used for the estimation
not_used_samples = setdiff((1:length(img_noised_vector))',random_samples);

% Calculate Likelihood values
not_used_samples_idx = 1+floor(img_noised_vector(not_used_samples)*255);

LogLikelihood = zeros(1,length(windowSizes));
for windowsize = windowSizes
    LogLikelihood(windowsize) = sum( -log(estimated_funtion(windowsize,not_used_samples_idx)));
end;

figure(4+length(windowSizes)+1);
plot(LogLikelihood);
title('Negative Log Likelihood');
xlabel('Window Size');
ylabel('Value');

[min,min_index] = min(LogLikelihood);
min_index;
