% Machine Intelligence 2
% Exercise Sheet 3
% Task 3.2
%
% Jens Krenzin
% Till Rohrmann

close all;
clear all;
clc;

numberPatches = 20000;
patchSize = 8;
pcToShow = 24;
nature = 'pca_datafiles/imgpca/n*';
buildings = 'pca_datafiles/imgpca/b*';

[covarianceNature] = pca(nature,numberPatches,patchSize);

showPC('Nature files',covarianceNature,patchSize,pcToShow);

[covarianceBuildings] = pca(buildings,numberPatches,patchSize);

showPC('Building files', covarianceBuildings,patchSize,pcToShow);
