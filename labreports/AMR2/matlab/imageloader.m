% Get list of all BMP files in this directory
% DIR returns as a structure array.  You will need to use () and . to get
% the file names.
% Original source: http://www.mathworks.com/matlabcentral/answers/385
function [images] = imageloader(folder)
imagefiles = dir(strcat(folder, '/*.jpg'));
nfiles = length(imagefiles);    % Number of files found

for ii=1:nfiles
   currentfilename = imagefiles(ii).name;
   currentimage = imread(currentfilename);
   images{ii} = currentimage;
end