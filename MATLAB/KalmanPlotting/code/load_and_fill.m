%% load and fill the structs
function [V,RB] = load_and_fill(bag_name)

% load the bag file
bag = rosbag(bag_name);         

% select the topics
%%% SET THE TOPIC
markers_coo=select(bag,'Topic','markers_coo');
rigidbody_pose=select(bag,'Topic','Robot_1/pose');

%%% SET THE RIGHT MESSAGE
msgs_mrks = readMessages(markers_coo,    'DataFormat','struct');
msgs_rb   = readMessages(rigidbody_pose, 'DataFormat','struct');

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


end
