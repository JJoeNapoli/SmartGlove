function [V,RB]=move_nonimu(V,RB,ind)

num_msgs=min(length(V),length(RB));

ind=sort(ind,'descend');
for i=1:num_msgs
    for j=1:length(ind)
        RB(i,2).field(j,:) = V(i,1).field(ind(j),:);
        V(i,1).field(ind(j),:)=[];
    end
end
end

