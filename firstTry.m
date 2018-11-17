%function signs = firstTry(I)

clear;
close all;

%%
validationSet = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 41 43 45 47 49 51 53 55 57 59 61 63 65 67];
%validationSet = [39 41 43 45 47 49 51 53 55 57 59 61 63 65 67];

validationSet = [1];
%
for N = 1:length(validationSet)
    % Current sign id
    nSign = validationSet(N)
    %nSign = 11;
    ImageName = sprintf('DTUSignPhotos/DTUSigns%03d.jpg', nSign);
    LMName    = sprintf('DTUSignPhotos/DTUSigns%03d.txt', nSign);

    %I = imread('DTUSigns065.jpg');
%     LM = dlmread('DTUSigns065.txt');

    I = imread(ImageName);
    LM = dlmread(LMName);

    LabelMap = CreateLabelMapFromAnnotations(I, LM);
    RGBLabels = label2rgb(LabelMap);


    %% Explore the RGB components

    %     Rcomp = I(:,:,1);
    %     Gcomp = I(:,:,2);
    %     Bcomp = I(:,:,3);
    HSV = rgb2hsv(I);
    Hcomp = HSV(:,:,1);
    Scomp = HSV(:,:,2);
    Vcomp = HSV(:,:,3);
    %imtool(I)

    %%
    %segm = Rcomp < 240 & Rcomp > 110 & Gcomp > 40 & Gcomp < 120 & Bcomp > 50 & Bcomp < 130;
    %segm = Rcomp > Gcomp - 130 & Rcomp < Gcomp & Rcomp > Bcomp - 130 & Rcomp < Bcomp & Bcomp > Gcomp - 20 & Bcomp < Gcomp + 80;
    %segm = Rcomp > 90 & Rcomp < 240 & Gcomp > max(25, Rcomp - 130) & Gcomp >  Bcomp - 20 & Gcomp < min(120, Rcomp) & Gcomp < Bcomp + 80 & Bcomp > max(Rcomp - 130, 25) & Bcomp < min(130, Rcomp);
    %segm = Rcomp > 90 & Rcomp < 240 & Gcomp > 25 & Gcomp < 120 & Bcomp > 25 & Bcomp < 130 & Gcomp < Rcomp & Rcomp < Gcomp + 130 & Bcomp < Gcomp + 15 & Gcomp < Bcomp + 10 & Rcomp < Bcomp + 120 & Bcomp < Rcomp; 
    segmRed = (Hcomp > 0.92 | (Hcomp < 0.1 & Scomp > 0.5)) & Scomp > 0.4 & Vcomp > 0.3 & Scomp < 0.85;
    segmWhite = (Hcomp < 0.1 | Hcomp > 0.8) & Scomp < 0.25 & Vcomp > 0.68;
    %     figure;
    %     
    %     subplot(2,2,1); imshow(I);  title(sprintf('Input image %03d', nSign))
    %     subplot(2,2,2);imagesc(RGBLabels); axis image; title('Ground truth signs')
    %     subplot(2,2,3); imshow(segmRed); title('red filter')
    %     subplot(2,2,4); imshow(segmWhite); title('white filter')

    %%

    %% Visualize the Red filter
    %imtool(segmRed)

    %% Revome single pixels with opening -- doesn't work well
    % se3 = strel('disk', 3);
    % se5 = strel('square', 5);
    % I2red = imdilate(imerode(segmRed, se5), se5);
    % I2white = imdilate(imerode(segmWhite, se3), se3);

    % figure;   
    % subplot(2,2,1); imshow(segmRed);  title('Red filter')
    % subplot(2,2,3); imshow(segmWhite);  title('White filter')
    % subplot(2,2,2);imshow(I2red); title('Red after opening')
    % subplot(2,2,4); imshow(I2white); title('White after opening')
    %% Remove single pixels with blob area
    selectedBlobsRed = clean_blobs(segmRed, 'red');
    selectedBlobsWhite = clean_blobs(segmWhite, 'white');

    %% separate blobs
    separated_blobs = sep_blobs(selectedBlobsRed);

    %% fill the blobs
    filled_blobs = fill_blobs(separated_blobs);
%     filled_blobs = fill_blobs(selectedBlobsRed);

    %% Remove the blobs at the borders of the image
    inner_blobs = imclearborder(filled_blobs);

    %% check if there is white in the inner part of the blob
    intersect_blobs = whiteInRed(inner_blobs, selectedBlobsWhite);

    %% Merge touching blobs
    merge_blobs = bwlabel(intersect_blobs > 0, 4);

    %% Filter blobs on extent value
    rect_blobs = blob_features_selection(merge_blobs);
    %%
    test = rgb2gray(RGBLabels);
    diff = (rect_blobs > 0 & test == 255) | (rect_blobs == 0 & test ~= 255);

    figure1=figure('Position', [100, 100, 1700, 1200]);
    subplot(2,2,1); imagesc(I);  title(sprintf('Input image %03d', nSign))
    subplot(2,2,2); imagesc(RGBLabels); axis image; title('Ground truth signs')
    subplot(2,2,4); imagesc(label2rgb(rect_blobs)); title('Output')
    subplot(2,2,3); imagesc(diff); title('difference')

end