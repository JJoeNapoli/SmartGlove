%% load nocche to set the nocche distances
clc
clear
close all

%% load bag file
bag_name="../../bag_file/nocche_ref.bag";        
[V_struct,RB_struct]=load_and_fill(bag_name);

%% clean fromm bad data
[V,RB]=clean_noises(V_struct,RB_struct);

%% transformation matrix for first msg
num_msgs=min(size(V,3),size(RB,3));
I=1;

%% set orientation and remove non IMUs
[oRm,ind]=set_orient(V(:,:,I),RB(:,:,I));
[V_i,RB]=move_nonimu(V,RB,I,ind);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% set oTm and mTo
oTm(:,:,I)=[   oRm,        RB(1,:,I)';
    zeros(1,3),     1];
mTo(:,:,I)=[   oRm^-1,       (-oRm^-1)*RB(1,:,I)';
    zeros(1,3),     1];

%% set nocche (pollice,indice,...,polso)
nocche(1,:)=V(3,:,I);
nocche(2,:)=V(6,:,I);
nocche(3,:)=V(7,:,I);
nocche(4,:)=V(4,:,I);
nocche(5,:)=V(2,:,I);
nocche(6,:)=V(5,:,I);

%% homogeneous coordiantes
nocche=[nocche, ones(6,1)];

%% set mnocche
mnocche=my_transform(nocche,mTo(:,:,1));

%% graph
my_plot(mnocche);
my_plot(nocche);

%% save nocche
save("knucles","mnocche");
