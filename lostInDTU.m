function final_blobs = lostInDTU(I)
    %% Explore the HSV components
    HSV = rgb2hsv(I);
    Hcomp = HSV(:,:,1);
    Scomp = HSV(:,:,2);
    Vcomp = HSV(:,:,3);

    %% Filter on the values of the HSV to get the red and white parts of the image
    segmRed = (Hcomp > 0.92 | (Hcomp < 0.1 & Scomp > 0.5)) & Scomp > 0.4 & Vcomp > 0.3 & Scomp < 0.85;
    segmWhite = (Hcomp < 0.1 | Hcomp > 0.8) & Scomp < 0.25 & Vcomp > 0.68;
    
    %% Remove single pixels with blob area
    blobsRed = bwlabel(segmRed, 4);
    statsRed = regionprops(blobsRed, 'Area');
    idxRed = find([statsRed.Area] > 600);
    selectedBlobsRed = bwlabel(ismember(blobsRed, idxRed), 4);
    
    blobsWhite = bwlabel(segmWhite, 8);
    statsWhite = regionprops(blobsWhite, 'Area');
    idxWhite = find([statsWhite.Area] > 30);
    selectedBlobsWhite = bwlabel(ismember(blobsWhite, idxWhite), 4);

    %% separate blobs
    N_blobs = max(max(selectedBlobsRed)) * 1;
    maxBlobId = N_blobs;
    se5 = strel('square', 5);
    separated_blobs = 0 .* selectedBlobsRed;
    for i=1:N_blobs
        % create an image with only the blob
        image = selectedBlobsRed == i;
        % separate the blob
        imSep = imdilate(imerode(image, se5), se5);
        split_blobs = bwlabel(imSep, 4);
        number_blobs = max(max(split_blobs));
        for b=1:number_blobs
            blob = split_blobs == b;
            if b == 1
                blob = blob * i;
            else
                maxBlobId = maxBlobId + 1;
                blob = blob * (maxBlobId);
            end
            separated_blobs = separated_blobs + blob;
        end
    end

    %% fill the blobs
    CH = imfill(separated_blobs, 'holes');
    filled_blobs = bwlabel(CH, 4);
    %% Remove the blobs at the borders of the image
    inner_blobs = imclearborder(filled_blobs);

    %% check if there is white in the inner part of the blob
    white = selectedBlobsWhite > 0;
    selected_blobs = inner_blobs(white);
    idx = unique(unique(selected_blobs));
    idx = idx(idx>0);
    intersect_blobs = bwlabel(ismember(inner_blobs, idx), 4);
    
    %% Merge touching blobs
    merge_blobs = bwlabel(intersect_blobs > 0, 4);

    %% Filter blobs on extent value
    stats = regionprops(merge_blobs,'Area', 'Eccentricity', 'Extent', 'FilledArea', 'ConvexArea', 'Orientation', 'Solidity');
    Area = [stats.Area];
    Eccentricity = [stats.Eccentricity];
    Extent = [stats.Extent];
    FilledArea = [stats.FilledArea];
    ConvexArea = [stats.ConvexArea];
    Orientation = [stats.Orientation];
    Solidity = [stats.Solidity];
    BoundingBoxConvex = Area .* Extent ./ ConvexArea;
    RelativeFilledArea = FilledArea./ Area;
    RelativeConvexArea = ConvexArea ./ Area;
    idx = find(Eccentricity >= 0.7 & Extent >= 0.45 & (Orientation < 20 | Orientation > 80) & Solidity > 0.9 & BoundingBoxConvex > 0.45 & RelativeFilledArea >= 1 & RelativeFilledArea <= 1.1 & RelativeConvexArea >= 1 & RelativeConvexArea <= 1.15);
    rect_blobs = bwlabel(ismember(merge_blobs, idx), 4);
    
    %% Compute the convex hull of each sign
    final_blobs = bwlabel(bwconvhull(rect_blobs, 'objects'), 4);
end