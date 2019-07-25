close all
clear all
clc

bag = rosbag("sim4.bag");
bagselect2 = select(bag,'Topic','kalman_topic');
allMsgs = readMessages(bagselect2,'DataFormat','struct');

[rollMatrix] = JointRoll(allMsgs);

rollMatrix(:,1) = rollMatrix(:,1)*(pi/180);

hand = SGparadigmatic;
[~,S] = SGsantelloSynergies;

qm = zeros(1,20);

%R = [cos(theta) 0 sin(theta);0 1 0;-sin(theta) 0 cos(theta)];

for i=1:size(rollMatrix,1)      
    
      
    if(rollMatrix(i,2)==2)
        qm(1,6)=-rollMatrix(i,1);
        handVisualization(qm,hand,S);        
    end
   
    if(rollMatrix(i,2)==3)
        qm(1,7)=-rollMatrix(i,1)-qm(1,6);
        handVisualization(qm,hand,S);        
    end
    
     if(rollMatrix(i,2)==4)
        qm(1,10)=-rollMatrix(i,1);
        handVisualization(qm,hand,S);        
    end
    
    if(rollMatrix(i,2)==5)
        qm(1,11)=-rollMatrix(i,1)-qm(1,10);
        handVisualization(qm,hand,S);        
    end
    
     if(rollMatrix(i,2)==15)
        qm(1,14)=-rollMatrix(i,1);
        handVisualization(qm,hand,S);        
    end
    
    if(rollMatrix(i,2)==16)
        qm(1,15)=-rollMatrix(i,1)-qm(1,14);
        handVisualization(qm,hand,S);        
    end
    
     if(rollMatrix(i,2)==17)
        qm(1,18)=-rollMatrix(i,1);
        handVisualization(qm,hand,S);        
    end
    
    if(rollMatrix(i,2)==18)
        qm(1,19)=-rollMatrix(i,1)-qm(1,18);
        handVisualization(qm,hand,S);        
    end     
    
end