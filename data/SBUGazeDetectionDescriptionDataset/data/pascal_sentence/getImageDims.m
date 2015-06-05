ims = dir('images/*.jpg');

for i = 1:length(ims);
    im = imread(['images/' ims(i).name]);
    dims(i,:) = size(im);
end