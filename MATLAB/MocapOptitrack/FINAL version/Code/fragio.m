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


bag_name="../../bag_file/m_6e8_p_far.bag";

bag = rosbag(bag_name);
markers_coo=select(bag,'Topic','markers_coo');
rigidbody_pose=select(bag,'Topic','Robot_1/pose');

for i=1:markers_coo.NumMessages
    time_mrkrs(i) = table2array(markers_coo.MessageList(i,1));
end
for i=1:rigidbody_pose.NumMessages
    time_rb(i) = table2array(rigidbody_pose.MessageList(i,1));
end
t0=min([time_mrkrs(1),time_rb(1)]);

diff_mrkrs=(time_mrkrs-t0)*100;
diff_rb=(time_rb-t0)*100;

diff_mrkrs=uint32(diff_mrkrs);
diff_rb=uint32(diff_rb);
%%
diff_mrkrs(5:960)=diff_mrkrs(5:960)+1
%%
msgs_mrks = readMessages(markers_coo,    'DataFormat','struct');
msgs_rb   = readMessages(rigidbody_pose, 'DataFormat','struct');

V_temp(1,1).field=0;
RB_temp(1,1).field=0;
V(1,1).field=0;
RB(1,1).field=0;

% fill the structs
for i=1:length(msgs_mrks)
    V_temp(diff_mrkrs(i)+1,1).field=my_reshape(msgs_mrks{i,1}.Data);
end
for i=1:length(msgs_rb)
    RB_temp(diff_rb(i)+1,1).field=[msgs_rb{i,1}.Pose.Position.X,msgs_rb{i,1}.Pose.Position.Y,msgs_rb{i,1}.Pose.Position.Z];
end

% fill the true structs
j=0;
for i=1:max([length(msgs_mrks),length(msgs_rb)])
    if size(V_temp(i).field,1)~=0 && size(RB_temp(i).field,1)~=0
        
        j=j+1;
        V(j).field=V_temp(i).field;
        RB(j).field=RB_temp(i).field;
        
    end
    
end













