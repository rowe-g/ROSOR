/* 
 * rosserial Subscriber Example
 * Blinks an LED on callback
 * 下位机控制样例代码 
 */

#include <ros.h>
#include <std_msgs/Empty.h>
#include <geometry_msgs/Twist.h>
#include <Servo.h>

ros::NodeHandle  nh;
Servo servo_up;
Servo servo_down;
int up_read = 90;
int down_read = 90;
void messageCb(const geometry_msgs::Twist& msg ){
  up_read = msg.linear.x;
  down_read = msg.linear.y;
  
}

ros::Subscriber<geometry_msgs::Twist> sub("servo", &messageCb );

void setup()
{ 
  servo_up.attach(10);
  servo_down.attach(9);
  nh.initNode();
  nh.subscribe(sub);
}

void loop()
{  
  nh.spinOnce();
  servo_up.write(up_read);
  servo_down.write(down_read);
  delay(1);
  
}
