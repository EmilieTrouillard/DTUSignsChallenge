function new_blobs = sep_blobs(blobs)
% Number of blobs
N_blobs = max(max(blobs)) * 1;
maxBlobId = N_blobs;
se5 = strel('square', 5);
new_blobs = 0 * blobs;
for i=1:N_blobs
    % create an image with only the blob
    image = blobs == i;
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
        new_blobs = new_blobs + blob;
    end
end
end