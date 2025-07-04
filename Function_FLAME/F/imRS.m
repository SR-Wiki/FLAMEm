function [name] = imRS(file)
num_images = numel(imfinfo([file, '.tif']));
for i = 1:num_images
    name(:,:,i) = double(imread([file, '.tif'],i));
end
name = name./max(max(max(name)));
end