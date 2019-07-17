%%
rosinit
%%
exampleHelperROSCreateSampleNetwork
%%
rostopic list
rostopic info /scan

%%
laser = rossubscriber('/scan')
scandata = receive(laser,10)
%%
figure
plot(scandata,'MaximumRange',7)
%%
robotpose = rossubscriber('/pose',@exampleHelperROSPoseCallback)
global pos
global orient
pause(2)
pos
orient
pause(2)
pos
orient
pause(2)
pos
orient
pause(2)
pos
orient
pause(2)
pos
orient
pause(2)
pos
orient
pause(2)
pos
orient
clear robotpose

%% 
chatterpub = rospublisher('/chatter', 'std_msgs/String')

chattermsg = rosmessage(chatterpub);
chattermsg.Data = 'hello world'

%%
chattersub = rossubscriber('/chatter', @exampleHelperROSChatterCallback)

%%
send(chatterpub,chattermsg);











