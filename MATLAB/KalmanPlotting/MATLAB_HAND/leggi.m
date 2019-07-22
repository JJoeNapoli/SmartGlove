close all
clear 
clc

%% load bag file
bag = rosbag("2019-07-22-17-54-10.bag");
bagselect2 = select(bag,'Topic','kalman_topic');
allMsgs = readMessages(bagselect2,'DataFormat','struct');
n=12;

%% set IMU idees
id=[0,1,2,3,4,5,15,16,17,18,19,20];

count = 1;

roll = ones(n,size(allMsgs,1)+1)*1000;
pitch = ones(n,size(allMsgs,1)+1)*1000;

for i=2:size(allMsgs,1)
    if allMsgs{i,1}.Id > allMsgs{i-1,1}.Id
        
        for ii=1:length(id)+1
            if id(ii)==allMsgs{i,1}.Id
                break;
            end
            if ii==length(id)+1
                error('IMU not recognized')
            end
        end
        
        roll(ii,count) = allMsgs{i, 1}.KalAngleX;
        pitch(ii,count)= allMsgs{i, 1}.KalAngleY;
        
    else
        
        for ii=1:length(id)+1
            if id(ii)==allMsgs{i,1}.Id
                break;
            end
            if ii==length(id)+1
                error('IMU not recognized')
            end
        end
        
        count=count+1;
        roll(ii,count) = allMsgs{i, 1}.KalAngleX;
        pitch(ii,count)= allMsgs{i, 1}.KalAngleY;
        
    end
    
    
end

temp=roll;
clear roll
roll=temp(:,1:count);
temp=pitch;
clear pitch
pitch=temp(:,1:count);

for i=1:n
    if roll(i,1)==1000
        roll(i,1)=roll(i,2);
    end
    if pitch(i,1)==1000
        pitch(i,1)=pitch(i,1);
    end
    if roll(i,count)==1000
        roll(i,count)=roll(i,count-1);
    end
    if pitch(i,count)==1000
        pitch(i,count)=pitch(i,count-1);
    end
end

for i=1:no
    for j=2:count-1
        
        if roll(i,j)==1000
            roll(i,j)=roll(i,j-1)+roll(i,j+1);
            roll(i,j)=roll(i,j)/2;
        end
        if pitch(i,j)==1000
            pitch(i,j)=pitch(i,j-1)+pitch(i,j+1);
            pitch(i,j)=pitch(i,j)/2;
        end
        
    end
end


% hand = SGparadigmatic;
%
% [~,S] = SGsantelloSynergies;
%
% qm = zeros(1,20);
%
% figure(2)
%
% for i=1:size(roll,2)
%
%     qm(1,6) = -roll(3,i)*(pi/180);
%     qm(1,7) = -roll(4,i)*(pi/180)-qm(1,6);
%
%     qm(1,10) = -roll(5,i)*(pi/180);
%     qm(1,11) = -roll(6,i)*(pi/180)-qm(1,10);
%
%     qm(1,14) = -roll(7,i)*(pi/180);
%     qm(1,15) = -roll(8,i)*(pi/180)-qm(1,14);
%
%     qm(1,18) = -roll(9,i)*(pi/180);
%     qm(1,19) = -roll(10,i)*(pi/180)-qm(1,18);
%
%     hand = SGdefineSynergies(hand,S(:,1:4),qm);
%
%     %figure(1)
%     %SGplotHand(hand);
%
%     hand = SGmoveHand(hand,qm);
%     grid on
%
%     SGplotHand(hand);
%     hold on
%     grid on
%
%     pause(0.00001)
%
%     clf
%
% end


