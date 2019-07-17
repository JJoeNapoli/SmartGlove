function [oRm,ind]=set_orient(V,RB)

for i=1:size(V,1)
    dist(i) = norm(RB - V(i,:));
end

[~,ind(1)]=min(dist);
dist(ind(1))=100;


[~,ind(2)]=min(dist);
dist(ind(2))=100;


[~,ind(3)]=min(dist);
dist(ind(3))=100;


x=V(ind(1),:)-V(ind(2),:);
x=x/norm(x);
y=V(ind(1),:)-V(ind(3),:);
y=y/norm(y);
z=cross(x,y);
oRm=[x',y',z'];

end

