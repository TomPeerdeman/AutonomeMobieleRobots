function GetLinePattern()

NumStrings = 0;
PatStrings = {};
PlaceID = [];

training = input('Is it labeled or unlabeled data [l/u]:', 's');

global Rmin;
global Rmax;
global center;
global radius;

center = [545; 402];
radius = 90.4013;

Rmin = 115;
Rmax = 190;

for i=0:7
  
  % Get user input for looping
  %Option = input('Get a new scan [1/0] : ');
  %if Option == 0, break; end
  NumStrings = NumStrings + 1;
  if training == 'l'
    PlaceID(NumStrings) = NumStrings;
  end;
  
  % Get a new scan
  XY = GetNextScan(NumStrings, training);
  XY = XY';
  
  % Plot raw scan
  figure(1), clf, axis([-0.5 0.5 -0.5 0.5]), grid on; hold on;
  plot(XY(1,:), XY(2,:), 'r.');

  % Extract line segments
  [NLines, r, alpha, segend, seglen] = recsplit(XY);
  disp(sprintf('Number of extracted lines: %d\n', NLines));

  % Plot extracted segments
  figure(2), clf, axis([-0.5 0.5 -0.5 0.5]), grid on; hold on;
  
  
  color = 0;
  for i=1:NLines
    if color == 0, c = 'r'; elseif color == 1, c = 'b'; else c = 'g'; end
    line([segend(i,1) segend(i,3)], [segend(i,2) segend(i,4)], ...
	 'color', c, 'linewidth', 3);
    color = mod(color+1, 3);
  end
  
  
  % Compute the string
  S = ComputePatStringLines(NLines, segend, seglen);
  disp(sprintf('Pattern string:  %s', num2str(S)));
  
  
  % Store the pattern string and place ID
  PatStrings{NumStrings} = S;
end


% Save pattern strings and place id to output file
if training == 'l'
    save 'LabeledLineSignatures.mat' PatStrings PlaceID;
else 
    save 'UnlabeledLineSignatures.mat' PatStrings;
end
%close all
return

