function confusion = CheckPattern(TrainFile, TestFile)
load(TrainFile);

PatStringsTrain = PatStrings;

load(TestFile);

st = size(PatStringsTrain, 2);   
sz = size(PatStrings, 2);
confusion = zeros(st, sz);

for i = 1:st
	for j = 1:sz
        lt = length(PatStringsTrain{i});
	    confusion(j,i) = ((lt - LevenshteinDistance(PatStringsTrain{i}, PatStrings{j})) / lt) * 100;
	end
end

% plot confusion matrix
colormap('gray')
imagesc(confusion);