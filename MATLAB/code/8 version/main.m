main_nocche
set_Vdes

%% tf rviz sucks
clc
clear
close all


%% load knucles
load("knucles.mat")
load("desired_config.mat")

%% load bag file
bag_name="../../bag_file/2019-07-09-17-43-50.bag";      

[V_struct,RB_struct]=load_and_fill(bag_name);

% bag = rosbag("../../bag_file/nocche_rb.bag");
% bag = rosbag("../../bag_file/test.bag");
% bag = rosbag("../../bag_file/due_mrkrs.bag");
% bag = rosbag("../../bag_file/2019-07-01-18-23-47.bag");
% bag = rosbag("../../bag_file/2019-07-01-18-21-37.bag");
% bag = rosbag("../../bag_file/2019-07-01-18-30-15.bag");

%% clean from bad data
[V,RB]=clean_noises(V_struct,RB_struct);
clear V_struct RB_struct;

%% transformation matrix for each msg
num_msgs=min(length(V),length(RB));

for I=1:num_msgs
    %% set orientation and remove non IMUs
    [oRm,ind]=set_orient(V(I,1).field,RB(I,1).field);
    [V,RB]=move_nonimu(V,RB,I,ind);
    
    %% set oTm and mTo
    oTm(:,:,I)=[   oRm,        RB(I,1).field';
        zeros(1,3),     1];
    mTo(:,:,I)=[   oRm^-1,       (-oRm^-1)*RB(I,1).field';
        zeros(1,3),     1];
    %     oTm(:,:,I)*mTo(:,:,I) %=eye(4)
    
    %% homogeneous coordiantes   
    V(I,1).field=[V(I,1).field,ones(size(V(I,1).field,1),1)];
    
end

%% findA
A=findA(V(1,1).field,mVdes,mTo(:,:,1));
W(:,:,1) = A * V(1,1).field;
figure(1),

%% sort data
clc
num_mrkrs=size(V(1,1).field,1);
for I = 2 : num_msgs
    
    %% don't worry be happy
    [W(:,:,I),A]= my_sort(V(I,1).field,W(:,:,I-1),A,mTo(:,:,I),mTo(:,:,I-1),oTm(:,:,I));
    I
    
    %% mangia un pochino, figgeu
    nocche=my_transform(mnocche,oTm(:,:,I));
    
    my_skeleton(W(:,:,I),nocche)
    pause(0.01)
    clf
end
%% compute the following knucles
close all
I=132;
nocche=my_transform(mnocche,oTm(:,:,I));
my_skeleton(W(:,:,I),nocche)
%         pause(0.01);



