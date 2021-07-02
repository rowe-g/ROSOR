/* 
 * rosserial Subscriber Example
 * Blinks an LED on callback
 */

#include <ros.h>
#include <std_msgs/Empty.h>
#include <geometry_msgs/Twist.h>
#include <Servo.h>

int motor1=13;   //右侧轮子I1  PC8 右电机的占空比
int motor2=12;   //右侧轮子I2  PC6 右电机的正反转
int motor3=8;  //左侧轮子I1   PC9 左电机的占空比
int motor4=7;  //左侧轮子I2   PC7 左电机的正反转
int en1=10;    //定义右侧轮子的占空比
int en2=9;     //定义左侧轮子的占空比

int value1=80;//定义占空比的大小
int value2=20;

void forward()
{
  digitalWrite(motor1,HIGH);
  digitalWrite(motor2,LOW);
  digitalWrite(motor3,HIGH);
  digitalWrite(motor4,LOW);
  analogWrite(en1,value1);
  analogWrite(en2,value1);
}

void backward()
{
  digitalWrite(motor1,LOW);
  digitalWrite(motor2,HIGH);
  digitalWrite(motor3,LOW);
  digitalWrite(motor4,HIGH);
  analogWrite(en1,value1);
  analogWrite(en2,value1);
}

void turnleft()
{
  digitalWrite(motor1,HIGH);
  digitalWrite(motor2,LOW);
  digitalWrite(motor3,LOW);
  digitalWrite(motor4,LOW);
  analogWrite(en1,value2);
  analogWrite(en2,value2);
}

void turnright()
{
  digitalWrite(motor1,LOW);
  digitalWrite(motor2,LOW);
  digitalWrite(motor3,HIGH);
  digitalWrite(motor4,LOW);
  analogWrite(en1,value2);
  analogWrite(en2,value2);
}

void stop1()
{
  digitalWrite(motor1,LOW);
  digitalWrite(motor2,LOW);
  digitalWrite(motor3,LOW);
  digitalWrite(motor4,LOW);
//  analogWrite(en1,value2);
//  analogWrite(en2,value2);
}


ros::NodeHandle  nh;
//Servo servo_up;
//Servo servo_down;
int up_read = 90;
//int down_read = 90;


void messageCb(const geometry_msgs::Twist& twist ){
  up_read = twist.linear.x;
//  down_read = msg.linear.y;
  
}

ros::Subscriber<geometry_msgs::Twist> sub("servo", &messageCb );

void setup()
{   // put your setup code here, to run once:
  pinMode(motor1,OUTPUT);
  pinMode(motor2,OUTPUT);
  pinMode(motor3,OUTPUT);
  pinMode(motor4,OUTPUT);

  pinMode(en1, OUTPUT);
  pinMode(en2, OUTPUT);
  
  digitalWrite(motor1, LOW);
  digitalWrite(motor2, LOW);
  digitalWrite(motor3, LOW);
  digitalWrite(motor4, LOW);
 
  //set direction；
  digitalWrite(en1, LOW);
  digitalWrite(en2, LOW);


  nh.initNode();
  nh.subscribe(sub);
}

void loop()
{  
  nh.spinOnce();

  if(up_read==20){
    forward();
    }

  if(up_read==50){
    backward();
    }

  if(up_read==100){
    stop1();
    }

  
  delay(1);
  
}
