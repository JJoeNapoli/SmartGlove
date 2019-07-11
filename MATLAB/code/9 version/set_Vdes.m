%% salva posix relative markers
clc
clear
close all

%% load bag file
bag_name="../../bag_file/reference_calibration.bag";
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
Vdes=zeros(12,3);
Vdes(1,:)=V(1).field(1,:);
Vdes(2,:)=V(1).field(10,:);
Vdes(3,:)=V(1).field(11,:);
Vdes(4,:)=V(1).field(9,:);
Vdes(5,:)=V(1).field(5,:);
Vdes(6,:)=V(1).field(8,:);
Vdes(7,:)=V(1).field(7,:);
Vdes(8,:)=V(1).field(4,:);
Vdes(9,:)=V(1).field(6,:);
Vdes(10,:)=V(1).field(3,:);
Vdes(11,:)=V(1).field(2,:);
Vdes(12,:)=V(1).field(12,:);

%% homogeneous coordiantes
Vdes=[Vdes, ones(12,1)];

%% set mnocche
mVdes=my_transform(Vdes,mTo(:,:,1));

%% graph
my_plot(mVdes);

%% save desired_config
save("desired_config","mVdes");

