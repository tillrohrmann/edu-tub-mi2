clc;
clear all;
close all;

% --- 3.2 PCA: Image Data ---

% --- Variables
img_type = 'n'; % nature
%img_type = 'b'; % buildings
pc_patches = 48;


% a) Sample patches
% Read images
for i=1:1:10
    
    temp = im2double(imread(strcat(img_type,num2str(i),'.jpg')));
    if (img_type == 'n' && (i==4 || i==9)) || (img_type == 'b' && (i==2 || i==3 || i==6 || i==7 || i==10))
        temp = transpose(temp);
    end;
    img(i,:,:) = zeros(500,600);
    size_temp = size(temp);
    for r=1:1:size_temp(1)
        for c=1:1:size_temp(2)
            img(i,r,c) = temp(r,c);
        end;
    end;

end;
% Sample images
patch_matrix = zeros(5000,64);
temp_patch = zeros(8,8);
for img_nr = 1:1:10
    for p_nr = 1:1:500
    
        c = mod(p_nr,62) + 1;
        r = floor(p_nr/62) + 1;
    
        temp_patch(:,:) = img(img_nr,((r*8)-7):(r*8),((c*8)-7):(c*8));
        patch_matrix( (img_nr-1)*500 + p_nr , : ) = temp_patch(:);
    
    end;
end;

% b) Calculate PCs + draw them as image patches
% Calculate PCs
C = cov(patch_matrix);
[V,D] = eig(C);

PC_img = ones(pc_patches,64);
% Show first 24 PCs as images
for pc_nr = 1:1:pc_patches
    
    c = mod(pc_nr-1,8) + 1;
    r = floor((pc_nr-1)/8) + 1;
    
    temp_PC = transpose(V(:,pc_nr));
    temp_PC_patch(:,:) = reshape(temp_PC,8,8);
    
    PC_img( ((r*8)-7):(r*8) , ((c*8)-7):(c*8) ) = temp_PC_patch(:,:);
    
end;
PC_img_resized = imresize(PC_img, 16);
imshow(PC_img_resized);
title(strcat(num2str(pc_patches),' PCs as patches (',num2str(pc_patches/8),'*8)'));
