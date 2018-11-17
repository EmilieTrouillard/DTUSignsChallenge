function rect_blobs = blob_features_selection(blobs)
stats = regionprops(blobs,'Area', 'Eccentricity', 'Extent', 'FilledArea', 'ConvexArea', 'Orientation', 'Solidity');
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
rect_blobs = bwlabel(ismember(blobs, idx), 4);
end