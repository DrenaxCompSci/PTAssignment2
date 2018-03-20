//Initial design for the Kinect GUI. This application was used to primarily design the Kinect GUI and was integrated successfully into the Kinect application. 
// The integration of using 2 application windows was achieved by using a control frame in the Kinect application to contain the kinect controls GUI. 

import processing.serial.*; //library used to access serial ports
import controlP5.*; //library to create GUI
import java.awt.Robot;
import java.awt.AWTException;
import java.awt.event.InputEvent;
import java.awt.event.KeyEvent;

Robot robot;
Serial port; //Defining serial port to read and write to.
PFont font; //create font object
ControlP5 cp5;  //create Controlp5 object

String input;
//Defining all buttons used
Button toggleNightVision;
Button capture;
Button up;
Button down;

void setup()
{
  
  printArray(Serial.list()); //used to find the name of the serial port on my Mac that the Arduino is using
  port = new Serial(this,"/dev/tty.Bluetooth-Incoming-Port", 9600); //name of serial port Arduino is using on my Mac or the serial port the Xbee is plugged into
  cp5 = new ControlP5(this); //create new cp5
  
  size(270, 400); //width & height of GUI
  font = createFont("calibri light", 20); //set custom font
  
    toggleNightVision = cp5.addButton("Toggle_Night_Vision") //forward button
    .setPosition(10, 50)
     .setColorBackground(color(0,0))
    .setSize (250, 80)
    .setFont(font);
    
    up = cp5.addButton("up") // 
    .setPosition(20, 150)
    .setColorBackground(color(0,0))
    .setSize (100, 80)
    .setFont(font);
    
     down = cp5.addButton("down") // 
    .setPosition(150, 150)
    .setColorBackground(color(0,0))
    .setSize (100, 80)
    .setFont(font);
    
      capture = cp5.addButton("capture") //forward button
    .setPosition(10, 250)
     .setColorBackground(color(0,0))
    .setSize (250, 80)
    .setFont(font);
    
//Creating robot
  try { 
    robot = new Robot();
  } catch (AWTException e) {
    e.printStackTrace();
    exit();
  }
}

void draw() 
{
  background(255, 255, 255); //set background colour (R,G,B)
  
  //GUI title 
  fill(0, 0, 0); //text colour (R,G,B) 
  textFont(font);//set font of text
  
  if ( port.available() > 0) 
    {  
        input = port.readString(); 
        println(input);
    }
 
}

void up(){
  robot.keyPress(KeyEvent.VK_UP);
  robot.keyRelease(KeyEvent.VK_UP);
   if (keyCode == UP){
  System.out.println("up");
   } 
}

void down(){
  robot.keyPress(KeyEvent.VK_DOWN);
  robot.keyRelease(KeyEvent.VK_DOWN);
   if (keyCode == DOWN){
  System.out.println("down");
   } 
}

void capture(){
  robot.keyPress(KeyEvent.VK_H);
  robot.keyRelease(KeyEvent.VK_H);
   if (keyCode == 'H'){
  System.out.println("Capturing image...");
   } 
}

void Toggle_Night_Vision(){
  robot.keyPress(KeyEvent.VK_I);
  robot.keyRelease(KeyEvent.VK_I);
   if (keyCode == 'I'){
  System.out.println("Changing camera...");
   } 
}