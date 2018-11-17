function new_blobs = whiteInRed(blobs, whiteIm)
% Number of blobs
white = whiteIm > 0;
selected_blobs = blobs(white);
idx = unique(unique(selected_blobs));
idx = idx(idx>0);
new_blobs = bwlabel(ismember(blobs, idx), 4);
% N_blobs = max(max(blobs));
% maxBlobId = N_blobs;
% new_blobs = 0 * blobs;
% for i=1:N_blobs
%     % create an image with only the blob
%     image = blobs == i;
%     intersection = image > 0 & whiteIm > 0;
%     m = max(max(intersection));
%     if m > 0
%        new_blobs = new_blobs + i * image;
%     end
% end
end