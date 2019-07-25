%% load and fill the structs
function [V,RB] = load_and_fill(bag_name)

% load the bag file
bag = rosbag(bag_name);         

% select the topics
markers_coo=select(bag,'Topic','markers_coo');
rigidbody_pose=select(bag,'Topic','Robot_1/pose');

%% handle time
for i=1:markers_coo.NumMessages
    time_mrkrs(i) = table2array(markers_coo.MessageList(i,1));
end
for i=1:rigidbody_pose.NumMessages
    time_rb(i) = table2array(rigidbody_pose.MessageList(i,1));
end

% set the initial time
t0=min([time_mrkrs(1),time_rb(1)]);

% diff_* will be the ind of the new struct
diff_mrkrs=(time_mrkrs-t0)*100;
diff_rb=(time_rb-t0)*100;

diff_mrkrs=uint32(diff_mrkrs);
diff_rb=uint32(diff_rb);

msgs_mrks = readMessages(markers_coo,    'DataFormat','struct');
msgs_rb   = readMessages(rigidbody_pose, 'DataFormat','struct');

%% fill the structs

% fill the temporary structs
for i=1:length(msgs_mrks)
    V_temp(diff_mrkrs(i)+1,1).field=my_reshape(msgs_mrks{i,1}.Data);
end
for i=1:length(msgs_rb)
    RB_temp(diff_rb(i)+1,1).field=[msgs_rb{i,1}.Pose.Position.X,msgs_rb{i,1}.Pose.Position.Y,msgs_rb{i,1}.Pose.Position.Z];
end

% fill the true structs
j=0;
for i=1:min([length(msgs_mrks),length(msgs_rb)])
    if i==81
    end
    if size(V_temp(i).field,1)~=0 && size(RB_temp(i).field,1)~=0
        j=j+1;
        V(j,1).field=V_temp(i,1).field;
        RB(j,1).field=RB_temp(i,1).field;
    end
end

end

