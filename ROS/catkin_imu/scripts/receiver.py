#!/usr/bin/env python

import socket
import rospy
from catkin_imu.msg import Imu_msg

UDP_IP = "130.251.13.119"
UDP_PORT = 5001


def listener():
	sock = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)                      
	sock.bind((UDP_IP, UDP_PORT)) 
	
	while not rospy.is_shutdown():
		data, addr = sock.recvfrom(1024) # buffer size is 1024 bytes
		
		print("received messages:", data)
		data=data.decode("utf-8")
		
		
		Ax=(float(data[data.index("A")+1:data.index("B")]))
		Ay=(float(data[data.index("B")+1:data.index("C")]))
		Az=(float(data[data.index("C")+1:data.index("D")]))
		Gx=(float(data[data.index("D")+1:data.index("E")]))
		Gy=(float(data[data.index("E")+1:data.index("F")]))
		Gz=(float(data[data.index("F")+1:data.index("G")]))
		Id=(float(data[data.index("G")+1:data.index("H")]))	
		timer=(int(data[data.index("H")+1:data.index("I")]))	
		
		pub = rospy.Publisher('raw_topic', Imu_msg)
		r = rospy.Rate(10) #10hz
		msg = Imu_msg()
		msg.Ax = Ax
		msg.Ay = Ay
		msg.Az = Az
		msg.Gx = Gx
		msg.Gy = Gy
		msg.Gz = Gz
		msg.Id = Id
		msg.timer=timer
		
		rospy.loginfo(msg)
		pub.publish(msg)
		r.sleep()
				
		
		

if __name__ == '__main__':	
	rospy.init_node('raw_node', anonymous=True)		
	listener()
	
