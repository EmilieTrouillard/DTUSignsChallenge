clear;
close all;

%%
validationSet = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 41 43 45 47 49 51 53 55 57 59 61 63 65 67];
%validationSet = [39 41 43 45 47 49 51 53 55 57 59 61 63 65 67];

validationSet = [1 3 5 7];
%
for N = 1:length(validationSet)
    % Current sign id
    nSign = validationSet(N)
    %nSign = 11;
    ImageName = sprintf('DTUSignPhotos/DTUSigns%03d.jpg', nSign);
    %LMName    = sprintf('DTUSignPhotos/DTUSigns%03d.txt', nSign);

    %I = imread('DTUSigns065.jpg');
    %LM = dlmread('DTUSigns065.txt');

    I = imread(ImageName);
    %LM = dlmread(LMName);

    %LabelMap = CreateLabelMapFromAnnotations(I, LM);
    %RGBLabels = label2rgb(LabelMap);
