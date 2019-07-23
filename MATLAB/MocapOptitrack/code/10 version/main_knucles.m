%% load nocche to set the nocche distances
clc
clear
close all

%% load bag file
bag_name="../../bag_file/knucles.bag";        
[V_struct,RB_struct]=load_and_fill(bag_name);

%% clean fromm bad data
[V,RB]=clean_noises(V_struct,RB_struct);

%% transformation matrix for first msg
num_msgs=min(length(V),length(RB));
I=1;

%% set orientation and remove non IMUs
[oRm,ind]=set_orient(V(I,1).field,RB(I,1).field);
[V,RB]=move_nonimu(V,RB,I,ind);
% my_plot(V(1,1).field);
%% set oTm and mTo
oTm(:,:,I)=[   oRm,        RB(I,1).field';
    zeros(1,3),     1];
mTo(:,:,I)=[   oRm^-1,       (-oRm^-1)*RB(I,1).field';
    zeros(1,3),     1];

%% set nocche (pollice,indice,...,polso)
% nocche(1,:)=V(1,1).field(6,:);
% nocche(2,:)=V(1,1).field(2,:);
% nocche(3,:)=V(1,1).field(3,:);
% nocche(4,:)=V(1,1).field(7,:);
% nocche(5,:)=V(1,1).field(4,:);
% nocche(6,:)=V(1,1).field(5,:);

nocche(1,:)=V(1,1).field(5,:);
nocche(2,:)=V(1,1).field(4,:);
nocche(3,:)=V(1,1).field(7,:);
nocche(4,:)=V(1,1).field(3,:);
nocche(5,:)=V(1,1).field(2,:);
nocche(6,:)=V(1,1).field(6,:);


%% homogeneous coordiantes
nocche=[nocche, ones(6,1)];

%% set mnocche
mnocche=my_transform(nocche,mTo(:,:,1));

%% graph
my_plot(mnocche);
% my_plot(nocche);

%% save nocche
save("knucles","mnocche");




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
% temp=x;
% x=-y;
% y=-temp;
z=cross(x,y);
oRm=[x',y',z'];
end

