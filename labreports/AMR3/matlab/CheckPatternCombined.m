function confusion = CheckPatternCombined(wline, wblob)
load 'LabeledLineSignatures.mat';
PatStringsLine = PatStrings;

load 'LabeledBlobSignatures.mat';
PatStringsBlob = PatStrings;

load 'UnlabeledLineSignatures.mat';
PatStringsUnLine = PatStrings;

load 'UnlabaledBlobSignatures.mat';
PatStringsUnBlob = PatStrings;

st = size(PatStringsLine, 2);   
sz = size(PatStringsUnLine, 2);
confusion = zeros(st, sz);

for i = 1:st
	for j = 1:sz
        ltl = length(PatStringsLine{i});
        ltb = length(PatStringsBlob{i});
	    q1 = ((ltl - LevenshteinDistance(PatStringsLine{i}, PatStringsUnLine{j})) / ltl) * 100;
        q2 = ((ltb - LevenshteinDistance(PatStringsBlob{i}, PatStringsUnBlob{j})) / ltb) * 100;
        confusion(j,i) = wline * q1 + wblob * q2;
	end
end

% plot confusion matrix
colormap('gray')
imagesc(confusion);