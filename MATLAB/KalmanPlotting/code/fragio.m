clc
clear
close all
format long
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

bag_name="../bag_file/reference_calibration.bag";
bag = rosbag(bag_name);         
markers_coo=select(bag,'Topic','markers_coo');
rigidbody_pose=select(bag,'Topic','Robot_1/pose');

time_mrkrs(i) = table2array(markers_coo.MessageList(i,1));
time2 = table2array(markers_coo.MessageList(2,1));
time3 = table2array(rigidbody_pose.MessageList(1,1));
time4 = table2array(rigidbody_pose.MessageList(2,1));

diff2=(time2-time_)*100
diff3=(time3-time_)*100
diff4=(time4-time_)*100

uint8(diff2)
uint8(diff3)
uint8(diff4)

msgs_mrks = readMessages(markers_coo,    'DataFormat','struct');
msgs_rb   = readMessages(rigidbody_pose, 'DataFormat','struct');









