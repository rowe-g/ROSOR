#include <ros.h>
#include <std_msgs/UInt16.h>
#include <Servo.h>
 
ros::NodeHandle nh;
Servo myservo;  
int servoPin=9;
 
void messageCb(geometry_msgs::Twist twist){
 
    digitalWrite(13,HIGH);
    myservo.write(twist.linear.x);              // tell servo to go to position in variable 'pos'
    delay(15);
    digitalWrite(13,LOW);
}
 
ros::Subscriber<geometry_msgs::Twist> sub("cmd_vel", &messageCb );
 
void setup()
{
  pinMode(13, OUTPUT);
  myservo.attach(servoPin);

  if (twist.linear.x == 2.0){

    
    
    }
  
  nh.initNode();
  nh.subscribe(sub);
}
 
void loop()
{
  nh.spinOnce();
  delay(1);
}
