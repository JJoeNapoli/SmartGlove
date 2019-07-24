#!/usr/bin/env python
import rospy
from catkin_imu.msg import kalman_msg

def callback(data):
		
	rospy.loginfo(data)
				
  
def listener():

    rospy.init_node('topic_node', anonymous=True)

    rospy.Subscriber("kalman_topic", kalman_msg, callback)

    rospy.spin()

if __name__ == '__main__':
    listener()
	
