%Start acquiring some frames and get a snapshot
stop(vid);
% Configure the object for manual trigger mode.
triggerconfig(vid, 'manual');

disp('starting acquisition. Please wait...');
start(vid); % start video
N = 10;
for i=1:80
    tmpsnapshot = getsnapshot(vid);
end

% Flip the image Up-Down
snapshot = imflipud( tmpsnapshot );

% Max detectable distance (set to 160 pixel by default in VGA image).
% Rmax is automatically scaled according to the image size
Rmax = round( 150/480*size(snapshot,1) )
% Min detectable distance (set to 77 pixel by default in VGA image).
% Rmax is automatically scaled according to the image size
Rmin = round( 77/480*size(snapshot,1) )

% This functrion allows you to calibrate the camera (extract the center of
% the image). Follow the directions on-line
%figure(1); [center, radius] = get_circle(snapshot);

% Fixed best values found
center = [444.2568; 333.2305];
radius = 90.4013;

Rmin = 125;
Rmax = 215;

imagesc(snapshot);

% Draw the max and min radius
draw2DCircle(center,Rmin,'m');
draw2DCircle(center,Rmax,'m');


% This function convert the omnidirectional picture into a rectangular
% image. Use this tool to see if the calibration was accurately done (for
% example the smaller circle of the camera objective should transform into
% a horizontal line. Check this. Is the line is not perfectly horizontal,
% you may have to repeat the calibration. The calibration is very important
% to have an accurate detection of the distance.
ud = unwrap_allimage(snapshot, center, Rmax, 1, 0); figure(2); imagesc(ud);
% Draw radius
hold on; line ( [0, size(ud,2) ], [ round(radius), round(radius) ] , 'Color', 'r', 'LineWidth', 2);
% Draw Rmin
hold on; line ( [0, size(ud,2) ], [ round(Rmin), round(Rmin) ] , 'Color', 'm', 'LineWidth', 2);
hold off;

stop(vid);