clc
clear
close all

rosinit('130.251.13.104')
msgtype1 = rostopic('type','/markers_coo');
msg1 = rosmessage(msgtype1)
msgtype2 = rostopic('type','/Robot_1/pose');
msg2 = rosmessage(msgtype2)
rosshutdown

