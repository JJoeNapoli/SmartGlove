#include "ros/ros.h"
#include "std_msgs/String.h"
#include "Kalman.h"
#include "Kalman.cpp"
#include "catkin_imu/Imu_msg.h"
#include "catkin_imu/kalman_msg.h"



int timel [25];
int Id;
float accX,accY,accZ,gyroX,gyroY,gyroZ;
double gyroXangle[25], gyroYangle[25]; // Angle calculated using the gyro only
double compAngleX[25], compAngleY[25]; // Calculated angle using a complementary filter
double kalAngleX[25], kalAngleY[25]; // Calculated angle using a Kalman filter
double dt;

Kalman kalmanX[25]; // Create the Kalman instances
Kalman kalmanY[25];

void chatterCallback(const catkin_imu::Imu_msg::ConstPtr& msg)
{	
  catkin_imu::kalman_msg pmsg;

 // ROS_INFO("I heard: [%s]", msg->data.c_str());
 
  accX = msg->Ax;
  accY = msg->Ay;
  accZ = msg->Az;
  gyroX  = msg->Gx;
  gyroY = msg->Gy;
  gyroZ  = msg->Gz;
  Id = msg->Id;
  
  dt = double((msg->timer - timel[Id]) / 1000000);
  
  timel[Id] = msg->timer;  
  
#ifdef RESTRICT_PITCH // Eq. 25 and 26
  double roll  = atan2(accY, accZ) * (180/3.14);
  double pitch = atan(-accX / sqrt(accY * accY + accZ * accZ)) * (180/3.14); // Convert to RA_TO_GRAD
#else // Eq. 28 and 29
  double roll  = atan(accY / sqrt(accX * accX + accZ * accZ)) * (180/3.14);
  double pitch = atan2(-accX, accZ) * (180/3.14);
#endif

double gyroXrate = gyroX / 131.0; // Convert to deg/s
double gyroYrate = gyroY / 131.0; // Convert to deg/s

#ifdef RESTRICT_PITCH
  // This fixes the transition problem when the accelerometer angle jumps between -180 and 180 degrees
  if ((roll < -90 && kalAngleX[Id] > 90) || (roll > 90 && kalAngleX[Id] < -90)) {
    kalmanX.setAngle(roll);
    compAngleX[Id]= roll;
    kalAngleX[Id] = roll;
    gyroXangle[Id] = roll;
  } else
    kalAngleX[Id] = kalmanX[Id].getAngle(roll, gyroXrate, dt); // Calculate the angle using a Kalman filter

  if (abs(kalAngleX) > 90)
    gyroYrate = -gyroYrate; // Invert rate, so it fits the restriced accelerometer reading
  
  kalAngleY[Id] = kalmanY[Id].getAngle(pitch, gyroYrate, dt);
#else
  // This fixes the transition problem when the accelerometer angle jumps between -180 and 180 degrees
  if ((pitch < -90 && kalAngleY[Id] > 90) || (pitch > 90 && kalAngleY[Id] < -90)) {
    kalmanY[Id].setAngle(pitch);
    compAngleY[Id] = pitch;
    kalAngleY[Id] = pitch;
    gyroYangle[Id] = pitch;
  } else
    kalAngleY[Id] = kalmanY[Id].getAngle(pitch, gyroYrate, dt); // Calculate the angle using a Kalman filter

  if (abs(kalAngleY[Id]) > 90)
    gyroXrate = -gyroXrate; // Invert rate, so it fits the restriced accelerometer reading
	kalAngleX[Id] = kalmanX[Id].getAngle(roll, gyroXrate, dt); // Calculate the angle using a Kalman filter
#endif

  gyroXangle[Id] += gyroXrate * dt; // Calculate gyro angle without any filter
  gyroYangle[Id] += gyroYrate * dt;
  //gyroXangle += kalmanX.getRate() * dt; // Calculate gyro angle using the unbiased rate
  //gyroYangle += kalmanY.getRate() * dt;

  compAngleX[Id] = 0.93 * (compAngleX[Id] + gyroXrate * dt) + 0.07 * roll; // Calculate the angle using a Complimentary filter
  compAngleY[Id] = 0.93 * (compAngleY[Id] + gyroYrate * dt) + 0.07 * pitch;

  // Reset the gyro angle when it has drifted too much
  if (gyroXangle[Id] < -180 || gyroXangle[Id] > 180)
    gyroXangle[Id] = kalAngleX[Id];
  if (gyroYangle[Id] < -180 || gyroYangle[Id] > 180)
    gyroYangle[Id] = kalAngleY[Id];

  ROS_INFO("AccX %d : %f\t", Id, accX);
  ROS_INFO("AccY %d : %f\t", Id, accY);
  ROS_INFO("AccZ %d : %f\t", Id, accZ);

  ROS_INFO("gyroX %d : %f\t", Id, gyroX);
  ROS_INFO("gyroY %d : %f\t", Id, gyroY);
  ROS_INFO("gyroZ %d : %f\t", Id, gyroZ);
  
  ROS_INFO("Roll %d : %lf\t", Id, roll);
  ROS_INFO("GyroXangle %d : %lf\t", Id, gyroXangle[Id]);
  ROS_INFO("CompAngleX %d : %lf\t", Id, compAngleX[Id]);
  ROS_INFO("KalAngleX %d : %lf\t\t", Id, kalAngleX[Id]);
  
  ROS_INFO("Pitch %d : %lf\t", Id, pitch);
  ROS_INFO("GyroYangle %d : %lf\t", Id, gyroYangle[Id]);
  ROS_INFO("CompAngleY %d : %lf\t", Id, compAngleY[Id]);
  ROS_INFO("KalAngleY %d : %lf\t", Id, kalAngleY[Id]);

  ros::NodeHandle nh; 
  ros::Publisher chatter_pub = nh.advertise<catkin_imu::kalman_msg>("kalman_topic", 2000);	
  
  
  
  pmsg.gyroXangle=gyroXangle[Id];
  pmsg.gyroYangle=gyroYangle[Id];
  pmsg.compAngleX=compAngleX[Id];
  pmsg.compAngleY=compAngleY[Id];
  pmsg.kalAngleX=kalAngleX[Id];
  pmsg.kalAngleY=kalAngleY[Id];
  pmsg.timer=timel[Id];
  pmsg.roll=roll;
  pmsg.pitch=pitch;
  pmsg.Id=Id;
  
  chatter_pub.publish(pmsg);
  ros::spin();

}



int main(int argc, char **argv)
{
  
  ros::init(argc, argv, "kalman");
  ros::NodeHandle n;
  ros::Subscriber sub = n.subscribe("raw_topic", 1000, chatterCallback);   
  ros::spin();

  return 0;
}

