function angs = my_angles(W,nocche)

% P0 = [x0, y0];
% P1 = [x1, y1];
% P2 = [x2, y2];
% n1 = (P2 - P0) / norm(P2 - P0);  % Normalized vectors
% n2 = (P1 - P0) / norm(P1 - P0);
% % angle1 = acos(dot(n1, n2));                        % Instable at (anti-)parallel n1 and n2
% % angle2 = asin(norm(cropss(n1, n2));                % Instable at perpendiculare n1 and n2
% angle3 = atan2(norm(cross(n1, n2)), dot(n1, n2));  % Stable
%
% atan2d(norm(cross(u,v)),dot(u,v));


temp=nocche;
clear nocche;
nocche=temp(:,1:3);
count=0;

for j=1:5
    count=count+1;
    u1=W(1,1:3)-nocche(j,:);
    v1=W(j*2,1:3)-nocche(j,:);
    angs(count,1)=atan2d(norm(cross(u1,v1)),dot(u1,v1));
    
    
    count=count+1;
    nocche(6+j,:) = W(j*2,1:3) + 0.25*v1;
    u2=W(j*2,1:3)-nocche(6+j,:);
    v2=W(j*2+1,1:3)-nocche(6+j,:);
    angs(count,1)=atan2d(norm(cross(u2,v2)),dot(u2,v2));
    
    
end


end