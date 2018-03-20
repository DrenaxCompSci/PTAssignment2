//Kinect code example used and modified: https://github.com/shiffman/OpenKinect-for-Processing
//MQTT example code used and modified: https://github.com/256dpi/processing-mqtt
//Control frame: https://forum.processing.org/one/topic/controlp5-multiple-sketch-frame-windows-and-controls-on-each.html

//This code only runs smoothly on a laptop. Both GUIs load on a Raspberry Pi 3, but the response time is too long to use effectively. 

import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import processing.serial.*; //library used to access serial ports
import controlP5.*; //library to create GUI
import static javax.swing.JOptionPane.*;
import java.util.Calendar;
import mqtt.*;

Serial port; //Defining serial port to read and write to.

//Variables for GUI design
PFont font; //create font object
ControlP5 cp5;  //create Controlp5 object
kinectControls cf;

//Variables to obtain the current time from the system
Calendar rightNow = Calendar.getInstance();
int hour = rightNow.get(Calendar.HOUR_OF_DAY);
int lastHour = 25;

//Kinect variables 
String message =  "Kinect camera starting...";
Kinect kinect; //Kinect object
float tilt; //Tilt variable to move kinect up and down 
boolean nightVision = false;
boolean flag = false; 
int value; 

//MQTT variables
MQTTClient client;
String topic = "PT"; //Same as Pi Camera topic

void settings() {
  size(600,520,P3D); //Set kinect GUI size 
}
void setup() {
  client = new MQTTClient(this);
  client.connect("mqtt://192.168.10.124", "Kinect"); //Connect to broker
  client.subscribe(topic); //Subscribe to test topic
  
  //size(600, 520); //Set kinect output image size
  kinect = new Kinect(this); //Initialise kinect object to plugged in kinect
  kinect.initVideo(); //Initialise video from kinect
  kinect.enableIR(true); //Enable infra red
  tilt = kinect.getTilt(); 
  
  cf = new kinectControls(this, 400, 380, "Controls");
  surface.setLocation(420,10);
  noStroke();
  
  font = createFont("calibri light", 20); //set custom font
}

void draw() {
  background(0);
  image(kinect.getVideoImage(), 0, 0); //Set video image in centre of frame
  text(message, 10, 510);
  keyPressed();
    if(hour != lastHour){
     System.out.println("Automatically setting Kinect lense format...");
     message = "Automatically setting Kinect lense format...";
     cameraTime();
    }
}

void cameraTime(){
  System.out.println("setting camera lense...");
  if((hour >= 9) && (hour < 19)){
    kinect.enableIR(false); //Disable infra red
    nightVision = false;
    System.out.println("Day time detected. Disabling IR...");
    message = "Day time detected. Disabling IR...";
  }else if(hour >= 19){
    kinect.enableIR(true); //Enable infra red
    nightVision = true;
    System.out.println("Night time detected. Enabling night vision...");
    message = "Night time detected. Enabling IR...";
  }else if(hour < 9){
    kinect.enableIR(true); //Enable infra red
    nightVision = true;
    System.out.println("Night time detected. Enabling night vision...");
    message = "Night time detected. Enabling IR...";
  }
   lastHour = hour;
  

}

//Function used to set the default camera used depending on the time of day 
void keyPressed() {
    if (value == 1){ //If up key is pressed -- Keycode detects up, down left, right or shift
      tilt+=10;
      System.out.println("Tilting Kinect up");
      message = "Tilting Kinect up...";
      value = 0;
    } else if (value == 2) {// If down key is pressed
      tilt-=10;
      message = "Tilting Kinect down...";
      System.out.println("Tilting Kinect down...");
      value = 0;
    } else if (value == 3){
      saveFrame("security_" + rightNow.getTime().toString() + ".jpg");
       System.out.println("value " + value);
       showMessageDialog(null, "Success! Image captured.", 
      "Kinect Camera", ERROR_MESSAGE);
       message = "Image captured and saved to kinect directory.";
       value = 0;
    } else  if(value == 4){
      value = 0;
      nightVision = !nightVision;
      kinect.enableIR(nightVision);
      if(nightVision == false){
         message = "Switching night vision off. Normal lense enabled...";
      System.out.println("Toggling Night Vision...");
      }else{
        message = "Switching night vision on. Normal lense disabled...";
      }
    } 
    tilt = constrain(tilt, 0, 30); //Limit how far the kinect can be tilted
    kinect.setTilt(tilt); //Set the new tilt after a key press
  }
  
  //Function used when a message is received on topic via Paho MQTT
  void messageReceived(String topic, byte[] payload) {
  println("new message: " + topic + " - " + new String(payload)); //Print message received from broker that is published on topic
  saveFrame("security_" + rightNow.getTime().toString() + ".jpg");
  System.out.println("Automated picture taken!");
  message = "Automated picture taken!";
  
}
  
 
 //Class used to create secondary GUI 
  class kinectControls extends PApplet {

  int w, h;
  PApplet parent;
  ControlP5 cp5;

  public kinectControls(PApplet _parent, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(w,h);
  }

  public void setup() {
    surface.setLocation(10,10);
    font = createFont("calibri light", 20); //set custom font
    cp5 = new ControlP5(this);
    cp5.addButton("Up").plugTo(parent, "value").setValue(1).setPosition(70, 150).setSize (110, 80).setFont(font);
    cp5.addButton("Down").plugTo(parent, "value").setValue(2).setPosition(210, 150).setSize (110, 80).setFont(font);
    cp5.addButton("Capture").plugTo(parent, "value").setValue(3).setPosition(70,250).setSize (250, 80).setFont(font);
    cp5.addButton("Toggle Night Vision").plugTo(parent, "value").setValue(4).setPosition(70,50).setSize (250, 80).setFont(font);
  }
  

  void draw() {
    background(40);
  }
}