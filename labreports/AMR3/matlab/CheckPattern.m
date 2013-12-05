function point = CheckPattern(TrainFile, TestFile)
% adapted from luciano's test function

load(TrainFile);

PatStringsTrain = PatStrings;

load(TestFile);

st = size(PatStringsTrain, 2);   
sz = size(PatStrings, 2);
confusion = zeros(sz, sz);

for i = 1:sz
	for j = 1:st
	    confusion(i,j) = LevenshteinDistance(PatStrings{i}, PatStringsTrain{j});
	end
end

% display results
PlaceID
confusion

% plot confusion matrix
colormap('gray')
imagesc(confusion);