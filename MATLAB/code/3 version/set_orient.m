function [x,y,z,ind]=set_orient(V,RB)

for i=1:size(V(1,1).field,1)
dist(i) = norm(RB(1,1).field - V(1,1).field(i,:));
end

[~,ind(1)]=min(dist);
dist(ind(1))=100;


[~,ind(2)]=min(dist);
dist(ind(2))=100;


[~,ind(3)]=min(dist);
dist(ind(3))=100;


x=V(1,1).field(ind(1),:)-V(1,1).field(ind(2),:);
x=x/norm(x);
y=V(1,1).field(ind(1),:)-V(1,1).field(ind(3),:);
y=y/norm(y);
z=cross(x,y);


end

