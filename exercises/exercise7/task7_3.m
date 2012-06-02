% Machine Intelligence 2
% Exercise Sheet 7
% Task 7.3
%
% Jens Krenzin
% Till Rohrmann

close all;
clear all;
clc;

natureFiles ='datafilesICA/images/n*';
buildingFiles = 'datafilesICA/images/b*';
textFiles = 'datafilesICA/images/t*';
numberPatches = 40000;
patchSize = 16;
independentFeatures2Show = 20;

independentFeatures(natureFiles,numberPatches,patchSize,independentFeatures2Show,'Nature');
independentFeatures(buildingFiles,numberPatches,patchSize,independentFeatures2Show,'Buildings');
independentFeatures(textFiles,numberPatches,patchSize,independentFeatures2Show,'Text');

