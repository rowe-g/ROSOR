#include <ros.h>
#include <std_msgs/UInt16.h>
#include <Servo.h>
 
ros::NodeHandle nh;
Servo myservo;  
int servoPin=9;
 
void messageCb(std_msgs::UInt16 servo_msg)
{   
    myservo.write(servo_msg.data);             
    delay(15); 
}
 
ros::Subscriber<std_msgs::UInt16> sub("servo_control", &messageCb );
 
void setup()
{
  myservo.attach(servoPin);
  nh.initNode();
  nh.subscribe(sub);
}
 
void loop()
{
  nh.spinOnce();
  delay(1);
}
