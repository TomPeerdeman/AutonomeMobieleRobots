
global center Rmax Rmin
path(path, './scans/');
configfile_blobs;

training = input('Is it labeled or unlabeled data [l/u]:', 's');

% Loop - while the user wants, get image, compute pattern, store pattern
NumStrings = 0;
for i=0:7
	% Get user input for looping
	%Option = input('Get a new image [1/0] : ');
	%if Option == 0, break; end
	NumStrings = NumStrings + 1;
	%PlaceNum = input('Which place [1/2/3] : ');
    PlaceNum = NumStrings;

	%img = getsnapshot(vid);
    if training == 'l'
        s = ['imgs/Trainset AMR/', int2str(NumStrings), '.jpg'];
    else
        s = ['imgs/Testset AMR/', int2str(NumStrings), '.jpg'];
    end
    imgtmp = imread(s);
    img = imflipud(imgtmp);
 	figure(12), clf; imshow(img);

	%% img center [row, col]
	img_center = center';
	radius = Rmax;
	radius_inner = Rmin;

	%% color segment
	[cl_angles, cl_center, cl_type] = color_segment(color_s, img, sat, lum, max_pxarea, min_pxarea, img_center, radius, radius_inner , stdthreshold);
	[ cl_center , cl_type ]

	%% just to see
	rad2deg(cl_angles)
	hold on
% 	plot([img_center(1, 2), img_center(1,2) + 100],[img_center(1,1), img_center(1,1)], 'y-');
% 	plot([img_center(1, 2), img_center(1,2)],[img_center(1,1), img_center(1,1) + 100], 'y-');
	plot([img_center(1, 1), img_center(1,1) + 100],[img_center(1,2), img_center(1,2)], 'y-');
	plot([img_center(1, 1), img_center(1,1)],[img_center(1,2), img_center(1,2) + 100], 'y-');
 
	if(isempty(cl_center) ~= 1)
		plot(cl_center(:, 2),  cl_center(:, 1), 'mx', 'MarkerSize', 5);
% 		plot(img_center(:, 2),  img_center(:, 1), 'mx', 'MarkerSize', 5);
% 		plot(cl_center(:, 1),  cl_center(:, 2), 'mx', 'MarkerSize', 5);
% 		plot(img_center(:, 1),  img_center(:, 2), 'mx', 'MarkerSize', 5);
	end

	%% compute pattern string
	%% warning: angle=0 is center -> left
	S = ComputePatStringBlobs( cl_angles , cl_type);
	disp(sprintf('BLOB Pattern string:  %s', num2str(S)));

	PatStrings{NumStrings} = S;
	PlaceID(NumStrings) = PlaceNum;
end

if training == 'l'
    save 'LabeledBlobSignatures.mat' PatStrings PlaceID;
else
    save 'UnlabaledBlobSignatures.mat' PatStrings;
end
%close all