%% tf rviz sucks
clc
clear
close all

%% load bag file

bag = rosbag("../../bag_file/2019-06-20-20-05-52.bag");
% bag = rosbag("../../bag_file/test.bag");

% rosbag info '2019-06-20-20-05-52.bag';

selec=select(bag,'Topic','markers_coo');
msgStructs = readMessages(selec,'DataFormat','struct');
% msgStructs{1};

% number of msgs
num_el=size(msgStructs{1,1}.Data,1);
num_mrks=num_el/3;
num_msgs=length(msgStructs);

%% compute A

% primo messaggio
V=my_reshape(msgStructs{1,1}.Data);

% Vdes=V(:,:,150);
% Vdes(1,:)=V(2,:,150);
% Vdes(2,:)=V(1,:,150);

Vdes=[  -0.4383   -0.5522    0.7388
    -0.5668   -0.6743    0.7370 ];
A=findA(V,Vdes);

%% sort the markers
W(1,1).field=0;
%TODO settare il valore della Threshold bene!!!!!
threshold=0.01;
for i=1:num_msgs
    if num_mrks == size(msgStructs{i,1}.Data,1)/3
        V=my_reshape(msgStructs{i,1}.Data);
        W(i,1).field=A*V;
    else % se perdiamo dei markers
        V1=A'*W(i-1,1).field;                    %di nuovo disordinato
        V2=my_reshape(msgStructs{i,1}.Data);    %quello nuovo disordinato
        
        ind=findLost(V1,V2,threshold);          %trovo il marker sbagliato
        % cancellare la riga ind in A e metterla in fondo
        % assegnare al valore mancante la stessa pos relativa di prima 
        % (dist tra mrkrs fissata)
        % fare questo processo più volte, potrebbero mancare più mrkrs
        
        
        
        
    end
end


%
% %% get time
% start = bag.StartTime;
%
% %time of every single msg
% timeArray=table2array(bag.MessageList(:,1));
%
% %% grafica
%
% % plot3([msgArray(1,1),msgArray(1,4)],[msgArray(1,2),msgArray(1,5)],[msgArray(1,6),msgArray(1,6)],'o-');
% figure(),plot3(V(:,1,1),V(:,2,1),V(:,3,1),'-o')
% figure()
% plot3(W(:,1,1),W(:,2,1),W(:,3,1),'-or')
% text(coords(1), coords(2), [int2str(i) '   '], 'Color', 'yellow', 'HorizontalAlignment', 'right', 'FontSize', 9);
%
%
%
%
%
