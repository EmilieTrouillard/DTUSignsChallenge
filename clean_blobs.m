function selectedBlobs = clean_blobs(binIm, color)
if color == "white"
    blobsWhite = bwlabel(binIm, 8);
    statsWhite = regionprops(blobsWhite, 'Area');
    idxWhite = find([statsWhite.Area] > 30);
    selectedBlobs = bwlabel(ismember(blobsWhite, idxWhite), 4);
elseif color == "red"
    blobsRed = bwlabel(binIm, 4);
    statsRed = regionprops(blobsRed, 'Area');
    idxRed = find([statsRed.Area] > 600);
    selectedBlobs = bwlabel(ismember(blobsRed, idxRed), 4);
else
    selectedBlobs = [];
end
end
