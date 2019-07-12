% V=[1,2,3
%     4,5,6
%     7,8,9
%     10,11,12]
% A=[ 0,0,1,0
%     1,0,0,0
%     0,1,0,0
%     0,0,0,1]
% 
% W=A*V
% B=A'
% C=A'*W

for i=1:size(V(1,1).field,1)
dist(i) = norm(RB(1,1).field - V(1,1).field(i,:));
end

[a,ind]=min(dist)