%% tf rviz sucks
clc
clear
close all

%% load bag file

bag = rosbag("../../bag_file/mano_rb.bag");         %qualche mrks in più ma mai in meno
% bag = rosbag("../../bag_file/nocche_rb.bag");
% bag = rosbag("../../bag_file/test.bag");
% bag = rosbag("../../bag_file/due_mrkrs.bag");
% bag = rosbag("../../bag_file/2019-07-01-18-23-47.bag");
% bag = rosbag("../../bag_file/2019-07-01-18-21-37.bag");
% bag = rosbag("../../bag_file/2019-07-01-18-30-15.bag");


markers_coo=select(bag,'Topic','markers_coo');
rigidbody_pose=select(bag,'Topic','Robot_1/pose');
% rigidbody_g_pose=select(bag,'Topic','Robot_1/ground_pose');

msgs_mrks = readMessages(markers_coo,'DataFormat','struct');
msgs_rb = readMessages(rigidbody_pose,'DataFormat','struct');
% msgs_rb_gp = readMessages(rigidbody_g_pose,'DataFormat','struct');

%% fill the structs
% create the structs
V(1,1).field=0;
RB(1,1).field=0;

% fill the structs
for i=1:length(msgs_mrks)
    V(i,1).field=my_reshape(msgs_mrks{i,1}.Data);
end

for i=1:length(msgs_rb)
    RB(i,1).field=[msgs_rb{i,1}.Pose.Position.X,msgs_rb{i,1}.Pose.Position.Y,msgs_rb{i,1}.Pose.Position.Z];
end

%% clean fromm bad data
V=clean_noises(V,RB);


%% da qui probabilmente metto un for
num_msgs=min(length(V),length(RB));

for I=1:num_msgs
    
    %% set orientation and remove non IMUs
    %  ho fatto solo per il primo msg perché poi lo possiamo fare per tutti
    [oRm,ind]=set_orient(V(I,1).field,RB(I,1).field);
    [V,RB]=move_nonimu(V,RB,I,ind);
    
    
    %% set oTm and mTo
    
    oTm(:,:,I)=[   oRm,        RB(I,1).field';
        zeros(1,3),     1];
    mTo(:,:,I)=[   oRm^-1,       -RB(I,1).field';
        zeros(1,3),     1];
    
    %% homogeneous coordiantes
    
    V(I,1).field=[V(I,1).field,ones(size(V(I,1).field,1),1)];
    
end

%% set Vdes
% da oTm andiamo a fare l'inversa mTo
% ogni marker lo salviamo relativamente
% nell'ordine che preferiamo
% questo è Vdes

mVdes=set_Vdes(V,mTo(:,:,1));

%% findA
% come nelle versioni precedenti,forse
% sempre nel frame relativo relativo
A=findA(V(1,1).field,mVdes,mTo(:,:,1));


%% W

W = A * V(1,1).field;

%% graph
% plot the cleaned data

% figure(),hold on
% axis equal
% plot3(V(1,1).field(:,1),V(1,1).field(:,2),V(1,1).field(:,3),'or')
% plot3(RB(1,1).field(1,1),RB(1,1).field(1,2),RB(1,1).field(1,3),'ob'),
% grid on

my_plot(V(1,1).field);
my_plot(W);



%%

for i=1:num_msgs
    min_mrkrs(i)=(size(V(i,1).field,1));

end
min_mrkrs
% min(min_mrkrs)

