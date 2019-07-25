function [rollMatrix] = JointRoll(allMsgs) 

    for i=1:size(allMsgs,1)
        
         rollMatrix(i,1)=allMsgs{i, 1}.KalAngleX;
         rollMatrix(i,2)=allMsgs{i, 1}.Id;

    end

end