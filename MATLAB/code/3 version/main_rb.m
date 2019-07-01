%% tf rviz sucks
clc
clear
close all

%% load bag file

bag = rosbag("../../bag_file/mano_rb.bag");
% bag = rosbag("../../bag_file/nocche_rb.bag");
% bag = rosbag("../../bag_file/test.bag");
% bag = rosbag("../../bag_file/due_mrkrs.bag");

% rosbag info '2019-06-20-20-05-52.bag';

markers_coo=select(bag,'Topic','markers_coo');
rigidbody_pose=select(bag,'Topic','Robot_1/pose');
% rigidbody_g_pose=select(bag,'Topic','Robot_1/ground_pose');

msgs_mrks = readMessages(markers_coo,'DataFormat','struct');
msgs_rb = readMessages(rigidbody_pose,'DataFormat','struct');
% msgs_rb_gp = readMessages(rigidbody_g_pose,'DataFormat','struct');

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

% plot the original data
figure(),hold on,plot3(V(1,1).field(:,1),V(1,1).field(:,2),V(1,1).field(:,3),'-or')
plot3(RB(1,1).field(1,1),RB(1,1).field(1,2),RB(1,1).field(1,3),'-ob'),
grid on

% clean fromm bad data
V=clean_noises(V,RB);

% plot the cleaned data
figure(),hold on
axis equal
plot3(V(1,1).field(:,1),V(1,1).field(:,2),V(1,1).field(:,3),'or')
plot3(RB(1,1).field(1,1),RB(1,1).field(1,2),RB(1,1).field(1,3),'ob'),
grid on



% 
% % number of msgs
% num_el=size(msgs_mrks{1,1}.Data,1);
% num_mrks=num_el/3;
% num_msgs=length(msgs_mrks);
% 

% my_init("../../bac_file/nocche_rb.bag");








% for i=1:num_msgs
%     min_mrkrs(i)=(size(msgs_mrkrs{i,1}.Data,1))/3;
%     
% end
% 
% min(min_mrkrs)







