%%
rosinit
%%
master_host='localhost';

node_1 = robotics.ros.Node('node_1',master_host);
node_2 = robotics.ros.Node('node_2',master_host);

test_pub = robotics.ros.Publisher(node_1,'/test_topic','test_msg');
test_pub_msg = rosmessage(test_pub);
test_sub = robotics.ros.Subscriber(node_2,'/test_topic');














