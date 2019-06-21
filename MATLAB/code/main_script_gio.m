%% tf rviz fottetevi
clc
clear
close all

%% carica bag file e riordina y con z
bag = rosbag("../bag_file/2019-06-20-20-05-52.bag");

% rosbag info '2019-06-20-20-05-52.bag';
selec=select(bag,'Topic','markers_coo');
msgStructs = readMessages(selec,'DataFormat','struct');
msgStructs{1};

num_mrks=size(msgStructs{1,1}.Data,1);
num_msgs=length(msgStructs);

msgArray=zeros(num_msgs,num_mrks);

for i=1:num_msgs
    % mette i dati sulla riga i
    msgArray(i,:)=(msgStructs{i,1}.Data)';
    
    for j=1:num_mrks/3
        % cambia y con z
        temp=msgArray(i,2+3*(j-1));
        msgArray(i,2+3*(j-1))=msgArray(i,3+3*(j-1));
        msgArray(i,3+3*(j-1))=temp;
    end
end

%% get time
start = bag.StartTime;

timeStruct=select(bag,'Time',[start start+1],'Topic', 'markers_coo');
% bag.MessageList(500:505,:)
timeArray=table2array(timeStruct.MessageList(:,1));

%% calcola matrice A


%% riodina i markers



%% grafica



