function [V,RB]=move_nonimu(V,RB,i,ind)

% num_msgs=min(length(V),length(RB));

ind=sort(ind,'descend');
for j=1:length(ind)
    RB(i,2).field(j,:) = V(i,1).field(ind(j),:);
    V(i,1).field(ind(j),:)=[];
end
% add the CM as a sensor
V(i,1).field=[RB(i,1).field; V(i,1).field];
end

