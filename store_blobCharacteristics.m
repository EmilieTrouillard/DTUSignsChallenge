clear;
close all;

%%
validationSet = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 41 43 45 47 49 51 53 55 57 59 61 63 65 67];
Eccentricity = [];
Extent = [];
FilledArea = [];
ConvexArea = [];
Orientation = [];
Solidity = [];
Area = [];
BoundingBoxConvex = [];

for N = 1:length(validationSet)
    % Current sign id
    nSign = validationSet(N);
    %nSign = 35;
    ImageName = sprintf('DTUSignPhotos/DTUSigns%03d.jpg', nSign);
    LMName    = sprintf('DTUSignPhotos/DTUSigns%03d.txt', nSign);

    %I = imread('DTUSigns065.jpg');
    %LM = dlmread('DTUSigns065.txt');

    I = imread(ImageName);
    LM = dlmread(LMName);

    LabelMap = CreateLabelMapFromAnnotations(I, LM);
    %RGBLabels = label2rgb(LabelMap);
    
    stats = regionprops(LabelMap,'Area', 'Eccentricity', 'Extent', 'FilledArea', 'ConvexArea', 'Orientation', 'Solidity');
    Area = [Area, stats.Area];
    Eccentricity = [Eccentricity, stats.Eccentricity];
    Extent = [Extent, stats.Extent];
    FilledArea = [FilledArea, stats.FilledArea];
    ConvexArea = [ConvexArea, stats.ConvexArea];
    Orientation = [Orientation, stats.Orientation];
    Solidity = [Solidity, stats.Solidity];
    
end
%%
BoundingBoxConvex = Area .* Extent ./ ConvexArea;
RelativeFilledArea = FilledArea./ Area;
RelativeConvexArea = ConvexArea ./ Area;
%%
figure;
histogram(Area,100); title('Area')
figure;
histogram(Eccentricity,10); title('Eccentricity')
figure;
histogram(Extent,10); title('Extent')
figure;
histogram(FilledArea,10); title('FilledArea')
figure;
histogram(ConvexArea,10); title('ConvexArea')
figure;
histogram(Orientation,10); title('Orientation')
figure;
histogram(Solidity,10); title('Solidity')
figure;
histogram(BoundingBoxConvex,10); title('BoundingBoxConvex')
figure;
histogram(RelativeFilledArea,10); title('RelativeFilledArea')
figure;
histogram(RelativeConvexArea,10); title('RelativeConvexArea')


