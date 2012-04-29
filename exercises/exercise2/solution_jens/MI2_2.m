clc;
clear all;
close all;

% --- Set Parameters ---
standard_deviation = 0.05;
%standard_deviation = 0.1;
%P = 100;
P = 500;
density_accuracy = 100; % Constant
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
for i=1:1:P
    img_noised_values(i) = img_noised_vector(random_samples(i))*255;
end;
figure(3);
plot(img_noised_values);
title('Used samples');
xlabel('Sample');
ylabel('Value');

% Histogramm plot (show density as histogram)
x_hist = 1:1:256;
n_hist = hist(img_noised_values,x_hist);
figure(4);
plot(x_hist,n_hist);
title('Histogramm');
xlabel('Pixel Intensity');
ylabel('Frequency');

% 2) Estimate Density
for windowsize = windowSizes

    h = density_accuracy*windowsize;
    x_estimate = 1:1:256*density_accuracy;
    y_estimate = zeros(1,256*density_accuracy);

    for bin = 1:1:P
        for x_e = 1:1:256*density_accuracy
            y_estimate(x_e) = y_estimate(x_e) + (1/(sqrt(2*pi)*h))*exp(-((x_e-img_noised_values(bin)*density_accuracy)^2)/((2*h^2)));
        end;
    end;

    figure(4+windowsize);
    plot(x_estimate/density_accuracy,y_estimate);
    title(strcat('Estimated density - windowsize=',num2str(windowsize)));
    xlabel('Pixel Intensity');
    ylabel('Probabilty');
    
    %Save density function
    estimated_funtion(windowsize,:) = y_estimate(:);

end;

% --- 3.3 - Validation ---

% Get samples of pixels which were not used for the estimation
not_used_samples = zeros(1,length(img_noised_vector)-P);
j=1;
for i=1:1:length(img_noised_vector)
    if (~(ismember(i,random_samples)))
        not_used_samples(j) = i;
        j = j + 1;
    end;
end;

% Calculate Likelihood values
LogLikelihood = zeros(1,length(windowSizes));
for windowsize = windowSizes
    for j = 1:1:length(not_used_samples)
        index = floor(img_noised_vector(not_used_samples(j))*256*density_accuracy);
        if index == 0
            index = 1;
        end;
        LogLikelihood(windowsize) = LogLikelihood(windowsize) - log(estimated_funtion(windowsize,index));
    end;
end;

figure(4+length(windowSizes)+1);
plot(LogLikelihood);
title('Negative Log Likelihood');
xlabel('Window Size');
ylabel('Value');

[min,min_index] = min(LogLikelihood);
min_index
