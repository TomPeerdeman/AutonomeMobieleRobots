% this function computes the pattern string based on the extracted segments
% and openings. The input segments are in a sequence. 
function  S = ComputePatStringLineLengths(NLines, ~, seglen, multiplier)
S = [];

j = 1;
for q=1:10
    bins(j:(j + 25)) = q;
    j = j + 25;
end


for i=1:NLines
    S = [S, bins(round(seglen(i)*multiplier))];
end

S

return


% This function computes the angle between 2 input points and the origin.
% Output: -pi < a <= pi
% The output condition always holds for a segment. However, for an opening > 180 degree,
% the angle is subtracted by 180 !!
function a = ComputeAngle(XY1, XY2)
  
  a = atan2(XY1(2), XY1(1)) - atan2(XY2(2), XY2(1));
  
  if a > pi, a = a - pi*2; end
  if a <= -pi, a = a + pi*2; end
  
return  

