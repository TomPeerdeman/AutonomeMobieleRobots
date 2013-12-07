function [ bestpoint ] = FindBestFit(testloc, confusion)
bestpoint = -1;
bestval = 0;

for i=1:size(confusion, 2)
   if confusion(testloc, i) > bestval
      bestval = confusion(testloc, i);
      bestpoint = i;
   end
end

end

