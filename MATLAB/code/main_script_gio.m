%% tf rviz fottetevi
clc
clear
close all

%% load bag file 
bag = rosbag("../bag_file/2019-06-20-20-05-52.bag");
% bag = rosbag("../bag_file/test.bag");

% rosbag info '2019-06-20-20-05-52.bag';

selec=select(bag,'Topic','markers_coo');
msgStructs = readMessages(selec,'DataFormat','struct');
msgStructs{1};

% setting the sizes
num_el=size(msgStructs{1,1}.Data,1);
num_mrks=num_el/3;
num_msgs=length(msgStructs);
%% load data in the V matrix and flip y with z
V=zeros(num_mrks,3,num_msgs);
for i=1:num_msgs
    for j=1:num_mrks
        V(j,:,i)=(msgStructs{i,1}.Data((j-1)*3+1:(j-1)*3+3,1))';
    end
end
temp=zeros(num_mrks,num_msgs);
temp(:,:)=V(:,2,:);
V(:,2,:)=V(:,3,:);
V(:,3,:)=temp(:,:);

%% get time
start = bag.StartTime;

%time of every single msg
timeArray=table2array(bag.MessageList(:,1));

%% calcola matrice A

Vmedio=meanV(V);

% Vdes=V(:,:,150);
Vdes(1,:)=V(2,:,150);
Vdes(2,:)=V(1,:,150);

A=findA(Vmedio,Vdes);


%% riodina i markers



%% grafica

% plot3([msgArray(1,1),msgArray(1,4)],[msgArray(1,2),msgArray(1,5)],[msgArray(1,6),msgArray(1,6)],'o-');
% plot3(V(:,1,1),V(:,2,1),V(:,3,1),'-o')





