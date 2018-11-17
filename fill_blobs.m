function new_blobs = fill_blobs(blobs)
% Number of blobs
% N_blobs = max(max(blobs));
% se = strel('square', 21);
% new_blobs = 0 * blobs;
% %CH = bwconvhull(blobs,'objects');
% for i=1:N_blobs
%     % create an image with only the blob
%     image = blobs == i;
%     % separate the blob
%     pad = 21;
%     imSep = imerode(imdilate(padarray(image,[pad, pad],0,'both'), se), se);
%     imSep = imSep(pad+1:end-pad, pad+1:end-pad);
%     filled_blob = bwlabel(imSep, 4);
%     new_blobs = new_blobs + i * filled_blob;
% end
CH = imfill(blobs, 'holes');
new_blobs = bwlabel(CH, 4);
end