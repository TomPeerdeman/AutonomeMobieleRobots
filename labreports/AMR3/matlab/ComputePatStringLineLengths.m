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