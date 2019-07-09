% clc
% clear
% close all

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
%
% for i=1:size(V(1,1).field,1)
% dist(i) = norm(RB(1,1).field - V(1,1).field(i,:));
% end
% dist
% [a,ind]=min(dist)
%
% dist(ind)=[];
% dist
% [a2,ind2]=min(dist)

% riga:     dove lo vuoi
% colonna:  dove lo cerchi

% bag_name="../../bag_file/tutta_mano_difettosa.bag";
% bag = rosbag(bag_name);
%
% markers_coo=select(bag,'Time',[bag.StartTime bag.StartTime+1],'Topic','markers_coo');
% rigidbody_pose=select(bag,'Topic','Robot_1/pose');

% my_plot(V(1358,1).field)
% msgs_mrks = readMessages(markers_coo,    'DataFormat','struct');
% msgs_rb   = readMessages(rigidbody_pose, 'DataFormat','struct');
%
% %% fill the structs
% % create the structs
% V(1,1).field=0;
% RB(1,1).field=0;
%
% % fill the structs
% for i=1:length(msgs_mrks)
%     V(i,1).field=my_reshape(msgs_mrks{i,1}.Data);
% end
%
% for i=1:length(msgs_rb)
%     RB(i,1).field=[msgs_rb{i,1}.Pose.Position.X,msgs_rb{i,1}.Pose.Position.Y,msgs_rb{i,1}.Pose.Position.Z];
% end
%
k=0
for i = 1:10
    for j = 1:100
        if j==10
            k=k+1
            break
        end
    end
    
end
