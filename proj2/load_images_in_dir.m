function [fnames, images] = load_images_in_dir(dirname)

fnames = dir(strcat(dirname,'/*.jpg'));
fnames = {fnames.name};
images = {};
disp('Loading images...');
N = length(fnames);
for j=1:N,
	disp(fnames{j});
	images{j} = mean(imread(strcat(dirname, '/', fnames{j})), 3);
end%for
