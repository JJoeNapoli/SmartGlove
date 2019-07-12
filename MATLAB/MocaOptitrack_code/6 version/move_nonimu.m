function [V_i,RB]=move_nonimu(V,RB,i,ind)

% num_msgs=min(length(V),length(RB));
V_i(:,:)=V(:,:,i);
ind=sort(ind,'descend');
for j=1:length(ind)
    RB(1+j,:,i) = V_i(ind(j),:);
    V_i(ind(j),:) = [];
end
% add the CM as a sensor
V_i(:,:) = [RB(1,:,i); V_i(:,:)];
end

