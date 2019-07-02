%% load nocche to set the nocche distances

clc
clear
close all

%% load bag file

bag_name="../../bag_file/nocche_rb.bag";        %qualche mrks in più ma mai in meno

[V,RB]=load_and_fill(bag_name);



%% clean fromm bad data
V=clean_noises(V,RB);

%% transformation matrix for first msg

num_msgs=min(length(V),length(RB));

I=1;
%% set orientation and remove non IMUs

[oRm,ind]=set_orient(V(I,1).field,RB(I,1).field);
[V,RB]=move_nonimu(V,RB,I,ind);


%% set oTm and mTo

oTm(:,:,I)=[   oRm,        RB(I,1).field';
    zeros(1,3),     1];
mTo(:,:,I)=[   oRm^-1,       -RB(I,1).field';
    zeros(1,3),     1];

%%
v=V(1,1).field(3,:)-V(1,1).field(4,:);
V(1,1).field(5,:)=V(1,1).field(3,:)+v;
V(1,1).field(6,:)=V(1,1).field(5,:)+v;

nocche(1,:)=V(1,1).field(6,:);
nocche(2,:)=V(1,1).field(5,:);
nocche(3,:)=V(1,1).field(3,:);
nocche(4,:)=V(1,1).field(4,:);

nocche=[nocche, ones(4,1)];
%% homogeneous coordiantes

V(I,1).field=[V(I,1).field,ones(size(V(I,1).field,1),1)];

%% mV
mV=my_transform(V(1,1).field,mTo(:,:,1));

%% set nocche

v=mV(3,:)-mV(4,:);
mV(5,:)=mV(3,:)+v;
mV(6,:)=mV(5,:)+v;

mnocche(1,:)=mV(6,:);
mnocche(2,:)=mV(5,:);
mnocche(3,:)=mV(3,:);
mnocche(4,:)=mV(4,:);

%% graph
my_plot(mV);
my_plot(mnocche);


%% save nocche

save("knucles","mnocche","nocche");
