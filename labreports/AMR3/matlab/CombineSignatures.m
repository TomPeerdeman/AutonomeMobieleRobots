load 'LabeledLineSignatures.mat';
PatStringsLine = PatStrings;

load 'LabeledBlobSignatures.mat';
PatStringsBlob = PatStrings;

load 'UnlabeledLineSignatures.mat';
PatStringsUnLine = PatStrings;

load 'UnlabaledBlobSignatures.mat';
PatStringsUnBlob = PatStrings;

npatterns = size(PatStringsLine, 2);

PatStrings = [];
PatStringsUn = [];

for i=1:npatterns
    PatStrings{i} = [PatStringsLine{i} PatStringsBlob{i}];
    PatStringsUn{i} = [PatStringsUnLine{i} PatStringsUnBlob{i}];
end

save 'LabeledSignatures.mat' PatStrings PlaceID;

PatStrings = PatStringsUn;
save 'UnlabeledSignatures.mat' PatStrings;
