close all
clear all
clc

bag = rosbag("ditaseparate.bag");
bagselect2 = select(bag,'Topic','kalman_topic');
allMsgs = readMessages(bagselect2);
n=12;


for i=1:n
    
    count(i)=0;
    
end

for i=1:size(allMsgs,1)
    
    
    if(allMsgs{i, 1}.Id == 0)
        count(1) = count(1)+1;
        roll(1,count(1))=allMsgs{i, 1}.KalAngleX;
        pitch(1,count(1))=allMsgs{i, 1}.KalAngleY;
    end
    
    if(allMsgs{i, 1}.Id==1)
        count(2)= count(2)+1;
        roll(2,count(2))=allMsgs{i, 1}.KalAngleX;
        pitch(2,count(2))=allMsgs{i, 1}.KalAngleY;
    end
    
    if(allMsgs{i, 1}.Id==2)
        count(3)= count(3)+1;
        roll(3,count(3))=allMsgs{i, 1}.KalAngleX;
        pitch(3,count(3))=allMsgs{i, 1}.KalAngleY;
    end
    
    if(allMsgs{i, 1}.Id==3)
        count= count+1;
        roll(4,count(4))=allMsgs{i, 1}.KalAngleX;
        pitch(4,count(4))=allMsgs{i, 1}.KalAngleY;
    end
    
    if(allMsgs{i, 1}.Id==4)
        count(5)= count(5)+1;
        roll(5,count(5))=allMsgs{i, 1}.KalAngleX;
        pitch(5,count(5))=allMsgs{i, 1}.KalAngleY;
    end
    
    if(allMsgs{i, 1}.Id==5)
        count(6) = count(6)+1;
        roll(6,count(6))=allMsgs{i, 1}.KalAngleX;
        pitch(6,count(6))=allMsgs{i, 1}.KalAngleY;
    end
    
    if(allMsgs{i, 1}.Id==15)
        count= count+1;
        roll(7,count(7))=allMsgs{i, 1}.KalAngleX;
        pitch(7,count(7))=allMsgs{i, 1}.KalAngleY;
    end
    
    if(allMsgs{i, 1}.Id==16)
        count(8) = count(8)+1;
        roll(8,count(8))=allMsgs{i, 1}.KalAngleX;
        pitch(8,count(8))=allMsgs{i, 1}.KalAngleY;
    end
    
    if(allMsgs{i, 1}.Id==17)
        count(9)= count(9)+1;
        roll(9,count(9))=allMsgs{i, 1}.KalAngleX;
        pitch(9,count(9))=allMsgs{i, 1}.KalAngleY;
    end
    
    if(allMsgs{i, 1}.Id==18)
        count(10)= count(10)+1;
        roll(10,count(10))=allMsgs{i, 1}.KalAngleX;
        pitch(10,count(10))=allMsgs{i, 1}.KalAngleY;
    end
    
    if(allMsgs{i, 1}.Id==19)
        count(11)= count(11)+1;
        roll(11,count(11))=allMsgs{i, 1}.KalAngleX;
        pitch(11,count(11))=allMsgs{i, 1}.KalAngleY;
    end
    
    
    if(allMsgs{i, 1}.Id==20)
        count(12) = count(12) +1;
        roll(12,count(12))=allMsgs{i, 1}.KalAngleX;
        pitch(12,count(12))=allMsgs{i, 1}.KalAngleY;
    end
    
end


hand = SGparadigmatic;

[~,S] = SGsantelloSynergies;

qm = zeros(1,20);

figure(2)

for i=1:size(roll,2)
    
    qm(1,6) = -roll(3,i)*(pi/180);
    qm(1,7) = -roll(4,i)*(pi/180)-qm(1,6);
    
    qm(1,10) = -roll(5,i)*(pi/180);
    qm(1,11) = -roll(6,i)*(pi/180)-qm(1,10);
    
    qm(1,14) = -roll(7,i)*(pi/180);
    qm(1,15) = -roll(8,i)*(pi/180)-qm(1,14);
    
    qm(1,18) = -roll(9,i)*(pi/180);
    qm(1,19) = -roll(10,i)*(pi/180)-qm(1,18);
    
    hand = SGdefineSynergies(hand,S(:,1:4),qm);    
    hand = SGmoveHand(hand,qm);
    grid on
    
    SGplotHand(hand);
    hold on
    grid on
    
    pause(0.0001)
    
    clf
    
end


